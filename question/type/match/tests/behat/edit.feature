@qtype @qtype_match @javascript
Feature: Test editing a Matching question
  As a teacher
  In order to be able to update my Matching question
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
      | questioncategory | qtype | name                 | template |
      | Test questions   | match | Matching for editing | foursubq |
    And I log in as "teacher"
    And I am on "Course 1" course homepage
    And I navigate to "Question bank" in current page administration
    And I follow "Test qbank name"

  @javascript
  Scenario: Edit a Matching question
    When I choose "Edit question" action for "Matching for editing" in the question bank
    And I set the following fields to these values:
      | Question name | |
    And I press "id_submitbutton"
    And I should see "You must supply a value here."
    And I set the following fields to these values:
      | Question name | Edited Matching name |
    And I press "id_submitbutton"
    And I should see "Edited Matching name"
    And I choose "Edit question" action for "Edited Matching name" in the question bank
    And I set the following fields to these values:
      | Shuffle    | 0   |
      | Question 2 | dog |
      | Question 4 | fly |
    And I press "id_submitbutton"
    Then I should see "Edited Matching name"
    And I choose "Preview" action for "Edited Matching name" in the question bank
    And I should see "frog"
    And I should see "dog"
    And I should see "newt"
    And I should see "fly"
