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

namespace mod_qbank\local;

use breadcrumb_navigation_node;
use navigation_node;
use theme_boost\hook\before_navbar_prepare_nodes_for_boost;

/**
 * Callback definitions.
 *
 * @package    mod_qbank
 * @copyright  2024 onwards Catalyst IT EU {@link https://catalyst-eu.net}
 * @author     Simon Adams <simon.adams@catalyst-eu.net>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class hook_callbacks {

    /**
     * Modify the items list in theme_boost\boostnavbar before it prepares them for render.
     * As this module type has the feature flag FEATURE_CAN_DISPLAY set to false,
     * we need to make sure that it replaces the section breadcrumb with a link to the course question bank.
     *
     * @param before_navbar_prepare_nodes_for_boost $hook
     * @return void
     */
    public static function before_prepare_nodes_for_boost(before_navbar_prepare_nodes_for_boost $hook): void {
        global $COURSE;

        $navbaritems = $hook->items;
        $page = $hook->page;

        if ($page->context === null || $page->context->contextlevel !== CONTEXT_MODULE) {
            return;
        }

        if ($page->cm === null || $page->cm->modname !== 'qbank') {
            return;
        }

        $newitems = [];

        foreach ($navbaritems as $item) {
            if ($item->key === $page->cm->sectionid && $item->type === navigation_node::TYPE_SECTION) {
                $item = new breadcrumb_navigation_node([
                    'text' => get_string('questionbank_plural', 'core_question'),
                    'action' => \core_question\local\bank\question_bank_helper::get_url_for_qbank_list($COURSE->id),
                ]);
            }

            $newitems[] = $item;
        }

        $hook->items = $newitems;
    }
}
