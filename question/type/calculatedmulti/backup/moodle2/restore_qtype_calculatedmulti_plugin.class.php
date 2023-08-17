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
 * @package    moodlecore
 * @subpackage backup-moodle2
 * @copyright  2010 onwards Eloy Lafuente (stronk7) {@link http://stronk7.com}
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */


defined('MOODLE_INTERNAL') || die();


require_once($CFG->dirroot .
        '/question/type/calculated/backup/moodle2/restore_qtype_calculated_plugin.class.php');

/**
 * restore plugin class that provides the necessary information
 * needed to restore one calculatedmulti qtype plugin.
 *
 * @copyright  2010 onwards Eloy Lafuente (stronk7) {@link http://stronk7.com}
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class restore_qtype_calculatedmulti_plugin extends restore_qtype_calculated_plugin {

    /**
     * @param int $questionid
     * @param int $sequencenumber
     * @param array $response
     * @return array
     */
    public function recode_response($questionid, $sequencenumber, array $response) {
        return $this->step->questions_recode_response_data('multichoice',
                $questionid, $sequencenumber, $response);
    }

    /**
     * Returns the paths to be handled by the plugin at question level
     */
    protected function define_question_plugin_structure() {
        $paths = parent::define_question_plugin_structure();

        $elename = 'calculated_specificoption';
        $elepath = $this->get_pathfor('/calculated_specificoptions/calculated_specificoption');
        $paths[] = new restore_path_element($elename, $elepath);

        return $paths;
    }

    /**
     * Given one question_states record, return the answer
     * recoded pointing to all the restored stuff for calculatedmulti questions
     *
     * answer format is datasetxx-yy:zz, where xx is the itemnumber in the dataset
     * (doesn't need conversion), and both yy and zz are two (hypen speparated)
     * lists of comma separated question_answers, the first to specify the order
     * of the answers and the second to specify the responses.
     *
     * in fact, this qtype behaves exactly like the multichoice one, so we'll delegate
     * recoding of those yy:zz to it
     */
    public function recode_legacy_state_answer($state) {
        $answer = $state->answer;
        $result = '';
        // Datasetxx-yy:zz format.
        if (preg_match('~^dataset([0-9]+)-(.*)$~', $answer, $matches)) {
            $itemid = $matches[1];
            $subanswer  = $matches[2];
            // Delegate subanswer recode to multichoice qtype, faking one question_states record.
            $substate = new stdClass();
            $substate->answer = $subanswer;
            $newanswer = $this->step->restore_recode_legacy_answer($substate, 'multichoice');
            $result = 'dataset' . $itemid . '-' . $newanswer;
        }
        return $result ? $result : $answer;
    }

    /**
     * Process the qtype/calculated_option element
     *
     * @param array $data extra question data
     * @return void
     */
    public function process_calculated_specificoption($data) {
        global $DB;

        // Detect if the question is created or mapped.
        $oldquestionid   = $this->get_old_parentid('question');
        $newquestionid   = $this->get_new_parentid('question');
        $questioncreated = $this->get_mappingid('question_created', $oldquestionid) !== false;

        // If the question has been created by restore, we need to create its
        // question_calculated too.
        if ($questioncreated) {
            // Adjust some columns.
            $obj = new stdClass();
            $obj->question = $newquestionid;
            $obj->allowhtml = $data['allowhtml'] ?? 0;
            // Insert record.
            $DB->insert_record('question_calcmulti_options', $obj);
        }
    }
}
