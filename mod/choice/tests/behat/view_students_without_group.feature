@mod @mod_choice
Feature: Viewing Choice results for students, who are not participants of any group
  As a teacher
  I should be able to see Choice results for all visible groups, including students, who are not participants of any group.

  @javascript
  Scenario: view choice results 
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
    And I log in as "teacher"
    And I am on "Course 1" course homepage
    And I turn editing mode on
    And I add a "Choice" to section "0" and I fill the form with:
      | Choice name | choice1 |
      | Description | choose an option |
      | Group mode | Visible groups |
      | Publish results | Always show results to student |
      | Privacy of results | Publish full results, showing names and their choices |
      | option[0] | opt1 |
      | option[1] | opt2 |
      | option[2] | opt3 |
    And I log out
    And I log in as "user1"
    And I am on "Course 1" course homepage
    And I choose "opt1" from "choice1" choice activity
    And I should see "Your selection: opt1"
    And I should see "Your choice has been saved"
    And I log out
    And I log in as "user4"
    And I am on "Course 1" course homepage
    And I choose "opt2" from "choice1" choice activity
    And I should see "Your selection: opt2"
    And I should see "Your choice has been saved"
    And I log out
    When I log in as "teacher"
    And I am on "Course 1" course homepage
    And I follow "choice1"
    Then "Test User1 opt1" "checkbox" should exist
    And "Test User4 opt2" "checkbox" should exist
    And I set the field "Visible groups" to "Participants not in a group"
    And "Test User1 opt1" "checkbox" should not exist
    And "Test User4 opt2" "checkbox" should exist
    And I navigate to "View 1 responses" in current page administration
    And "Test User1 opt1" "checkbox" should not exist
    And "Test User4 opt2" "checkbox" should exist
    And I set the field "Visible groups" to "All participants"
    And "Test User1 opt1" "checkbox" should exist
    And "Test User4 opt2" "checkbox" should exist
    And I log out

