@qtype @qtype_numerical
Feature: Preview a Numerical question
  As a teacher
  In order to check my Numerical questions will work for students
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
      | questioncategory | qtype     | name          | template |
      | Test questions   | numerical | Numerical-001 | pi       |
      | Test questions   | numerical | Numerical-002 | pi3tries |
    And the following "language customisations" exist:
      | component       | stringid | value |
      | core_langconfig | decsep   | #     |
    And I log in as "teacher"
    And I am on "Course 1" course homepage
    And I follow "Test quiz"
    And I navigate to "Question bank" in current page administration

  @javascript @_switch_window
  Scenario: Preview a Numerical question and submit a correct response
    When I choose "Preview" action for "Numerical-001" in the question bank
    And I should see "What is pi to two d.p.?"
    And I expand all fieldsets
    And I set the field "How questions behave" to "Immediate feedback"
    And I press "Start again with these options"
    And I set the field with xpath "//span[@class='answer']//input[contains(@id, '1_answer')]" to "3.14"
    And I press "Check"
    Then I should see "Very good."
    And I should see "Mark 1#00 out of 1#00"
    And I press "Start again"
    And I set the field with xpath "//span[@class='answer']//input[contains(@id, '1_answer')]" to "3,14"
    And I press "Check"
    And I should see "Please enter your answer without using the thousand separator (,)."
    And I press "Start again"
    And I set the field with xpath "//span[@class='answer']//input[contains(@id, '1_answer')]" to "3#14"
    And I press "Check"
    And I should see "Very good."
    And I should see "Mark 1#00 out of 1#00"
