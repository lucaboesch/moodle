@qtype @qtype_match @javascript
Feature: Preview a Matching question
  As a teacher
  In order to check my Matching questions will work for students
  I need to preview them

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
      | activity   | name      | course | idnumber |
      | quiz       | Test quiz | C1     | quiz1    |
    And the following "question categories" exist:
      | contextlevel          | reference | name           |
      | Activity module       | quiz1     | Test questions |
    And the following "questions" exist:
      | questioncategory | qtype | name         | template | shuffleanswers |
      | Test questions   | match | matching-001 | foursubq | 0              |
    And I log in as "teacher"
    And I am on "Course 1" course homepage
    And I follow "Test quiz"
    And I navigate to "Question bank" in current page administration

  @javascript
  Scenario: Preview a Matching question and submit a correct response
    When I choose "Preview" action for "matching-001" in the question bank
    And I expand all fieldsets
    And I set the field "How questions behave" to "Immediate feedback"
    And I press "Start again with these options"
    And I set the field "Answer 1" to "amphibian"
    And I set the field "Answer 2" to "mammal"
    And I set the field "Answer 3" to "amphibian"
    And I press "Check"
    Then I should see "Well done!"
    And I should see "General feedback."

  @javascript
  Scenario: Preview a Matching question and submit a partially correct response
    When I choose "Preview" action for "matching-001" in the question bank
    And I expand all fieldsets
    And I set the field "How questions behave" to "Immediate feedback"
    And I press "Start again with these options"
    And I set the field "Answer 1" to "amphibian"
    And I set the field "Answer 2" to "insect"
    And I set the field "Answer 3" to "amphibian"
    And I press "Check"
    Then I should see "Parts, but only parts, of your response are correct."
    And I should see "General feedback."

  @javascript
  Scenario: Preview a Matching question and submit an incorrect response
    When I choose "Preview" action for "matching-001" in the question bank
    And I expand all fieldsets
    And I set the field "How questions behave" to "Immediate feedback"
    And I press "Start again with these options"
    And I set the field "Answer 1" to "mammal"
    And I set the field "Answer 2" to "insect"
    And I set the field "Answer 3" to "insect"
    And I press "Check"
    Then I should see "That is not right at all."
    And I should see "General feedback."
