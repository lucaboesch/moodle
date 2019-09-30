@mod @mod_data
Feature: Viewing entries of Data activity for students, who are not participants of any group
  As a teacher
  I should be able to see Database entries for all visible groups, including students, who are not participants of any group

  @javascript
  Scenario: View entries for different groups
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
    And the following "activities" exist:
      | activity | name      | intro | course | idnumber | groupmode |
      | data     | database1 | n     | C1     | data1    | 2         |
    When I log in as "teacher"
    And I am on "Course 1" course homepage
    And I add a "Text input" field to "database1" database and I fill the form with:
      | Field name | f1 |
      | Field description | Test field description |
    And I follow "View list"
    And I set the field "Visible groups" to "All participants"
    And I add an entry to "database1" database with:
      | f1 | value1 |
    And I press "Save and add another"
    And I set the field "Visible groups" to "Group 1"
    And I add an entry to "database1" database with:
      | f1 | value2 |
    And I press "Save and add another"
    And I set the field "Visible groups" to "Participants not in a group"
    And I add an entry to "database1" database with:
      | f1 | value3 |
    And I press "Save and view"
    And I follow "Templates"
    And I press "Save template"
    Then I follow "View list"
    And I set the field "Visible groups" to "Group 1"
    And I should see "value1"
    And I should see "value2"
    And I should see "value3"
    And I set the field "Visible groups" to "All participants"
    And I should see "value1"
    And I should see "value2"
    And I should see "value3"
    And I set the field "Visible groups" to "Participants not in a group"
    And I should see "value1"
    And I should not see "value2"
    And I should see "value3"
    And I log out
    And I log in as "user4"
    And I am on "Course 1" course homepage
    And I follow "database1"
    And I set the field "Visible groups" to "Participants not in a group"
    And I add an entry to "database1" database with:
      | f1 | value4 |
    And I press "Save and view"
    And I log out
    And I log in as "teacher"
    And I am on "Course 1" course homepage
    And I follow "database1"
    And I follow "View list"
    And I set the field "Visible groups" to "Group 1"
    And I should see "value1"
    And I should see "value2"
    And I should see "value3"
    And I should see "value4"
    And I set the field "Visible groups" to "All participants"
    And I should see "value1"
    And I should see "value2"
    And I should see "value3"
    And I should see "value4"
    And I set the field "Visible groups" to "Participants not in a group"
    And I should see "value1"
    And I should not see "value2"
    And I should see "value3"
    And I should see "value4"
    And I log out

