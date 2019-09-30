@mod @mod_survey
Feature: Viewing Survey responses of students, who are not participants of any group
  As a teacher
  I should be able to see Survey responses for all visible groups, including students, who are not participants of any group

  @javascript
  Scenario: View survey responses
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
    And I add a "Survey" to section "0" and I fill the form with:
      | Name | survey2 |
      | Survey type | COLLES (Actual) |
      | Description | Test survey description |
    And I log out

    And I log in as "user1"
    And I am on "Course 1" course homepage
    And I follow "survey1"
    And I set the field "At what moment in class were you most engaged as a learner?" to "Text1"
    And I set the field "At what moment in class were you most distanced as a learner?" to "Text1"
    And I set the field "What action from anyone in the forums did you find most affirming or helpful?" to "Text1"
    And I set the field "What action from anyone in the forums did you find most puzzling or confusing?" to "Text1"
    And I set the field "What event surprised you most?" to "Text1"
    And I press "Click here to continue"
    And I am on "Course 1" course homepage
    And I follow "survey2"
    And I set the field with xpath "//*[@id='q1_1']" to "1"
    And I set the field with xpath "//*[@id='q2_2']" to "1"
    And I set the field with xpath "//*[@id='q3_3']" to "1"
    And I set the field with xpath "//*[@id='q4_4']" to "1"
    And I set the field with xpath "//*[@id='q5_1']" to "1"
    And I set the field with xpath "//*[@id='q6_2']" to "1"
    And I set the field with xpath "//*[@id='q7_3']" to "1"
    And I set the field with xpath "//*[@id='q8_4']" to "1"
    And I set the field with xpath "//*[@id='q9_1']" to "1"
    And I set the field with xpath "//*[@id='q10_2']" to "1"
    And I set the field with xpath "//*[@id='q11_3']" to "1"
    And I set the field with xpath "//*[@id='q12_4']" to "1"
    And I set the field with xpath "//*[@id='q13_1']" to "1"
    And I set the field with xpath "//*[@id='q14_2']" to "1"
    And I set the field with xpath "//*[@id='q15_3']" to "1"
    And I set the field with xpath "//*[@id='q16_4']" to "1"
    And I set the field with xpath "//*[@id='q17_1']" to "1"
    And I set the field with xpath "//*[@id='q18_2']" to "1"
    And I set the field with xpath "//*[@id='q19_3']" to "1"
    And I set the field with xpath "//*[@id='q20_4']" to "1"
    And I set the field with xpath "//*[@id='q21_1']" to "1"
    And I set the field with xpath "//*[@id='q22_2']" to "1"
    And I set the field with xpath "//*[@id='q23_3']" to "1"
    And I set the field with xpath "//*[@id='q24_4']" to "1"
    And I set the field with xpath "//*[@id='q43']" to "1"
    And I set the field with xpath "//*[@id='q44']" to "Comment"
    And I press "Click here to continue"
    And I am on "Course 1" course homepage
    And I log out

    And I log in as "user4"
    And I am on "Course 1" course homepage
    And I follow "survey1"
    And I set the field "At what moment in class were you most engaged as a learner?" to "Text2"
    And I set the field "At what moment in class were you most distanced as a learner?" to "Text2"
    And I set the field "What action from anyone in the forums did you find most affirming or helpful?" to "Text2"
    And I set the field "What action from anyone in the forums did you find most puzzling or confusing?" to "Text2"
    And I set the field "What event surprised you most?" to "Text"
    And I press "Click here to continue"
    And I am on "Course 1" course homepage
    And I follow "survey2"
    And I set the field with xpath "//*[@id='q1_4']" to "1"
    And I set the field with xpath "//*[@id='q2_3']" to "1"
    And I set the field with xpath "//*[@id='q3_2']" to "1"
    And I set the field with xpath "//*[@id='q4_1']" to "1"
    And I set the field with xpath "//*[@id='q5_4']" to "1"
    And I set the field with xpath "//*[@id='q6_3']" to "1"
    And I set the field with xpath "//*[@id='q7_2']" to "1"
    And I set the field with xpath "//*[@id='q8_1']" to "1"
    And I set the field with xpath "//*[@id='q9_4']" to "1"
    And I set the field with xpath "//*[@id='q10_3']" to "1"
    And I set the field with xpath "//*[@id='q11_2']" to "1"
    And I set the field with xpath "//*[@id='q12_1']" to "1"
    And I set the field with xpath "//*[@id='q13_4']" to "1"
    And I set the field with xpath "//*[@id='q14_3']" to "1"
    And I set the field with xpath "//*[@id='q15_2']" to "1"
    And I set the field with xpath "//*[@id='q16_1']" to "1"
    And I set the field with xpath "//*[@id='q17_4']" to "1"
    And I set the field with xpath "//*[@id='q18_3']" to "1"
    And I set the field with xpath "//*[@id='q19_2']" to "1"
    And I set the field with xpath "//*[@id='q20_1']" to "1"
    And I set the field with xpath "//*[@id='q21_4']" to "1"
    And I set the field with xpath "//*[@id='q22_3']" to "1"
    And I set the field with xpath "//*[@id='q23_2']" to "1"
    And I set the field with xpath "//*[@id='q24_1']" to "1"
    And I set the field with xpath "//*[@id='q43']" to "1"
    And I set the field with xpath "//*[@id='q44']" to "Comment"
    And I press "Click here to continue"
    And I am on "Course 1" course homepage
    And I log out

    Then I log in as "teacher"
    And I am on "Course 1" course homepage
    And I follow "survey1"
    And I click on "View 2 survey responses" "link"
    And I set the field "Visible groups" to "Participants not in a group"
    And I should see "Test User4"
    And I should not see "Test User1"
    And I am on "Course 1" course homepage
    And I follow "survey2"
    And I click on "View 2 survey responses" "link"
    And I click on "Participants" "link"
    And I set the field "Visible groups" to "Participants not in a group"
    And I should see "Test User4"
    And I should not see "Test User1"
    And I log out

