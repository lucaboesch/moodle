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
 * Question history library methods.
 *
 * @package    qbank_history
 * @copyright  2022 Catalyst IT Australia Pty Ltd
 * @author     Safat Shahin <safatshahin@catalyst-au.net>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

/**
 * Question data fragment to get the question html via ajax call.
 *
 * @param $args
 * @return array|string
 */
function qbank_history_output_fragment_question_data($args) {
    if (empty($args)) {
        return '';
    }
    $param = json_decode($args);
    $filtercondition = json_decode($param->filtercondition);
    if (!$filtercondition) {
        return ['', ''];
    }
    $extraparams = json_decode($param->extraparams);
    $params = \core_question\local\bank\helper::convert_object_array($filtercondition);
    $extraparamsclean = [];
    if (!empty($extraparams)) {
        $extraparamsclean = (array) $extraparams;
    }
    $thispageurl = new \moodle_url('/question/bank/history/history.php');
    $thiscontext = \context::instance_by_id($param->contextid);
    $thispageurl->param('cmid', $thiscontext->instanceid);
    $thispageurl->param('entryid', $extraparamsclean['entryid']);
    $thispageurl->param('returnurl', $extraparamsclean['returnurl']);
    $contexts = new \core_question\local\bank\question_edit_contexts($thiscontext);
    $contexts->require_one_edit_tab_cap($params['tabname']);
    $course = get_course($params['courseid']);
    $questionbank = new \qbank_history\question_history_view($contexts, $thispageurl, $course, null, $params, $extraparamsclean);
    list($questionhtml, $jsfooter) = $questionbank->display_questions_table();
    return [$questionhtml, $jsfooter];
}