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

namespace core\task;

use core\di;
use moodle_database;

/**
 * Adhoc task that performs asynchronous updates of webp files.
 *
 * @package    core
 * @copyright  2025 Daniel Ziegenberg
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class webp_mimetype_update_task extends adhoc_task {

    /**
     * Run the adhoc task and update the mime type of webp files.
     */
    public function execute(): void {
        $db = di::get(moodle_database::class);
        // Upgrade webp mime type for existing webp files.
        $condition = $db->sql_like('filename', ':extension', false);
        $sql = "UPDATE {files} SET mimetype = :mimetype WHERE {$condition} AND mimetype != :mimetype";
        $db->execute($sql, ['mimetype' => 'image/webp', 'extension' => '%.webp']);
    }
}
