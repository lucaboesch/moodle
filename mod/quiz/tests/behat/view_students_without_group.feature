@mod @mod_quiz
Feature: Viewing Quiz results of students, who are not participants of any group
  As a teacher
  I should be able to see Quiz results for all visible groups, including students, who are not participants of any group

  @javascript
  Scenario: View quiz results
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
    And I add a "Quiz" to section "0" and I fill the form with:
      | Name | quiz1 |
    And I add a "Multiple choice" question to the "quiz1" quiz with:
      | Question name            | q1                      |
      | Question text            | do you like our course? |
      | Default mark             | 1                       |
      | One or multiple answers? | One answer only         |
      | Choice 1                 | yes                     |
      | Choice 2                 | no                      |
      | id_fraction_0            | 100%                    |
      | id_fraction_1            | 50%                     |
    And I add a "Numerical" question to the "quiz1" quiz with:
      | Question name            | q2                      |
      | Question text            | 2+2=?                   |
      | Default mark             | 1                       |
      | Answer 1                 | 4                       |
      | id_tolerance_0           | 0                       |
      | id_fraction_0            | 100%                    |
    And I log out
    And I log in as "user1"
    And I am on "Course 1" course homepage
    And I follow "quiz1"
    And I press "Attempt quiz now"
    And I should see "do you like our course?"
    And I set the field "no" to "1"
    And I should see "2+2=?"
    And I set the field "Answer:" to "4"
    And I press "Finish attempt ..."
    And I should see "Answer saved"
    And I press "Submit all and finish"
    And I click on "Submit all and finish" "button" in the "Confirmation" "dialogue"
    And I log out
    And I log in as "user4"
    And I am on "Course 1" course homepage
    And I follow "quiz1"
    And I press "Attempt quiz now"
    And I should see "do you like our course?"
    And I set the field "yes" to "1"
    And I should see "2+2=?"
    And I set the field "Answer:" to "4"
    And I press "Finish attempt ..."
    And I should see "Answer saved"
    And I press "Submit all and finish"
    And I click on "Submit all and finish" "button" in the "Confirmation" "dialogue"
    And I log out
    Then I log in as "teacher"
    And I am on "Course 1" course homepage
    And I follow "quiz1"
    And I follow "Attempts: 2"
    And I set the field "Visible groups" to "Participants not in a group"
    And I should see "Attempts: 2 (1 from this group)"
    And "input[value='Full regrade for participants not in a group']" "css_element" should exist
    And "input[value='Dry run a full regrade for participants not in a group']" "css_element" should exist
    And I should see "Test User4"
    And I should not see "Test User2"
    And I should not see "Test User3"
    And I should not see "Test User1"
    And I should see "Number of students who are participants not in a group achieving grade ranges"
    And I click on "Show chart data" "link"
    And "1" "text" should exist in the "9.50 - 10.00" "table_row"
    And I follow "quiz1"
    And I navigate to "Results > Responses" in current page administration
    And I should see "Attempts: 2 (1 from this group)"
    And I should see "Test User4"
    And I should not see "Test User2"
    And I should not see "Test User3"
    And I should not see "Test User1"
    And I follow "quiz1"
    And I navigate to "Results > Statistics" in current page administration
    And "1" "text" should exist in the "Number of complete graded first attempts" "table_row"
    And "1" "text" should exist in the "Total number of complete graded attempts" "table_row"
    And "100.00%" "text" should exist in the "Average grade of first attempts" "table_row"
    And "100.00%" "text" should exist in the "Average grade of all attempts" "table_row"
    And "100.00%" "text" should exist in the "Average grade of last attempts" "table_row"
    And "100.00%" "text" should exist in the "Average grade of highest graded attempts" "table_row"
    And "100.00%" "text" should exist in the "Median grade (for highest graded attempt)" "table_row"
    And I follow "quiz1"
    And I navigate to "Results > Manual grading" in current page administration
    And I click on "Also show questions that have been graded automatically" "link"
    And I should see "1" in the "//*[@id='questionstograde']/tbody/tr[1]/td[7]" "xpath_element"
    And I should see "1" in the "//*[@id='questionstograde']/tbody/tr[2]/td[7]" "xpath_element"
    And I log out

