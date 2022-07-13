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

namespace qbank_columnsortorder;

defined('MOODLE_INTERNAL') || die();

use advanced_testcase;
use context_course;
use core_question\local\bank\question_edit_contexts;
use core_question\local\bank\view;
use moodle_url;
use qbank_columnsortorder\external\set_columnbank_order;
use qbank_columnsortorder\external\set_pinned_columns;
use qbank_columnsortorder\external\set_hidden_columns;
use qbank_columnsortorder\external\set_column_size;

global $CFG;
require_once($CFG->dirroot . '/question/tests/fixtures/testable_core_question_column.php');
require_once($CFG->dirroot . '/question/classes/external.php');

/**
 * Test class for columnsortorder feature.
 *
 * @package    qbank_columnsortorder
 * @copyright  2021 Catalyst IT Australia Pty Ltd
 * @author     Ghaly Marc-Alexandre <marc-alexandreghaly@catalyst-ca.net>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 * @coversDefaultClass \qbank_columnsortorder\column_manager
 */
class column_manager_test extends advanced_testcase {

    /**
     * Setup testcase.
     */
    public function setUp(): void {
        $this->resetAfterTest(true);
        $this->setAdminUser();
        $this->course = $this->getDataGenerator()->create_course();
        // Creates question bank view.
        $this->questionbank = new view(
            new question_edit_contexts(context_course::instance($this->course->id)),
            new moodle_url('/'),
            $this->course
        );

        // Get current view columns.
        $this->columns = [];
        foreach ($this->questionbank->get_visiblecolumns() as $columnn) {
            $this->columns[] = get_class($columnn);
        }
        $this->columnmanager = new column_manager();
    }

    /**
     * Test function get_columns in helper class, that proper data is returned.
     *
     * @covers ::get_columns
     */
    public function test_getcolumns_function(): void {
        $questionlistcolumns = $this->columnmanager->get_columns();
        $this->assertIsArray($questionlistcolumns);
        foreach ($questionlistcolumns as $columnnobject) {
            $this->assertObjectHasAttribute('class', $columnnobject);
            $this->assertObjectHasAttribute('name', $columnnobject);
            $this->assertObjectHasAttribute('colname', $columnnobject);
        }
    }

    /**
     * Test function sort columns method.
     *
     * @covers ::get_sorted_columns
     */
    public function test_get_sorted_columns(): void {
        $neworder = $this->columnmanager->get_sorted_columns($this->columns);
        shuffle($neworder);
        set_columnbank_order::execute($neworder);
        $currentconfig = get_config('qbank_columnsortorder', 'enabledcol');
        $currentconfig = explode(',', $currentconfig);
        ksort($currentconfig);
        $this->assertSame($neworder, $currentconfig);
    }

    /**
     * Test function set columns order method.
     *
     * @covers ::set_column_order
     * @covers ::save_preference
     */
    public function test_set_column_order(): void {
        // Site admin config.
        $columns = $this->columnmanager->get_sorted_columns($this->columns);
        shuffle($columns);
        set_columnbank_order::execute($columns);
        $colmanager = new column_manager();
        $currentconfig = $colmanager->columnorder;
        $this->assertSame($columns, array_keys($currentconfig));

        // User preference.
        // Move last element to the beginning.
        $lastindex = count($columns) - 1;
        $last = $columns[$lastindex];
        unset($columns[$lastindex]);
        array_unshift($columns, $last);
        set_columnbank_order::execute($columns, 'user_pref');
        $colmanager = new column_manager('user_pref');
        $userpref = $colmanager->columnorder;
        $this->assertSame($columns, array_keys($userpref));

        // Default config is not changed.
        $colmanager = new column_manager();
        $newconfig = $colmanager->columnorder;
        $this->assertSame($currentconfig, $newconfig);
        $this->assertNotSame($newconfig, $userpref);
    }

