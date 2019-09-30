@mod @mod_workshop
Feature: Viewing Workshop progress of students, who are not participants of any group
  As a teacher
  I should be able to see Workshop progress for all visible groups, including students, who are not participants of any group

  @javascript
  Scenario: View workshop progress
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
    And I add a "Workshop" to section "0" and I fill the form with:
      | Workshop name | workshop1 |
      | Description | Description |
    And I follow "workshop1"
    Then I change phase in workshop "workshop1" to "Submission phase"
    And I set the field "Visible groups" to "Participants not in a group"
    And I should not see "Test User1"
    And I should not see "Test User2"
    And I should not see "Test User3"
    And I should see "Test User4"
    And I click on "//*[@id='region-main']/div/div[2]/div[1]/dl[2]/dd/ul/li[2]/div[1]/a" "xpath_element"
    And I should not see "Test User1"
    And I should not see "Test User2"
    And I should not see "Test User3"
    And I should see "Test User4"
    And I am on "Course 1" course homepage
    And I follow "workshop1"
    And I change phase in workshop "workshop1" to "Assessment phase"
    And I should not see "Test User1"
    And I should not see "Test User2"
    And I should not see "Test User3"
    And I should see "Test User4"
    And I change phase in workshop "workshop1" to "Grading evaluation phase"
    And I should not see "Test User1"
    And I should not see "Test User2"
    And I should not see "Test User3"
    And I should see "Test User4"
    And I change phase in workshop "workshop1" to "Closed"
    And I should not see "Test User1"
    And I should not see "Test User2"
    And I should not see "Test User3"
    And I should see "Test User4"
    And I log out

