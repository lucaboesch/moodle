@mod @mod_feedback
Feature: Viewing Feedback responds of students, who are not participants of any group.
  As a teacher
  I should be able to see Feedback responds for all visible groups, including students, who are not participants of any group

  Background:
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
    #And I log in as "admin"
    #And I navigate to "Manage activities" node in "Site administration > Plugins > Activity modules"
    #And I click on "Enable" "link" in the "Feedback" "table_row"
    #And I log out
    And I log in as "teacher"
    And I am on "Course 1" course homepage
    And I turn editing mode on
    And I add a "Feedback" to section "0" and I fill the form with:
      | Name                | feedback1                                         |
      | Description         | Test description                                  |
      | Record user names   | User's name will be logged and shown with answers |
    And I follow "feedback1"
    And I click on "Edit questions" "link" in the "[role=main]" "css_element"
    And I set the field "Add question" to "Short text answer"
    And I set the following fields to these values:
      | Question | q1 |
    And I press "Save question"
    And I log out

  @javascript
    Scenario: Students haven't responded feedback
    When I log in as "teacher"
    And I am on "Course 1" course homepage
    And I follow "feedback1"
    Then I navigate to "Show non-respondents" in current page administration
    And I should see "User1"
    And I should see "User2"
    And I should see "User3"
    And I should see "User4"
    And I set the field "Visible groups" to "Participants not in a group"
    And I should not see "User1"
    And I should not see "User2"
    And I should not see "User3"
    And I should see "User4"

  @javascript
  Scenario: Students have responded feedback
    When I log in as "user1"
    And I am on "Course 1" course homepage
    And I follow "feedback1"
    And I follow "Answer the questions"
    And I set the following fields to these values:
      | q1 | Yes |
    And I press "Submit your answers"
    And I log out
    And I log in as "user4"
    And I am on "Course 1" course homepage
    And I follow "feedback1"
    And I follow "Answer the questions"
    And I set the following fields to these values:
      | q1 | No |
    And I press "Submit your answers"
    And I log out
    Then I log in as "teacher"
    And I am on "Course 1" course homepage
    And I follow "feedback1"
    And I set the field "Visible groups" to "Participants not in a group"
    And I should see "Submitted answers: 1"
    And I navigate to "Analysis" in current page administration
    And I should see "Submitted answers: 1"
    And I should see "No" in the "q1" "table"
    And I follow "Show responses"
    And I should not see "User1"
    And I should not see "User2"
    And I should not see "User3"
    And I should see "User4"
    And I follow "Show non-respondents"
    And I should see "No existing participants"
    And I log out

