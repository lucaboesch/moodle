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

namespace mod_feedback\output;

use renderable;
use renderer_base;
use templatable;
use moodle_url;
use core\output\select_menu;
use tool_brickfield\local\htmlchecker\common\body_color_contrast;

/**
 * Class responses_action_bar. The tertiary nav for the responses page
 *
 * @copyright 2021 Peter Dias
 * @license http://www.gnu.org/copyleft/gpl.html GNU Public License
 * @package mod_feedback
 */
class responses_action_bar implements renderable, templatable {
    /** @var \cm_info course module information */
    protected $cm;
    /** @var moodle_url The current url for this page. */
    protected $currenturl;
    /** @var bool Whether the feedback is anonymous */
    protected $anonymous;

    /**
     * responses_action_bar constructor.
     *
     * @param \cm_info $cm course module information.
     * @param moodle_url $pageurl The current page url
     * @param bool $anonymous whether the feedback is anonymous
     */
    public function __construct(\cm_info $cm, moodle_url $pageurl, bool $anonymous) {
        $this->cm = $cm;
        $this->currenturl = $pageurl;
        $this->anonymous = $anonymous;
    }

    /**
     * Export this object for template rendering.
     * @param \renderer_base $output the output renderer
     * @return array
     */
    public function export_for_template(renderer_base $output): array {
        global $PAGE;
        if (has_capability('mod/feedback:viewreports', $this->cm->context)) {
            // Build the navigation drop-down.
            $reporturl = new moodle_url(
                '/mod/feedback/show_entries.php',
                ['id' => $this->cm->id],
            );
            $nonrespondenturl = new moodle_url(
                '/mod/feedback/show_nonrespondents.php',
                ['id' => $this->cm->id],
            );

            if (!$this->anonymous) {
                $menu = [
                    $reporturl->out(false) => get_string('show_entries', 'feedback'),
                    $nonrespondenturl->out(false) => get_string('show_nonrespondents', 'feedback'),
                ];
                $responsesnav = new select_menu(
                    'resultselector',
                    $menu,
                    $PAGE->url->out(false),
                );
                $responsesnav->set_label(
                    get_string('responses', 'feedback'),
                    ['class' => 'visually-hidden']
                );

                return [
                    'navigation' => $responsesnav->export_for_template($output),
                    'headinglevel' => 2,
                ];
            }
        }
    return [];
    }
}
