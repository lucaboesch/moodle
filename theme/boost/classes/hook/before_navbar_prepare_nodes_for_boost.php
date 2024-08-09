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

namespace theme_boost\hook;

use breadcrumb_navigation_node;
use moodle_page;

/**
 * Hook class definition for {@see \theme_boost\boostnavbar}.
 *
 * @package    theme_boost
 * @copyright  2024 onwards Catalyst IT EU {@link https://catalyst-eu.net}
 * @author     Simon Adams <simon.adams@catalyst-eu.net>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
#[\core\attribute\label('Hook dispatched before boost theme navbar prepares nodes for render.')]
#[\core\attribute\tags('theme')]
class before_navbar_prepare_nodes_for_boost {

    /**
     * Initialise the hook with data.
     *
     * @param breadcrumb_navigation_node[] $items
     * @param moodle_page $page
     */
    public function __construct(
        /** @var breadcrumb_navigation_node[] $items array of breadcrumb_navigation_node objects */
        public array $items,
        /** @var moodle_page $page current page */
        public readonly moodle_page $page,
    ) {
    }
}