    /**
     * Test function set pinned columns method.
     *
     * @covers ::set_pinned_columns
     * @covers ::save_preference
     */
    public function test_set_pinned_columns(): void {
        // Site admin config.
        $columns = $this->columnmanager->get_sorted_columns($this->columns);
        $pinnedcols = array_slice($columns, 0, 1);
        set_pinned_columns::execute($pinnedcols);
        $colmanager = new column_manager();
        $currentconfig = $colmanager->pinnedcolumns;
        $this->assertSame($pinnedcols, $currentconfig);

        // User preference.
        $pinnedcols = array_slice($columns, 0, 2);
        set_pinned_columns::execute($pinnedcols, 'user_pref');
        $colmanager = new column_manager('user_pref');
        $userpref = $colmanager->pinnedcolumns;
        $this->assertSame($pinnedcols, $userpref);

        // Site admin config is not changed.
        $colmanager = new column_manager();
        $newconfig = $colmanager->pinnedcolumns;
        $this->assertSame($currentconfig, $newconfig);
        $this->assertNotSame($newconfig, $userpref);
    }

    /**
     * Test function set hidden columns method.
     *
     * @covers ::set_hidden_columns
     * @covers ::save_preference
     */
    public function test_set_hidden_columns(): void {
        // Site admin config.
        $columns = $this->columnmanager->get_sorted_columns($this->columns);
        $hiddencols = array_slice($columns, 0, 1);
        set_hidden_columns::execute($hiddencols);
        $colmanager = new column_manager();
        $currentconfig = $colmanager->hiddencolumns;
        $this->assertSame($hiddencols, $currentconfig);

        // User preference.
        $hiddencols = array_slice($columns, 0, 2);
        set_hidden_columns::execute($hiddencols, 'user_pref');
        $colmanager = new column_manager('user_pref');
        $userpref = $colmanager->hiddencolumns;
        $this->assertSame($hiddencols, $userpref);

        // Site admin config is not changed.
        $colmanager = new column_manager();
        $newconfig = $colmanager->hiddencolumns;
        $this->assertSame($currentconfig, $newconfig);
        $this->assertNotSame($newconfig, $userpref);
    }

    /**
     * Test function set columns sizes method.
     *
     * @covers ::set_column_size
     * @covers ::save_preference
     */
    public function test_set_column_size(): void {
        // Site admin config.
        $columns = $this->columnmanager->get_sorted_columns($this->columns);
        $columsizes = [
            [$columns[0], '100px'],
            [$columns[1], '200px'],
        ];
        set_column_size::execute(json_encode($columsizes));
        $colmanager = new column_manager();
        $currentconfig = $colmanager->colsize;
        $this->assertSame($columsizes, json_decode($currentconfig));

        // User preference.
        $columsizes = [
            [$columns[0], '100px'],
        ];
        set_column_size::execute(json_encode($columsizes), 'user_pref');
        $colmanager = new column_manager('user_pref');
        $userpref = $colmanager->colsize;
        $this->assertSame($columsizes, json_decode($userpref));

        // Site admin config is not changed.
        $colmanager = new column_manager();
        $newconfig = $colmanager->colsize;
        $this->assertSame($currentconfig, $newconfig);
        $this->assertNotSame($newconfig, $userpref);
    }

    /**
     * Test function enabing and disablingcolumns.
     *
     * @covers ::enable_columns
     * @covers ::disable_columns
     */
    public function test_enable_disable_columns(): void {
        $neworder = $this->columnmanager->get_sorted_columns($this->columns);
        shuffle($neworder);
        set_columnbank_order::execute($neworder);
        $currentconfig = get_config('qbank_columnsortorder', 'enabledcol');
        $currentconfig = explode(',', $currentconfig);
        $class = $currentconfig[array_rand($currentconfig, 1)];
        $randomplugintodisable = explode('\\', $class)[0];
        $olddisabledconfig = get_config('qbank_columnsortorder', 'disabledcol');
        $this->columnmanager->disable_columns($randomplugintodisable);
        $newdisabledconfig = get_config('qbank_columnsortorder', 'disabledcol');
        $this->assertNotEquals($olddisabledconfig, $newdisabledconfig);
        $this->columnmanager->enable_columns($randomplugintodisable);
        $newdisabledconfig = get_config('qbank_columnsortorder', 'disabledcol');
        $this->assertEmpty($newdisabledconfig);
        $enabledconfig = get_config('qbank_columnsortorder', 'enabledcol');
        $contains = strpos($enabledconfig, $randomplugintodisable);
        $this->assertNotFalse($contains);
        $this->assertIsInt($contains);
    }
}
