@mod @mod_assign
Feature: Viewing grades and submissions in Assignment for students, who are not participants of any group
  As a teacher
  I should be able to see 'grading summary' and 'all submission' in Assignment activity for all visible groups, including students, who are not participants of any group.

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

  @javascript
  Scenario: Students submit separately
    Given I log in as "teacher"
    And I am on "Course 1" course homepage
    And I turn editing mode on
    And I add a "Assignment" to section "0" and I fill the form with:
      | Assignment name | assign1 |
      | Description | Test assignment description |
      | assignsubmission_onlinetext_enabled | 1 |
      | Group mode | Visible groups |
    And I log out
    And I log in as "user1"
    And I am on "Course 1" course homepage
    And I follow "assign1"
    And I press "Add submission"
    And I set the following fields to these values:
      | Online text | user1 submission |
    And I press "Save changes"
    And I log out
    And I log in as "user4"
    And I am on "Course 1" course homepage
    And I follow "assign1"
    And I press "Add submission"
    And I set the following fields to these values:
      | Online text | user4 submission |
    And I press "Save changes"
    And I log out
    When I log in as "teacher"
    And I am on "Course 1" course homepage
    And I follow "assign1"
    Then I set the field "Visible groups" to "All participants"
    And I should see "4" in the "Participants" "table_row"
    And I should see "2" in the "Submitted" "table_row"
    And I should see "2" in the "Needs grading" "table_row"
    And I set the field "Visible groups" to "Group 1"
    And I should see "2" in the "Participants" "table_row"
    And I should see "1" in the "Submitted" "table_row"
    And I should see "1" in the "Needs grading" "table_row"
    And I set the field "Visible groups" to "Participants not in a group"
    And I should see "1" in the "Participants" "table_row"
    And I should see "1" in the "Submitted" "table_row"
    And I should see "1" in the "Needs grading" "table_row"
    And I navigate to "View all submissions" in current page administration
    And I set the field "Visible groups" to "All participants"
    And "//tr[contains(., 'user1')]" "xpath_element" should exist
    And "//tr[contains(., 'user2')]" "xpath_element" should exist
    And "//tr[contains(., 'user3')]" "xpath_element" should exist
    And "//tr[contains(., 'user4')]" "xpath_element" should exist
    And I set the field "Visible groups" to "Participants not in a group"
    And "//tr[contains(., 'user4')]" "xpath_element" should exist
    And I should not see "user1"
    And I should not see "user2"
    And I should not see "user3"
    And I click on "Grade" "link" in the "user4" "table_row"
    And I set the field "Grade" to "100"
    And I press "Save changes"
    And I press "Ok"
    And I follow "assign1"
    And I set the field "Visible groups" to "All participants"
    And I should see "4" in the "Participants" "table_row"
    And I should see "2" in the "Submitted" "table_row"
    And I should see "1" in the "Needs grading" "table_row"
    And I set the field "Visible groups" to "Participants not in a group"
    And I should see "1" in the "Participants" "table_row"
    And I should see "1" in the "Submitted" "table_row"
    And I should see "0" in the "Needs grading" "table_row"
    And I log out

  @javascript
  Scenario: Students submit in groups
    Given I log in as "teacher"
    And I am on "Course 1" course homepage
    And I turn editing mode on
    And I add a "Assignment" to section "0" and I fill the form with:
      | Assignment name | assign2 |
      | Description | Test assignment description |
      | assignsubmission_onlinetext_enabled | 1 |
      | Group mode | Visible groups |
      | Students submit in groups | Yes |
      | Require group to make submission | No |
    And I log out
    And I log in as "user1"
    And I am on "Course 1" course homepage
    And I follow "assign2"
    And I press "Add submission"
    And I set the following fields to these values:
      | Online text | user1 submission |
    And I press "Save changes"
    And I log out
    And I log in as "user4"
    And I am on "Course 1" course homepage
    And I follow "assign2"
    And I press "Add submission"
    And I set the following fields to these values:
      | Online text | user4 submission |
    And I press "Save changes"
    And I log out
    When I log in as "teacher"
    And I am on "Course 1" course homepage
    And I follow "assign2"
    Then I set the field "Visible groups" to "All participants"
    And I should see "3" in the "Groups" "table_row"
    And I should see "2" in the "Submitted" "table_row"
    And I set the field "Visible groups" to "Group 1"
    And I should see "1" in the "Groups" "table_row"
    And I should see "1" in the "Submitted" "table_row"
    And I set the field "Visible groups" to "Participants not in a group"
    And I should see "1" in the "Groups" "table_row"
    And I should see "2" in the "Submitted" "table_row"
    And I navigate to "View all submissions" in current page administration
    And I set the field "Visible groups" to "All participants"
    And "//tr[contains(., 'user1')]" "xpath_element" should exist
    And "//tr[contains(., 'user2')]" "xpath_element" should exist
    And "//tr[contains(., 'user3')]" "xpath_element" should exist
    And "//tr[contains(., 'user4')]" "xpath_element" should exist
    And I set the field "Visible groups" to "Participants not in a group"
    And "//tr[contains(., 'user4')]" "xpath_element" should exist
    And I should not see "user1"
    And I should not see "user2"
    And I should not see "user3"
    And I log out

