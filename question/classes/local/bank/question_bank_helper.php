<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

namespace core_question\local\bank;

use cm_info;
use context_course;
use moodle_url;
use stdClass;

defined('MOODLE_INTERNAL') || die();

global $CFG;
require_once($CFG->dirroot . '/lib/questionlib.php');
require_once($CFG->dirroot . '/course/modlib.php');

/**
 * Helper class for qbank sharing.
 *
 * @package    core_question
 * @copyright  2024 onwards Catalyst IT EU {@link https://catalyst-eu.net}
 * @author     Simon Adams <simon.adams@catalyst-eu.net>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class question_bank_helper {

    /** @var array Array of shareable question bank modules keyed by the {modules} table id and the modname as the value.*/
    private static array $sharedmods = [];

    /** @var array Array of non-shareable question bank modules keyed by the {modules} table id and the modname as the value.*/
    private static array $privatemods = [];

    /** @var string the type of qbank module that users create */
    public const STANDARD = 'standard';

    /**
     * The type of shared bank module that the system creates.
     * These are created in course restores when no target context can be found,
     * and also for when a question category cannot be deleted safely due to questions being in use.
     *
     * @var string
     */
    public const SYSTEM = 'system';

    /** @var string The type of shared bank module that the system creates for previews. Not used for any other purpose. */
    public const PREVIEW = 'preview';

    /** @var array Shared bank types */
    public const SHARED_TYPES = [self::STANDARD, self::SYSTEM, self::PREVIEW];

    /** @var string Shareable plugin type */
    public const SHARED = 'shared';

    /** @var string Non-shareable plugin type */
    public const PRIVATE = 'private';

    /** Plugin types */
    public const PLUGIN_TYPES = [self::SHARED, self::PRIVATE];

    /**
     * User preferences record key to store recently viewed question banks.
     */
    public const RECENTLY_VIEWED = 'recently_viewed_open_banks';

    /**
     * Category delimiter used by the SQL to group concatenate question category data.
     */
    private const CATEGORY_DELIMITER = '<->';

    /**
     * Modules that share questions via FEATURE_PUBLISHES_QUESTIONS.
     *
     * @return array
     */
    public static function get_activity_types_with_shareable_questions(): array {
        if (!empty(self::$sharedmods)) {
            return self::$sharedmods;
        }

        $plugins = \core_component::get_plugin_list('mod');
        self::$sharedmods = array_filter(
            array_keys($plugins),
            static fn($plugin) => plugin_supports('mod', $plugin, FEATURE_PUBLISHES_QUESTIONS) &&
                question_module_uses_questions($plugin)
        );

        return self::$sharedmods;
    }

    /**
     * Modules that are closed to sharing questions have FEATURE_USES_QUESTIONS flag only.
     *
     * @return array
     */
    public static function get_activity_types_with_private_questions(): array {
        if (!empty(self::$privatemods)) {
            return self::$privatemods;
        }

        $plugins = \core_component::get_plugin_list('mod');
        self::$privatemods = array_filter(
            array_keys($plugins),
            static fn($plugin) => !plugin_supports('mod', $plugin, FEATURE_PUBLISHES_QUESTIONS) &&
                question_module_uses_questions($plugin)
        );

        return self::$privatemods;
    }

    /**
     * Get records for activity modules that do publish questions, and optionally get their question categories too.
     *
     * @param array $incourseids array of course ids where you want instances included. Leave empty if you want them from all courses.
     * @param array $notincourseids array of course ids where you do not want instances included.
     * @param array $havingcap current user must have these capabilities on each bank context.
     * @param bool $getcategories optionally return the categories belonging to these banks.
     * @param int $currentbankid optionally include the bank id you want included as the first result from the method return.
     * it will only be included if the other parameters allow it.
     * @return stdClass[]
     */
    public static function get_activity_instances_with_shareable_questions(
        array $incourseids = [],
        array $notincourseids = [],
        array $havingcap = [],
        bool $getcategories = false,
        int $currentbankid = 0,
    ): array {
        return self::get_bank_instances(self::SHARED,
            $incourseids,
            $notincourseids,
            $getcategories,
            $currentbankid,
            $havingcap
        );
    }

    /**
     * Get records for activity modules that don't publish questions, and optionally get their question categories too.
     *
     * @param array $incourseids array of course ids where you want instances included. Leave empty if you want them from all courses.
     * @param array $notincourseids array of course ids where you do not want instances included.
     * @param array $havingcap current user must have these capabilities on each bank context.
     * @param bool $getcategories optionally return the categories belonging to these banks.
     * @param int $currentbankid optionally include the bank id you want included as the first result from the method return.
     * it will only be included if the other parameters allow it.
     * @return stdClass[]
     */
    public static function get_activity_instances_with_private_questions(
        array $incourseids = [],
        array $notincourseids = [],
        array $havingcap = [],
        bool $getcategories = false,
        int $currentbankid = 0,
    ): array {
        return self::get_bank_instances(self::PRIVATE,
            $incourseids,
            $notincourseids,
            $getcategories,
            $currentbankid,
            $havingcap
        );
    }

    /**
     * Private method to build the SQL and get records from the DB. Called from public API methods
     * {@see self::get_activity_instances_with_shareable_questions()}
     * {@see self::get_activity_instances_with_private_questions()}
     *
     * @param string $type
     * @param array $incourseids
     * @param array $notincourseids
     * @param bool $getcategories
     * @param int $currentbankid
     * @param array $havingcap
     * @return stdClass[]
     */
    private static function get_bank_instances(
        string $type,
        array $incourseids = [],
        array $notincourseids = [],
        bool $getcategories = false,
        int $currentbankid = 0,
        array $havingcap = [],
    ): array {
        global $DB;

        $pluginssql = [];
        $params = [];

        // Build the SELECT portion of the SQL and include question category joins as required.
        if ($getcategories) {
            $concat = $DB->sql_concat('qc.id',
                "'" . self::CATEGORY_DELIMITER . "'",
                'qc.name',
                "'" . self::CATEGORY_DELIMITER . "'",
                'qc.contextid'
            );
            $groupconcat = $DB->sql_group_concat($concat, ',');
            $select = "SELECT cm.*, {$groupconcat} AS cats";
            $catsql = ' JOIN {context} c ON c.instanceid = cm.id AND c.contextlevel = ' . CONTEXT_MODULE .
                ' JOIN {question_categories} qc ON qc.contextid = c.id AND qc.parent <> 0';
        } else {
            $select = 'SELECT cm.*';
            $catsql = '';
        }

        if ($type === self::SHARED) {
            $plugins = self::get_activity_types_with_shareable_questions();
        } else {
            $plugins = self::get_activity_types_with_private_questions();
        }

        // Build the joins for all modules of the type requested i.e. those that do or do not share questions.
        foreach ($plugins as $key => $plugin) {
            $moduleid = $DB->get_field('modules', 'id', ['name' => $plugin]);
            $sql = "JOIN {{$plugin}} p{$key} ON p{$key}.id = cm.instance
                    AND cm.module = {$moduleid} AND cm.deletioninprogress = 0";
            if ($plugin === 'qbank') {
                $sql .= " AND p{$key}.type <> '" . self::PREVIEW . "'";
            }
            $pluginssql[] = $sql;
        }
        $pluginssql = implode(' ', $pluginssql);

        // Build the SQL to filter out any requested course ids.
        if (!empty($notincourseids)) {
            [$notincoursesql, $notincourseparams] = $DB->get_in_or_equal($notincourseids, SQL_PARAMS_QM, 'param', false);
            $notincoursesql = "AND cm.course {$notincoursesql}";
            $params = array_merge($params, $notincourseparams);
        } else {
            $notincoursesql = '';
        }

        // Build the SQL to include ONLY records belonging to the requested courses.
        if (!empty($incourseids)) {
            [$incoursesql, $incourseparams] = $DB->get_in_or_equal($incourseids);
            $incoursesql = " AND cm.course {$incoursesql}";
            $params = array_merge($params, $incourseparams);
        } else {
            $incoursesql = '';
        }

        // Optionally order the results by the requested bank id.
        if (!empty($currentbankid)) {
            $orderbysql = " ORDER BY CASE WHEN cm.id = ? THEN 0 ELSE 1 END ASC, cm.id DESC ";
            $params[] = $currentbankid;
        } else {
            $orderbysql = '';
        }

        $sql = "{$select}
                FROM {course_modules} cm
                JOIN {modules} m ON m.id = cm.module
                {$pluginssql}
                {$catsql}
                WHERE 1=1 {$notincoursesql} {$incoursesql}
                GROUP BY cm.id
                {$orderbysql}";

        $rs = $DB->get_recordset_sql($sql, $params);
        $banks = [];

        foreach ($rs as $cm) {
            // If capabilities have been supplied as a method argument then ensure the viewing user has at least one of those
            // capabilities on the module itself.
            if (!empty($havingcap)) {
                $context = \context_module::instance($cm->id);
                if (!(new question_edit_contexts($context))->have_one_cap($havingcap)) {
                    continue;
                }
            }
            // Populate the raw record.
            $banks[] = self::get_formatted_bank($cm, $currentbankid);
        }

        return $banks;
    }

    /**
     * Get a list of recently viewed question banks that implement FEATURE_PUBLISHES_QUESTIONS.
     * If any of the stored contexts don't exist anymore then update the user preference record accordingly.
     *
     * @param int $userid
     * @param int $notincourseid if supplied don't return any in this course id
     * @return cm_info[]
     */
    public static function get_recently_used_open_banks(int $userid, int $notincourseid = 0): array {
        $prefs = get_user_preferences(self::RECENTLY_VIEWED, null, $userid);
        $contextids = !empty($prefs) ? explode(',', $prefs) : [];
        if (empty($contextids)) {
            return $contextids;
        }
        $invalidcontexts = [];
        $banks = [];

        foreach ($contextids as $contextid) {
            if (!$context = \context::instance_by_id($contextid, IGNORE_MISSING)) {
                $invalidcontexts[] = $context;
                continue;
            }
            if ($context->contextlevel !== CONTEXT_MODULE) {
                throw new \moodle_exception('Invalid question bank contextlevel: ' . $context->contextlevel);
            }
            [, $cm] = get_module_from_cmid($context->instanceid);
            if (!empty($notincourseid) && $notincourseid == $cm->course) {
                continue;
            }
            $record = self::get_formatted_bank($cm);
            $banks[] = $record;
        }

        if (!empty($invalidcontexts)) {
            $tostore = array_diff($contextids, $invalidcontexts);
            $tostore = implode(',', $tostore);
            set_user_preference(self::RECENTLY_VIEWED, $tostore, $userid);
        }

        return $banks;
    }

    /**
     * Format the instance name and any categories it contains.
     * @param stdClass $cm
     * @param int $currentbankid
     * @return stdClass
     */
    private static function get_formatted_bank(stdClass $cm, int $currentbankid = 0): stdClass {

        $cminfo = cm_info::create($cm);
        $concatedcats = !empty($cm->cats) ? explode(',', $cm->cats) : [];
        $categories = array_map(static function($concatedcategory) use ($cminfo, $currentbankid) {
            $values = explode(self::CATEGORY_DELIMITER, $concatedcategory);
            $cat = new stdClass();
            $cat->id = $values[0];
            $cat->name = $values[1];
            $cat->contextid = $values[2];
            $cat->enabled = $cminfo->id == $currentbankid ? 'enabled' : 'disabled';
            return $cat;
        }, $concatedcats);

        $bank = new stdClass();
        $bank->name = $cminfo->get_formatted_name();
        $bank->modid = $cminfo->id;
        $bank->contextid = $cminfo->context->id;
        $bank->coursenamebankname = "{$cminfo->get_course()->shortname} - {$bank->name}";
        $bank->cminfo = $cminfo;
        $bank->questioncategories = $categories;

        return $bank;
    }

    /**
     * Get the system type mod_qbank instance for this course, optionally create it if it does not yet exist.
     * {@see self::SYSTEM}
     *
     * @param stdClass $course
     * @param bool $createifnotexists
     * @return cm_info|null
     */
    public static function get_default_open_instance_system_type(stdClass $course, bool $createifnotexists = false): ?cm_info {

        $modinfo = get_fast_modinfo($course);
        $qbanks = $modinfo->get_instances_of('qbank');
        $systembank = null;

        if ($systembankids = self::get_mod_qbank_ids_of_type_in_course($course, self::SYSTEM)) {
            // We should only ever have 1 of these.
            $systembankid = reset($systembankids);
            // Filter the course modinfo qbanks by the systembankid.
            $systembanks = array_filter($qbanks, static fn($bank) => $bank->id === $systembankid);
            $systembank = !empty($systembanks) ? reset($systembanks) : null;
        }

        if (!$systembank && $createifnotexists) {
            $systembank = self::create_default_open_instance($course, get_string('systembank', 'mod_qbank'), self::SYSTEM);
        }

        return $systembank;
    }

    /**
     * Get the bank that is used for preview purposes only, optionally create it if it does not yet exist.
     * {@see \qbank_columnsortorder\column_manager::get_questionbank()}
     *
     * @param bool $createifnotexists
     * @return cm_info|null
     */
    public static function get_preview_open_instance_type(bool $createifnotexists = false): ?cm_info {

        $site = get_site();
        $modinfo = get_fast_modinfo($site);
        $qbanks = $modinfo->get_instances_of('qbank');
        $previewbank = null;

        if ($previewbankids = self::get_mod_qbank_ids_of_type_in_course($site, self::PREVIEW)) {
            // We should only ever have 1 of these.
            $previewbankid = reset($previewbankids);
            // Filter the course modinfo qbanks by the previewbankid.
            $previewbanks = array_filter($qbanks, static fn($bank) => $bank->id === $previewbankid);
            $previewbank = !empty($previewbanks) ? reset($previewbanks) : null;
        }

        if (!$previewbank && $createifnotexists) {
            $previewbank = self::create_default_open_instance(get_site(), get_string('previewbank', 'mod_qbank'), self::PREVIEW);
        }

        return $previewbank;
    }

    /**
     * Get course module ids from mod_qbank instances on a course that are of the sub-type provided.
     *
     * @param stdClass $course the course to search
     * @param string $subtype the subtype of mod_qbank {@see self::SHARED_TYPES}
     * @return int[]
     */
    private static function get_mod_qbank_ids_of_type_in_course(stdClass $course, string $subtype): array {
        global $DB;

        if (!in_array($subtype, self::SHARED_TYPES)) {
            throw new \moodle_exception('Invalid question bank type: ' . $subtype);
        }

        $modinfo = get_fast_modinfo($course);
        $qbanks = $modinfo->get_instances_of('qbank');

        if (!empty($qbanks)) {
            $sql = "SELECT cm.id
                      FROM {course_modules} cm
                      JOIN {modules} m ON m.id = cm.module
                      JOIN {qbank} q ON q.id = cm.instance AND cm.module = m.id
                     WHERE cm.course = :course
                       AND q.type = :type";

            return $DB->get_fieldset_sql($sql, ['type' => $subtype, 'course' => $course->id]);
        }

        return [];
    }

    /**
     * Create a bank on the course from default options.
     *
     * @param stdClass $course the course that the new module is being created in
     * @param string $bankname name of the new module
     * @param string $type {@see self::TYPES}
     * @return cm_info
     */
    public static function create_default_open_instance(stdClass $course, string $bankname, string $type = self::STANDARD): cm_info {
        global $DB;

        if (!in_array($type, self::SHARED_TYPES)) {
            throw new \RuntimeException('invalid type');
        }

        // Preview bank must be created at site course.
        if ($type === self::PREVIEW) {
            if ($qbank = self::get_preview_open_instance_type()) {
                return $qbank;
            }
            $course = get_site();
        }

        // We can only have one of these types per course.
        if ($type === self::SYSTEM && $qbank = self::get_default_open_instance_system_type($course)) {
            return $qbank;
        }

        $module = $DB->get_record('modules', ['name' => 'qbank'], '*', MUST_EXIST);
        $context = context_course::instance($course->id);

        // STANDARD type needs capability checks.
        if ($type === self::STANDARD) {
            require_capability('moodle/course:manageactivities', $context);
            if (!course_allowed_module($course, $module->name)) {
                throw new \moodle_exception('moduledisable');
            }
        }

        $data = new stdClass();
        $data->section = 0;
        $data->visible = 0;
        $data->course = $course->id;
        $data->module = $module->id;
        $data->modulename = $module->name;
        $data->groupmode = $course->groupmode;
        $data->groupingid = $course->defaultgroupingid;
        $data->id = '';
        $data->instance = '';
        $data->coursemodule = '';
        $data->downloadcontent = DOWNLOAD_COURSE_CONTENT_ENABLED;
        $data->visibleoncoursepage = 0;
        $data->name = $bankname;
        $data->type = in_array($type, self::SHARED_TYPES) ? $type : self::STANDARD;
        $data->showdescription = $type === self::STANDARD ? 0 : 1;

        $mod = add_moduleinfo($data, $course);

        // Have to set this manually as the system because this bank type is not intended to be created directly by a user.
        if ($type === self::SYSTEM) {
            $DB->set_field('qbank', 'intro', get_string('systembankdescription', 'mod_qbank'), ['id' => $mod->instance]);
            $DB->set_field('qbank', 'introformat', FORMAT_HTML, ['id' => $mod->instance]);
        }

        return get_fast_modinfo($course)->get_cm($mod->coursemodule);
    }

    /**
     * Get the url that shows the banks list of a course.
     *
     * @param int $courseid
     * @param bool $createdefault Pass true if you want the URL to create a default qbank instance when referred.
     * @return moodle_url
     */
    public static function get_url_for_qbank_list(int $courseid, bool $createdefault = false): moodle_url {
        $url = new moodle_url('/question/banks.php', ['courseid' => $courseid]);
        if ($createdefault) {
            $url->param('createdefault', true);
        }
        return $url;
    }
}
