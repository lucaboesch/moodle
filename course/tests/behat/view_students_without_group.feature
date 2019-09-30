@core @core_course
Feature: Viewing course participants, who are not members of any group
  As a teacher
  I should be able to see course participants, who are not members of any group, their grades reports and course completion information

  @javascript
  Scenario: View course participants without a group and their results
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
    And I add a "Survey" to section "0" and I fill the form with:
      | Name | survey1 |
      | Survey type | Critical incidents |
      | Description | Test survey description |
    Then I navigate to course participants
    And I set the field "Visible groups" to "Participants not in a group"
    And I should not see "Test User1"
    And I should not see "Test User2"
    And I should not see "Test User3"
    And I should see "Test User4"
    And I navigate to "View > Grader report" in the course gradebook
    And I should not see "Test User1"
    And I should not see "Test User2"
    And I should not see "Test User3"
    And I should see "Test User4"
    And I navigate to "View > Single view" in the course gradebook
    And I select "Test User4" from the "Select user..." singleselect
    And I select "Course total" from the "Select grade item..." singleselect
    And I navigate to "View > User report" in the course gradebook
    And I select "All users (1)" from the "Select all or one user" singleselect
    And I should not see "Test User1"
    And I should not see "Test User2"
    And I should not see "Test User3"
    And I should see "Test User4"
    And I select "Test User4" from the "Select all or one user" singleselect
    And I navigate to "Export" node in "Course administration > Question bank"
    And I set the field "id_format_xml" to "1"
    And I press "Export questions to file"
    #And following "click here" should download between "1450" and "1550" bytes
    And I log out
    #And I log in as "admin"
    #And I navigate to "Advanced features" in site administration
    #And I click on "Site administration" "link"
    #And I click on "Advanced features" "link"
    #And I set the field "Enable completion tracking" to "1"
    #And I press "Save changes"
    #And I log out
    And I log in as "teacher"
    And I am on "Course 1" course homepage
    And I navigate to "Edit settings" node in "Course administration"
    And I expand all fieldsets
    And I set the field "Enable completion tracking" to "Yes"
    And I press "Save and display"
    And I follow "survey1"
    And I navigate to "Edit settings" in current page administration
    And I set the following fields to these values:
      | Completion tracking | Students can manually mark the activity as completed |
    And I press "Save and return to course"
    And I navigate to "Course completion" node in "Course administration"
    And I set the field "Completion requirements" to "Course is complete when ANY of the conditions are met"
    And I click on "Condition: Activity completion" "link"
    And I click on "Select all/none" "link"
    And I press "Save changes"
    And I log out
    And I log in as "user4"
    And I am on "Course 1" course homepage
    And I follow "survey1"
    And I set the field "At what moment in class were you most engaged as a learner?" to "Text1"
    And I set the field "At what moment in class were you most distanced as a learner?" to "Text1"
    And I set the field "What action from anyone in the forums did you find most affirming or helpful?" to "Text1"
    And I set the field "What action from anyone in the forums did you find most puzzling or confusing?" to "Text1"
    And I set the field "What event surprised you most?" to "Text1"
    And I press "Click here to continue"
    And I am on "Course 1" course homepage
    And I click on "Not completed: survey1. Select to mark as complete." "icon"
    And I log out
    And I log in as "teacher"
    And I am on "Course 1" course homepage
    And I navigate to "Reports > Activity completion" in current page administration
    And I set the field "Visible groups" to "Participants not in a group"
    And I should not see "Test User1"
    And I should not see "Test User2"
    And I should not see "Test User3"
    And I should see "Test User4"
    And I am on "Course 1" course homepage
    And I navigate to "Reports > Course completion" in current page administration
    And I set the field "Visible groups" to "Participants not in a group"
    And I should not see "Test User1"
    And I should not see "Test User2"
    And I should not see "Test User3"
    And I should see "Test User4"
    And I log out

