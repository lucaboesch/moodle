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
 * Calculated question type upgrade code.
 *
 * @package    qtype_calculatedmulti
 * @copyright  2011 The Open University
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

defined('MOODLE_INTERNAL') || die();


/**
 * Upgrade code for the calculatedmulti question type.
 * @param int $oldversion the version we are upgrading from.
 * @return bool
 */
function xmldb_qtype_calculatedmulti_upgrade($oldversion) {
    global $DB;

    $dbman = $DB->get_manager(); // Loads ddl manager and xmldb classes.

    if ($oldversion < 2023082201) {

        // Define table question_calcmulti_options to be created.
        $table = new xmldb_table('question_calcmulti_options');

        // Adding fields to table question_calcmulti_options.
        $table->add_field('id', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, XMLDB_SEQUENCE, null);
        $table->add_field('question', XMLDB_TYPE_INTEGER, '10', null, XMLDB_NOTNULL, null, '0');
        $table->add_field('allowhtml', XMLDB_TYPE_INTEGER, '4', null, XMLDB_NOTNULL, null, '0');

        // Adding keys to table question_calcmulti_options.
        $table->add_key('primary', XMLDB_KEY_PRIMARY, ['id']);
        $table->add_key('question', XMLDB_KEY_FOREIGN, ['question'], 'question', ['id']);

        // Conditionally launch create table for question_calcmulti_options.
        if (!$dbman->table_exists($table)) {
            $dbman->create_table($table);
        }

        // Calculatedmulti savepoint reached.
        upgrade_plugin_savepoint(true, 2023082201, 'qtype', 'calculatedmulti');
    }

    return true;
}
