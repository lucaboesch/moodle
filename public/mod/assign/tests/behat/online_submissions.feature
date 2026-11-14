@mod @mod_assign
Feature: In an assignment, students can add and edit text online
  In order to complete my submissions online
  As a student
  I need to submit my assignment editing an online form

  @javascript
  Scenario: Submit a text online and edit the submission
    Given the following "courses" exist:
      | fullname | shortname | category | groupmode |
      | Course 1 | C1 | 0 | 1 |
    And the following "users" exist:
      | username | firstname | lastname | email |
      | teacher1 | Teacher | 1 | teacher1@example.com |
      | student1 | Student | 1 | student1@example.com |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
      | student1 | C1 | student |
    And the following "activity" exists:
      | activity                                      | assign                  |
      | course                                        | C1                      |
      | name                                          | Test assignment name    |
      | intro                                         | Submit your online text |
      | submissiondrafts                              | 0                       |
      | assignsubmission_onlinetext_enabled           | 1                       |
      | assignsubmission_onlinetext_wordlimit_enabled | 1                       |
      | assignsubmission_onlinetext_wordlimit         | 10                      |
      | assignsubmission_file_enabled                 | 0                       |
    And I am on the "Test assignment name" Activity page logged in as student1
    When I press "Add submission"
    And I set the following fields to these values:
      | Online text | This is more than 10 words. 1 2 3 4 5 6 7 8 9 10. |
    And I press "Save changes"
    Then I should see "Please review your submission and try again."
    And I set the following fields to these values:
      | Online text | I'm the student first submission |
    And I press "Save changes"
    Then I should see "Submitted for grading"
    And "View full" "icon" should not exist in the "Online text" "table_row"
    And I should see "I'm the student first submission" in the "Online text" "table_row"
    And I should see "Not graded"
    And I press "Edit submission"
    And I set the following fields to these values:
      | Online text | I'm the student second submission |
    And I press "Save changes"
    Then I should see "Submitted for grading"
    And "View full" "icon" should not exist in the "Online text" "table_row"
    And I should see "I'm the student second submission" in the "Online text" "table_row"
    And I should not see "I'm the student first submission"

  @javascript
  Scenario: Auto-draft save online text submission
    Given the following "courses" exist:
      | fullname | shortname | category | groupmode |
      | Course 1 | C1 | 0 | 1 |
    And the following "users" exist:
      | username | firstname | lastname | email |
      | teacher1 | Teacher | 1 | teacher1@example.com |
      | student1 | Student | 1 | student1@example.com |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
      | student1 | C1 | student |
    And the following "activity" exists:
      | activity                                      | assign                  |
      | course                                        | C1                      |
      | name                                          | Test assignment name    |
      | intro                                         | Submit your online text |
      | submissiondrafts                              | 0                       |
      | assignsubmission_onlinetext_enabled           | 1                       |
      | assignsubmission_file_enabled                 | 0                       |
    And I am on the "Test assignment name" Activity page logged in as student1
    When I press "Add submission"
    And I set the following fields to these values:
      | Online text | text submission |
    # Wait for the draft auto save.
    And I wait "2" seconds
    And I am on the "Test assignment name" Activity page
    When I press "Add submission"
    # Confirm draft was restored.
    Then the field "Online text" matches value "text submission"

  @javascript
  Scenario: When creating an assignment and giving an invalid value to the Word limit field, only one error is shown
    Given the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
    And the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
    When I am on the "Course 1" course page logged in as teacher1
    And I add an assign activity to course "Course 1" section "1"
    And I set the following fields to these values:
      | name                                          | Test assignment |
      | assignsubmission_onlinetext_enabled           | 1               |
      | assignsubmission_onlinetext_wordlimit_enabled | 1               |
      | assignsubmission_onlinetext_wordlimit         | f               |
    And I press "Save and display"
    Then I should see "You must enter a number here." in the "#id_error_assignsubmission_onlinetext_wordlimit" "css_element"
    But I should not see "You must enter a number here." in the "#id_error_assignsubmission_onlinetext_wordlimit_enabled" "css_element"
    And  I should not see "You must enter a number here." in the "#fgroup_id_error_assignsubmission_onlinetext_wordlimit_group" "css_element"

  @javascript
  Scenario: When creating an assignment and giving an invalid value to the Word limit field, only one error is shown
    Given the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
    And the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
    When I am on the "Course 1" course page logged in as teacher1
    And I add an assign activity to course "Course 1" section "1"
    And I set the following fields to these values:
      | name                                          | Test assignment |
      | assignsubmission_onlinetext_enabled           | 1               |
      | assignsubmission_onlinetext_wordlimit_enabled | 1               |
      | assignsubmission_onlinetext_wordlimit         | f               |
    And I press "Save and display"
    Then I should see "You must enter a number here." in the "#id_error_assignsubmission_onlinetext_wordlimit" "css_element"
    But I should not see "You must enter a number here." in the "#id_error_assignsubmission_onlinetext_wordlimit_enabled" "css_element"
    And I should not see "You must enter a number here." in the "#fgroup_id_error_assignsubmission_onlinetext_wordlimit_group" "css_element"
