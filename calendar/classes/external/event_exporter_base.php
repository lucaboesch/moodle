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

/**
 * Contains event class for displaying a calendar event.
 *
 * @package   core_calendar
 * @copyright 2017 Ryan Wyllie <ryan@moodle.com>
 * @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace core_calendar\external;

defined('MOODLE_INTERNAL') || die();

require_once($CFG->dirroot . "/calendar/lib.php");
require_once($CFG->libdir . "/filelib.php");

use core\external\exporter;
use core_calendar\local\event\container;
use core_calendar\local\event\entities\event_interface;
use core_calendar\local\event\entities\action_event_interface;
use core_calendar\output\humantimeperiod;
use core_course\external\course_summary_exporter;
use core\external\coursecat_summary_exporter;
use renderer_base;
use core\url;

/**
 * Class for displaying a calendar event.
 *
 * @package   core_calendar
 * @copyright 2017 Ryan Wyllie <ryan@moodle.com>
 * @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class event_exporter_base extends exporter {

    /**
     * @var event_interface $event
     */
    protected $event;

    /**
     * Constructor.
     *
     * @param event_interface $event
     * @param array $related The related data.
     */
    public function __construct(event_interface $event, $related = []) {
        $this->event = $event;

        $starttimestamp = $event->get_times()->get_start_time()->getTimestamp();
        $endtimestamp = $event->get_times()->get_end_time()->getTimestamp();
        $groupid = $event->get_group() ? $event->get_group()->get('id') : null;
        $userid = $event->get_user() ? $event->get_user()->get('id') : null;
        $categoryid = $event->get_category() ? $event->get_category()->get('id') : null;

        $data = new \stdClass();
        $data->id = $event->get_id();
        $data->name = $event->get_name();
        $data->description = file_rewrite_pluginfile_urls(
            $event->get_description()->get_value(),
            'pluginfile.php',
            $related['context']->id,
            'calendar',
            'event_description',
            $event->get_id()
        );
        $data->descriptionformat = $event->get_description()->get_format();
        $data->location = \core_external\util::format_text($event->get_location(), FORMAT_PLAIN, $related['context']->id)[0];
        $data->groupid = $groupid;
        $data->userid = $userid;
        $data->categoryid = $categoryid;
        $data->eventtype = $event->get_type();
        $data->timestart = $starttimestamp;
        $data->timeduration = $endtimestamp - $starttimestamp;
        $data->timesort = $event->get_times()->get_sort_time()->getTimestamp();
        $data->timeusermidnight = $event->get_times()->get_usermidnight_time()->getTimestamp();
        $data->visible = $event->is_visible() ? 1 : 0;
        $data->timemodified = $event->get_times()->get_modified_time()->getTimestamp();
        $data->component = $event->get_component();
        $data->overdue = $data->timesort < time();

        if ($repeats = $event->get_repeats()) {
            $data->repeatid = $repeats->get_id();
            $data->eventcount = $repeats->get_num() + 1;
        }

        if ($cm = $event->get_course_module()) {
            $data->modulename = $cm->get('modname');
            $data->instance = $cm->get('id');
            $data->activityname = $cm->get('name');

            $component = 'mod_' . $data->modulename;
            if (!component_callback_exists($component, 'core_calendar_get_event_action_string')) {
                $modulename = get_string('modulename', $data->modulename);
                $data->activitystr = get_string('requiresaction', 'calendar', $modulename);
            } else {
                $data->activitystr = component_callback(
                    $component,
                    'core_calendar_get_event_action_string',
                    [$event->get_type()]
                );
            }
        }

        parent::__construct($data, $related);
    }

    /**
     * Return the list of properties.
     *
     * @return array
     */
    protected static function define_properties() {
        return [
            'id' => ['type' => PARAM_INT],
            'name' => ['type' => PARAM_TEXT],
            'description' => [
                'type' => PARAM_RAW,
                'optional' => true,
                'default' => null,
                'null' => NULL_ALLOWED
            ],
            'descriptionformat' => [
                'type' => PARAM_INT,
                'optional' => true,
                'default' => null,
                'null' => NULL_ALLOWED
            ],
            'location' => [
                'type' => PARAM_RAW,
                'optional' => true,
                'default' => null,
                'null' => NULL_ALLOWED
            ],
            'categoryid' => [
                'type' => PARAM_INT,
                'optional' => true,
                'default' => null,
                'null' => NULL_ALLOWED
            ],
            'groupid' => [
                'type' => PARAM_INT,
                'optional' => true,
                'default' => null,
                'null' => NULL_ALLOWED
            ],
            'userid' => [
                'type' => PARAM_INT,
                'optional' => true,
                'default' => null,
                'null' => NULL_ALLOWED
            ],
            'repeatid' => [
                'type' => PARAM_INT,
                'optional' => true,
                'default' => null,
                'null' => NULL_ALLOWED
            ],
            'eventcount' => [
                'type' => PARAM_INT,
                'optional' => true,
                'default' => null,
                'null' => NULL_ALLOWED
            ],
            'component' => [
                'type' => PARAM_COMPONENT,
                'optional' => true,
                'default' => null,
                'null' => NULL_ALLOWED
            ],
            'modulename' => [
                'type' => PARAM_TEXT,
                'optional' => true,
                'default' => null,
                'null' => NULL_ALLOWED
            ],
            'activityname' => [
                'type' => PARAM_TEXT,
                'optional' => true,
                'default' => null,
                'null' => NULL_ALLOWED
            ],
            'activitystr' => [
                'type' => PARAM_TEXT,
                'optional' => true,
                'default' => null,
                'null' => NULL_ALLOWED
            ],
            'instance' => [
                'type' => PARAM_INT,
                'optional' => true,
                'default' => null,
                'null' => NULL_ALLOWED
            ],
            'eventtype' => ['type' => PARAM_TEXT],
            'timestart' => ['type' => PARAM_INT],
            'timeduration' => ['type' => PARAM_INT],
            'timesort' => ['type' => PARAM_INT],
            'timeusermidnight' => ['type' => PARAM_INT],
            'visible' => ['type' => PARAM_INT],
            'timemodified' => ['type' => PARAM_INT],
            'overdue' => [
                'type' => PARAM_BOOL,
                'optional' => true,
                'default' => false,
                'null' => NULL_ALLOWED
            ],
        ];
    }

    /**
     * Return the list of additional properties.
     *
     * @return array
     */
    protected static function define_other_properties() {
        return [
            'icon' => [
                'type' => event_icon_exporter::read_properties_definition(),
            ],
            'category' => [
                'type' => coursecat_summary_exporter::read_properties_definition(),
                'optional' => true,
            ],
            'course' => [
                'type' => course_summary_exporter::read_properties_definition(),
                'optional' => true,
            ],
            'subscription' => [
                'type' => event_subscription_exporter::read_properties_definition(),
                'optional' => true,
            ],
            'canedit' => [
                'type' => PARAM_BOOL
            ],
            'candelete' => [
                'type' => PARAM_BOOL
            ],
            'deleteurl' => [
                'type' => PARAM_URL
            ],
            'editurl' => [
                'type' => PARAM_URL
            ],
            'viewurl' => [
                'type' => PARAM_URL
            ],
            'formattedtime' => [
                'type' => PARAM_RAW,
            ],
            'formattedlocation' => [
                'type' => PARAM_RAW,
            ],
            'isactionevent' => [
                'type' => PARAM_BOOL
            ],
            'iscourseevent' => [
                'type' => PARAM_BOOL
            ],
            'iscategoryevent' => [
                'type' => PARAM_BOOL
            ],
            'groupname' => [
                'type' => PARAM_RAW,
                'optional' => true,
                'default' => null,
                'null' => NULL_ALLOWED
            ],
            'normalisedeventtype' => [
                'type' => PARAM_TEXT
            ],
            'normalisedeventtypetext' => [
                'type' => PARAM_TEXT
            ],
            'action' => [
                'type' => event_action_exporter::read_properties_definition(),
                'optional' => true,
            ],
            'purpose' => [
                'type' => PARAM_TEXT
            ],
            'branded' => [
                'type' => PARAM_BOOL,
                'optional' => true,
            ],
        ];
    }

    /**
     * Get the additional values to inject while exporting.
     *
     * @param renderer_base $output The renderer.
     * @return array Keys are the property names, values are their values.
     */
    protected function get_other_values(renderer_base $output) {
        $values = [];
        $event = $this->event;
        $legacyevent = container::get_event_mapper()->from_event_to_legacy_event($event);
        $context = $this->related['context'];
        $course = $this->related['course'];
        $values['isactionevent'] = false;
        $values['iscourseevent'] = false;
        $values['iscategoryevent'] = false;
        $values['normalisedeventtype'] = $event->get_type();
        if ($moduleproxy = $event->get_course_module()) {
            // We need a separate property to flag if an event is action event.
            // That's required because canedit return true but action action events cannot be edited on the calendar UI.
            // But they are considered editable because you can drag and drop the event on the month view.
            $values['isactionevent'] = true;
            // Activity events are normalised to "look" like course events.
            $values['normalisedeventtype'] = 'course';
        } else if ($event->get_type() == 'course') {
            $values['iscourseevent'] = true;
        } else if ($event->get_type() == 'category') {
            $values['iscategoryevent'] = true;
        }
        $timesort = $event->get_times()->get_sort_time()->getTimestamp();
        $iconexporter = new event_icon_exporter($event, ['context' => $context]);
        $identifier = 'type' . $values['normalisedeventtype'];
        $stringexists = get_string_manager()->string_exists($identifier, 'calendar');
        if (!$stringexists) {
            // Property normalisedeventtype is used to build the name of the CSS class for the events.
            $values['normalisedeventtype'] = 'other';
        }
        $values['normalisedeventtypetext'] = $stringexists ? get_string($identifier, 'calendar') : '';

        $purpose = 'none';
        $isbranded = false;
        if ($moduleproxy) {
            $purpose = plugin_supports('mod', $moduleproxy->get('modname'), FEATURE_MOD_PURPOSE, 'none');
            $isbranded = component_callback('mod_' . $moduleproxy->get('modname'), 'is_branded') !== null ? : false;
        }
        $values['purpose'] = $purpose;
        $values['branded'] = $isbranded;

        $values['icon'] = $iconexporter->export($output);

        $subscriptionexporter = new event_subscription_exporter($event);
        $values['subscription'] = $subscriptionexporter->export($output);

        $proxy = $this->event->get_category();
        if ($proxy && $proxy->get('id')) {
            $category = $proxy->get_proxied_instance();
            $categorysummaryexporter = new coursecat_summary_exporter($category, ['context' => $context]);
            $values['category'] = $categorysummaryexporter->export($output);
        }

        if ($course && $course->id != SITEID) {
            $coursesummaryexporter = new course_summary_exporter($course, ['context' => $context]);
            $values['course'] = $coursesummaryexporter->export($output);
        }

        $courseid = (!$course) ? SITEID : $course->id;

        $values['canedit'] = calendar_edit_event_allowed($legacyevent, true);
        $values['candelete'] = calendar_delete_event_allowed($legacyevent);

        $deleteurl = new url('/calendar/delete.php', ['id' => $event->get_id(), 'course' => $courseid]);
        $values['deleteurl'] = $deleteurl->out(false);

        $editurl = new url('/calendar/event.php', ['action' => 'edit', 'id' => $event->get_id(),
                'course' => $courseid]);
        $values['editurl'] = $editurl->out(false);
        $viewurl = new url('/calendar/view.php', ['view' => 'day', 'course' => $courseid,
                'time' => $timesort]);
        $viewurl->set_anchor('event_' . $event->get_id());
        $values['viewurl'] = $viewurl->out(false);
        $legacyevent = container::get_event_mapper()->from_event_to_legacy_event($event);
        $humanperiod = humantimeperiod::create_from_timestamp(
            starttimestamp: $legacyevent->timestart,
            endtimestamp: $legacyevent->timestart + $legacyevent->timeduration,
            link: new url(CALENDAR_URL . 'view.php'),
        );
        $values['formattedtime'] = $output->render($humanperiod);
        $values['formattedlocation'] = calendar_format_event_location($legacyevent);

        if ($group = $event->get_group()) {
            $values['groupname'] = format_string($group->get('name'), true,
                ['context' => \context_course::instance($event->get_course()->get('id'))]);
        }

        if ($event instanceof action_event_interface) {
            // Export event action if applicable.
            $actionrelated = [
                'context' => $this->related['context'],
                'event' => $event
            ];
            $actionexporter = new event_action_exporter($event->get_action(), $actionrelated);
            $values['action'] = $actionexporter->export($output);
        }

        return $values;
    }

    /**
     * Returns a list of objects that are related.
     *
     * @return array
     */
    protected static function define_related() {
        return [
            'context' => 'context',
            'course' => 'stdClass?',
        ];
    }
}
