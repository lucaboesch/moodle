@qtype @qtype_description @javascript
Feature: Test creating a Description question
  As a teacher
  In order to test my students
  I need to be able to create a Description question

  Background:
    Given the following "users" exist:
      | username |
      | teacher  |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
    And the following "course enrolments" exist:
      | user    | course | role           |
      | teacher | C1     | editingteacher |
    And the following "activities" exist:
      | activity   | name             | intro                   | course | idnumber |
      | qbank      | Test qbank name  | Test qbank description  | C1     | qbank1   |
    And I log in as "teacher"
    And I am on "Course 1" course homepage
    And I navigate to "Question bank" in current page administration
    And I follow "Test qbank name"

  Scenario: Create a Description question with Correct answer as False
    And I add a "Description" question filling the form with:
      | Question name                      | description-001                                                |
      | Question text                      | Instructions about the following questions.                    |
      | General feedback                   | Why actually the field 'General feedback' used in this qytype? |
    Then I should see "description-001"
