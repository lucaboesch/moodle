@javascript @mod_quiz @quizaccess @quizaccess_seb
Feature: Quiz start with Safe Exam Browser access rule

  Background:
    Given the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1        |
    And the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
      | student1 | Student   | 1        | student1@example.com |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | student1 | C1     | student        |
    And the following "activities" exist:
      | activity | course | section | name   |
      | quiz     | C1     | 1       | Quiz 1 |
    And the following "question categories" exist:
      | contextlevel | reference | name           |
      | Course       | C1        | Test questions |
    And the following "questions" exist:
      | questioncategory | qtype     | name | questiontext   |
      | Test questions   | truefalse | TF1  | First question |
    And quiz "Quiz 1" contains the following questions:
      | question | page | maxmark |
      | TF1      | 1    |         |

  Scenario: Start a quiz as student with Safe Exam Browser quiz access rule
    When I am on the "Quiz 1" "quiz activity editing" page logged in as teacher1
    And I expand all fieldsets
    And I set the following fields to these values:
      | seb_requiresafeexambrowser | 1 |
    And I press "Save and return to course"
    And I am on the "Quiz 1" "mod_quiz > View" page logged in as "student1"
    Then the "target" attribute of "//a[text()='Download Safe Exam Browser']" "xpath_element" should contain "_blank"

  Scenario: Access a quiz with "Require the use of Safe Exam Browser" that has future start date.
    When I am on the "Quiz 1" "quiz activity editing" page logged in as admin
    And I expand all fieldsets
    And I set the following fields to these values:
      | id_timeopen_enabled | 1 |
      | id_timeopen_day | 1 |
      | id_timeopen_month | 1 |
      | id_timeopen_year | 2037 |
    And I set the field "Require the use of Safe Exam Browser" to "Yes – Configure manually"
    And I press "Save and return to course"
    And I add a "True/False" question to the "Test quiz name" quiz with:
      | Question name                      | First question                          |
      | Question text                      | Answer the first question               |
      | General feedback                   | Thank you, this is the general feedback |
      | Correct answer                     | False                                   |
      | Feedback for the response 'True'.  | So you think it is true                 |
      | Feedback for the response 'False'. | So you think it is false                |
    And I log out
    When I am on the "Quiz 1" "mod_quiz > View" page logged in as "student"
    Then I should see "This quiz is currently not available."
    And I should not see "Launch Safe Exam Browser"
    And I should not see "Download configuration"
