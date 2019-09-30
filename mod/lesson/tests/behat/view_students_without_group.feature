@mod @mod_lesson
Feature: Viewing Lesson results and grading essays of students, who are not participants of any group
  As a teacher
  I should be able to see Lesson results and grade essays for all visible groups, including students, who are not participants of any group

  @javascript
  Scenario: View lesson results and grade essay
    Given the following "courses" exist:
      | fullname | shortname | groupmode |
      | Course 1 | C1        | 2         |
    And the following "users" exist:
      | username | firstname | lastname | email |
      | teacher  | Test      | Teacher  | teacher@example.com |
      | user1    | Test      | User1    | user1@example.com |
      | user2    | Test      | User2    | user2@example.com |
      | user3    | Test      | User3    | user3@example.com |
      | user4    | Test      | User4    | user4@example.com |
    And the following "course enrolments" exist:
      | user    | course | role           |
      | teacher | C1     | editingteacher |
      | user1   | C1     | student        |
      | user2   | C1     | student        |
      | user3   | C1     | student        |
      | user4   | C1     | student        |
    And the following "groups" exist:
      | name    | course | idnumber |
      | Group 1 | C1     | G1       |
      | Group 2 | C1     | G2       |
    And the following "group members" exist:
      | user        | group |
      | user1       | G1    |
      | user2       | G1    |
      | user3       | G2    |
    When I log in as "teacher"
    And I am on "Course 1" course homepage
    And I turn editing mode on
    And I add a "Lesson" to section "0" and I fill the form with:
      | Name | lesson1 |
      | Description | Test lesson description |
    And I follow "lesson1"
    And I follow "Add a question page"
    And I set the field "Select a question type" to "Multichoice"
    And I press "Add a question page"
    And I set the following fields to these values:
      | Page title | page1 |
      | Page contents | choose yes or no |
      | id_answer_editor_0 | yes |
      | id_score_0 | 1 |
      | id_jumpto_0 | Next page |
      | id_answer_editor_1 | no |
      | id_score_1 | 0 |
      | id_jumpto_1 | Next page |
    And I press "Save page"
    And I click on "//*[@id='region-main']/div/div[2]/ul[2]/li[2]/a" "xpath_element"
    And I click on "Add a question page here" "link"
    And I set the field "Select a question type" to "Essay"
    And I press "Add a question page"
    And I set the following fields to these values:
      | Page title | page2 |
      | Page contents | write your thoughts |
      | id_score_0 | 4 |
      | id_jumpto_0 | Next page |
    And I press "Save page"
    And I log out
    And I log in as "user1"
    And I am on "Course 1" course homepage
    And I follow "lesson1"
    And I set the field "Your answer" to "I like this lesson"
    And I press "Submit"
    And I should see "choose yes or no"
    And I set the following fields to these values:
      | yes | 1 |
    And I press "Submit"
    And I log out
    And I log in as "user4"
    And I am on "Course 1" course homepage
    And I follow "lesson1"
    And I set the field "Your answer" to "it's a bad lesson"
    And I press "Submit"
    And I should see "choose yes or no"
    And I set the following fields to these values:
      | no | 0 |
    And I press "Submit"
    And I log out
    Then I log in as "teacher"
    And I am on "Course 1" course homepage
    And I follow "lesson1"
    And I should see "Grade essays"
    And I click on ".//*[@id='region-main']/div/div[2]/ul[1]/li[4]/a" "xpath_element"
    And I should see "Test User1"
    And I should see "Test User4"
    And I set the field "Visible groups" to "Participants not in a group"
    And I should not see "Test User1"
    And I should see "Test User4"
    And I click on ".//*[@id='region-main']/div/div/table/tbody/tr[1]/td[2]" "xpath_element"
    And I set the following fields to these values:
      | Your comments | Well done. |
      | Essay score | 2 |
    And I press "Save changes"
    And I follow "Reports"
    And "40%" "text" should exist in the "Test User4" "table_row"
    And I should not see "Test User1"
    And I should see "40.00%" in the "//*[@id='region-main']/div/div/table/tbody/tr/td[1]" "xpath_element"
    And I should see "40%" in the "//*[@id='region-main']/div/div/table/tbody/tr/td[3]" "xpath_element"
    And I should see "40%" in the "//*[@id='region-main']/div/div/table/tbody/tr/td[4]" "xpath_element"
    And I set the field "Visible groups" to "All participants"
    And "20%" "text" should exist in the "Test User1" "table_row"
    And "40%" "text" should exist in the "Test User4" "table_row"
    And I should see "30.00%" in the "//*[@id='region-main']/div/div/table/tbody/tr/td[1]" "xpath_element"
    And I should see "40%" in the "//*[@id='region-main']/div/div/table/tbody/tr/td[3]" "xpath_element"
    And I should see "20%" in the "//*[@id='region-main']/div/div/table/tbody/tr/td[4]" "xpath_element"
    And I log out

