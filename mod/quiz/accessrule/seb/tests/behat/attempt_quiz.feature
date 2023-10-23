@mod_quiz @quizaccess @quizaccess_seb
Feature: Attempt Safe Exam Browser quiz

  Background:
    Given the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1        |
    And the following "activities" exist:
      | activity | course | section | name   |
      | quiz     | C1     | 1       | Test quiz name |
    And the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher  | Teacher   | Teacher  | teacher@example.com  |
      | student  | Student   | Student  | student1@example.com |
    And the following "course enrolments" exist:
      | user    | course | role           |
      | teacher | C1     | editingteacher |
      | student | C1     | student        |

  Scenario: Access a quiz with "Require the use of Safe Exam Browser" that has future start date.
    When I am on the "Test quiz name" "quiz activity editing" page logged in as admin
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
    When I am on the "Test quiz name" "mod_quiz > View" page logged in as "student"
    Then I should see "This quiz is currently not available."
    And I should not see "Launch Safe Exam Browser"
    And I should not see "Download configuration"
