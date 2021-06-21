@core @core_question @qbank_filter @javascript
Feature: A teacher can pagimate through question bank questions
  In order to paginate questions
  As a teacher
  I must be able to paginate

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email |
      | teacher1 | Teacher | 1 | teacher1@example.com |
    And the following "courses" exist:
      | fullname | shortname | format |
      | Course 1 | C1 | weeks |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
    And the following "activities" exist:
      | activity   | name             | intro                   | course | idnumber |
      | qbank      | Test qbank name  | Test qbank description  | C1     | qbank1   |
    And the following "question categories" exist:
      | contextlevel          | reference | name           |
      | Activity module       | qbank1    | Used category |
    And the following "questions" exist:
      | questioncategory | qtype     | name                  | questiontext                  |
      | Used category    | truefalse | Not on first page     | Write about whatever you want |
    Given 100 "questions" exist with the following data:
      | questioncategory | Used category                 |
      | qtype            | essay                         |
      | name             | Tests question [count]        |
      | questiontext     | Write about whatever you want |
    And I log in as "teacher1"
    And I am on "Course 1" course homepage
    And I navigate to "Question bank" in current page administration
    And I follow "Test qbank name"

  @javascript
  Scenario: Questions can be paginated
    And I should see "Tests question 1"
    And I should not see "Not on first page"
    When I click on "2" "link" in the ".pagination" "css_element"
    Then I should see "Not on first page"
