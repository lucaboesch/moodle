@mod @mod_wiki
Feature: Viewing Wiki pages for students, who are not participants of any group
  As a teacher
  I should be able to see that students, who are not participants of any group, can only view Wiki pages for all participants

  @javascript
  Scenario: Create and view wiki pages
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
    And I add a "Wiki" to section "0" and I fill the form with:
      | Wiki name | wiki1 |
      | Description | Collaborative wiki description |
      | First page name | index |
      | Wiki mode | Collaborative wiki |
    And I follow "wiki1"
    And I press "Create page"
    And I set the following fields to these values:
      | HTML format | info for all groups |
    And I press "Save"
    And I set the field "Visible groups" to "Group 1"
    Then I should see "New page"
    And I press "Create page"
    And I set the following fields to these values:
      | HTML format | group 1 info |
    And I press "Save"
    And I set the field "Visible groups" to "Participants not in a group"
    Then I should see "info for all groups"
    And I log out

