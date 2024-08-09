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

namespace core_question;

use core_question\local\bank\question_bank_helper;

/**
 * question bank helper class tests.
 *
 * @package    core_question
 * @copyright  2024 onwards Catalyst IT EU {@link https://catalyst-eu.net}
 * @author     Simon Adams <simon.adams@catalyst-eu.net>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 * @covers \core_question\local\bank\question_bank_helper
 */
class question_bank_helper_test extends \advanced_testcase {

    /**
     * Assert that at least 1 module type that shares questions exists and that mod_qbank is in the returned list.
     *
     * @return void
     * @covers ::get_activity_types_with_shareable_questions
     */
    public function test_get_shareable_modules(): void {
        $openmods = question_bank_helper::get_activity_types_with_shareable_questions();
        $this->assertGreaterThanOrEqual(1, $openmods);
        $this->assertContains('qbank', $openmods);
        $this->assertNotContains('quiz', $openmods);
    }

    /**
     * Assert that at least 1 module type that does not share questions exists and that mod_quiz is in the returned list.
     *
     * @return void
     * @covers ::get_activity_types_with_private_questions
     */
    public function test_get_private_modules(): void {
        $closedmods = question_bank_helper::get_activity_types_with_private_questions();
        $this->assertGreaterThanOrEqual(1, $closedmods);
        $this->assertContains('quiz', $closedmods);
        $this->assertNotContains('qbank', $closedmods);
    }

    /**
     * Setup some courses with quiz and qbank module instances and set different permissions for a user.
     * Then assert that the correct results are returned from calls to the class methods.
     *
     * @covers ::get_activity_instances_with_shareable_questions
     * @covers ::get_activity_instances_with_private_questions
     * @return void
     */
    public function test_get_instances(): void {
        global $DB;

        $this->resetAfterTest();
        $user = self::getDataGenerator()->create_user();
        $roles = $DB->get_records('role', [], '', 'shortname, id');
        self::setUser($user);

        $qgen = self::getDataGenerator()->get_plugin_generator('core_question');
        $sharedmodgen = self::getDataGenerator()->get_plugin_generator('mod_qbank');
        $privatemodgen = self::getDataGenerator()->get_plugin_generator('mod_quiz');
        $category1 = self::getDataGenerator()->create_category();
        $category2 = self::getDataGenerator()->create_category();
        $course1 = self::getDataGenerator()->create_course(['category' => $category1->id]);
        $course2 = self::getDataGenerator()->create_course(['category' => $category1->id]);
        $course3 = self::getDataGenerator()->create_course(['category' => $category2->id]);
        $course4 = self::getDataGenerator()->create_course(['category' => $category2->id]);

        $sharedmod1 = $sharedmodgen->create_instance(['course' => $course1]);
        $sharedmod1context = \context_module::instance($sharedmod1->cmid);
        $sharedmod1qcat1 = $qgen->create_question_category(['contextid' => $sharedmod1context->id]);
        $sharedmod1qcat2 = $qgen->create_question_category(['contextid' => $sharedmod1context->id]);
        $privatemod1 = $privatemodgen->create_instance(['course' => $course1]);
        $privatemod1context = \context_module::instance($privatemod1->cmid);
        $privatemod1qcat1 = $qgen->create_question_category(['contextid' => $privatemod1context->id]);
        role_assign($roles['editingteacher']->id, $user->id, \context_module::instance($sharedmod1->cmid));
        role_assign($roles['editingteacher']->id, $user->id, \context_module::instance($privatemod1->cmid));

        $sharedmod2 = $sharedmodgen->create_instance(['course' => $course2]);
        $sharedmod2context = \context_module::instance($sharedmod2->cmid);
        $sharedmod2qcat1 = $qgen->create_question_category(['contextid' => $sharedmod2context->id]);
        $sharedmod2qcat2 = $qgen->create_question_category(['contextid' => $sharedmod2context->id]);
        $privatemod2 = $privatemodgen->create_instance(['course' => $course2]);
        $privatemod2context = \context_module::instance($privatemod2->cmid);
        $privatemod1qcat1 = $qgen->create_question_category(['contextid' => $privatemod2context->id]);
        role_assign($roles['editingteacher']->id, $user->id, \context_module::instance($sharedmod2->cmid));
        role_assign($roles['editingteacher']->id, $user->id, \context_module::instance($privatemod2->cmid));

        // User doesn't have the capability on this one.
        $sharedmod3 = $sharedmodgen->create_instance(['course' => $course3]);
        $privatemod3 = $privatemodgen->create_instance(['course' => $course3]);

        // Exclude this course in the results despite having the capability.
        $sharedmod4 = $sharedmodgen->create_instance(['course' => $course4]);
        role_assign($roles['editingteacher']->id, $user->id, \context_module::instance($sharedmod4->cmid));

        $sharedbanks = question_bank_helper::get_activity_instances_with_shareable_questions(
            [],
            [$course4->id],
            ['moodle/question:add'],
            true
        );

        $count = 0;
        foreach ($sharedbanks as $courseinstance) {
            // Must all be mod_qbanks.
            $this->assertEquals('qbank', $courseinstance->cminfo->modname);
            // Must have 2 categories each bank.
            $this->assertCount(2, $courseinstance->questioncategories);
            // Must not include the bank the user does not have access to.
            $this->assertNotEquals($sharedmod3->name, $courseinstance->name);
            $this->assertNotEquals($privatemod3->name, $courseinstance->name);
            $count++;
        }
        // Expect count of 2 bank instances.
        $this->assertEquals(2, $count);

        $privatebanks = question_bank_helper::get_activity_instances_with_private_questions(
            [$course1->id],
            [],
            ['moodle/question:add'],
            true
        );

        $count = 0;
        foreach ($privatebanks as $courseinstance) {
            // Must all be mod_quiz.
            $this->assertEquals('quiz', $courseinstance->cminfo->modname);
            // Must have 1 category in each bank.
            $this->assertCount(1, $courseinstance->questioncategories);
            // Must only include the bank from course 1;
            $this->assertNotContains($courseinstance->cminfo->course, [$course2->id, $course3->id, $course4->id]);
            $count++;
        }
        // Expect count of 1 bank instances.
        $this->assertEquals(1, $count);
    }

