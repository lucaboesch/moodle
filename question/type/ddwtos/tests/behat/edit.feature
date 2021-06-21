@qtype @qtype_ddwtos
Feature: Test editing a drag and drop into text questions
  As a teacher
  In order to be able to update my drag and drop into text questions
  I need to edit them

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
    And the following "question categories" exist:
      | contextlevel          | reference | name           |
      | Activity module       | qbank1    | Test questions |
    And the following "questions" exist:
      | questioncategory | qtype  | name         | template |
      | Test questions   | ddwtos | Drag to text | fox      |
    And I log in as "teacher"
    And I am on "Course 1" course homepage
    And I navigate to "Question bank" in current page administration
    And I follow "Test qbank name"

  @javascript
  Scenario: Edit a drag and drop into text question
    When I choose "Edit question" action for "Drag to text" in the question bank
    And I should see "Choice [[1]]"
    And I should see "Choice [[2]]"
    And I should see "Choice [[3]]"
    And I set the following fields to these values:
      | Question name | Edited question name |
    And I press "id_submitbutton"
    Then I should see "Edited question name"

  @javascript
  Scenario: Cannot update a drag and drop into text question to the unsolvable questions
    When I choose "Edit question" action for "Drag to text" in the question bank
    And I should see "Choice [[1]]"
    And I should see "Choice [[2]]"
    And I should see "Choice [[3]]"
    And I set the following fields to these values:
      | Question name | Edited question name                   |
      | Question text | Choice [[1]] Choice [[2]] Choice [[1]] |
    And I press "id_submitbutton"
    Then I should see "Choice [[1]] has been used more than once without being set to \"Unlimited\". Please recheck this question."
