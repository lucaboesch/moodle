@mod @mod_forum
Feature: Viewing Forum posts for students, who are not participants of any group
  As a teacher
  I should be able to see that students, who are not participants of any group, can only view posts for all participants

  @javascript
  Scenario: View forum posts
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
    And I add a "Forum" to section "0" and I fill the form with:
      | Forum name | forum1 |
      | Description | Test forum description |
    And I follow "forum1"
    And I press "Add a new discussion topic"
    And I set the following fields to these values:
      | Subject  | topic1 |
      | Message | message for all |
      | Group   | All participants |
    And I press "Post to forum"
    And I press "Add a new discussion topic"
    And I set the following fields to these values:
      | Subject  | topic2 |
      | Message | message for group1 |
      | Group   | Group 1 |
    And I press "Post to forum"
    Then I set the field "Visible groups" to "All participants"
    And I should see "topic1"
    And I should see "topic2"
    And I set the field "Visible groups" to "Group 1"
    And I should see "topic1"
    And I should see "topic2"
    And I set the field "Visible groups" to "Participants not in a group"
    And I should see "topic1"
    And I should not see "topic2"
    And I navigate to "Edit settings" in current page administration
    And I expand all fieldsets
    And I set the field "Group mode" to "Separate groups"
    And I press "Save and display"
    And I log out
    And I log in as "user4"
    And I am on "Course 1" course homepage
    And I follow "forum1"
    And I should see "Participants not in a group"
    And I press "Add a new discussion topic"
    And I set the following fields to these values:
      | Subject  | topic3 |
      | Message | message for not a participant of any group |
    And I press "Post to forum"
    And I should see "topic1"
    And I should not see "topic2"
    And I should see "topic3"
    And I log out
    And I log in as "teacher"
    And I am on "Course 1" course homepage
    And I follow "forum1"
    And I set the field "Separate groups" to "All participants"
    And I should see "topic1"
    And I should see "topic2"
    And I should see "topic3"
    And I set the field "Separate groups" to "Group 1"
    And I should see "topic1"
    And I should see "topic2"
    And I should not see "topic3"
    And I set the field "Separate groups" to "Participants not in a group"
    And I should see "topic1"
    And I should not see "topic2"
    And I should see "topic3"
    And I log out