    /**
     * Assert creating a default mod_qbank instance on a course provides the expected boilerplate settings.
     *
     * @return void
     * @covers ::create_default_open_instance
     */
    public function test_create_default_open_instance(): void {
        global $DB;

        $this->resetAfterTest();
        self::setAdminUser();

        $course = self::getDataGenerator()->create_course();

        // Create the instance and assert default values.
        question_bank_helper::create_default_open_instance($course, $course->fullname);
        $modinfo = get_fast_modinfo($course);
        $cminfos = $modinfo->get_instances_of('qbank');
        $this->assertCount(1, $cminfos);
        $cminfo = reset($cminfos);
        $this->assertEquals($course->fullname, $cminfo->get_name());
        $this->assertEquals(0, $cminfo->sectionnum);
        $modrecord = $DB->get_record('qbank', ['id' => $cminfo->instance]);
        $this->assertEquals(question_bank_helper::STANDARD, $modrecord->type);
        $this->assertEmpty($cminfo->idnumber);
        $this->assertEmpty($cminfo->content);

        // Create a system type bank.
        question_bank_helper::create_default_open_instance($course, 'System bank 1', question_bank_helper::SYSTEM);

        // Try and create another system type bank.
        question_bank_helper::create_default_open_instance($course, 'System bank 2', question_bank_helper::SYSTEM);

        $modinfo = get_fast_modinfo($course);
        $cminfos = $modinfo->get_instances_of('qbank');
        $cminfos = array_filter($cminfos, static function($cminfo) {
            global $DB;
            return $DB->record_exists('qbank', ['id' => $cminfo->instance, 'type' => question_bank_helper::SYSTEM]);
        });

        // Can only be 1 system 'type' bank per course.
        $this->assertCount(1, $cminfos);
        $cminfo = reset($cminfos);
        $this->assertEquals('System bank 1', $cminfo->get_name());
        $moddata = $DB->get_record('qbank', ['id' => $cminfo->instance]);
        $this->assertEquals(get_string('systembankdescription', 'mod_qbank'), $moddata->intro);
        $this->assertEquals(1, $cminfo->showdescription);
    }

    /**
     * Assert that getting a default qbank instance on a course works with and without the "$createifnotexists" argument.
     *
     * @return void
     * @covers ::get_default_open_instance_system_type
     */
    public function test_get_default_open_instance_system_type() {
        global $DB;

        $this->resetAfterTest();
        self::setAdminUser();

        $course = self::getDataGenerator()->create_course();
        $modinfo = get_fast_modinfo($course);
        $qbanks = $modinfo->get_instances_of('qbank');
        $this->assertCount(0, $qbanks);
        $qbank = question_bank_helper::get_default_open_instance_system_type($course);
        $this->assertNull($qbank);
        $qbank = question_bank_helper::get_default_open_instance_system_type($course, true);
        $this->assertEquals(get_string('systembank', 'mod_qbank'), $qbank->get_name());
        $modrecord = $DB->get_record('qbank', ['id' => $qbank->instance]);
        $this->assertEquals(question_bank_helper::SYSTEM, $modrecord->type);
    }
}
