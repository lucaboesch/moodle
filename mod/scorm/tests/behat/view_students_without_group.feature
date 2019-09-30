@mod @mod_scorm @_file_upload @_switch_iframe
Feature: Viewing Scorm reports for students, who are not participants of any group
  As a teacher
  I should be able to see Scorm reports for all visible groups, including students, who are not participants of any group

  @javascript
  Scenario: View scorm reports
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
    And I add a "SCORM package" to section "0"
    And I set the following fields to these values:
      | Name | scorm1 |
      | Description | Description |
    And I upload "mod/scorm/tests/packages/RuntimeMinimumCalls_SCORM12.zip" file to "Package file" filemanager
    And I click on "Save and display" "button"
    And I should see "scorm1"
    And I log out

    And I log in as "user1"
    And I am on "Course 1" course homepage
    And I follow "scorm1"
    And I should see "Normal"
    And I press "Enter"
    And I switch to "scorm_object" iframe
    And I should see "Play of the game"
    And I switch to the main frame
    And I click on "Par?" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Par"
    And I switch to the main frame
    And I click on "Keeping Score" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Scoring"
    And I switch to the main frame
    And I click on "Other Scoring Systems" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Other Scoring Systems"
    And I switch to the main frame
    And I click on "The Rules of Golf" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "The Rules of Golf"
    And I switch to the main frame
    And I click on "Playing Golf Quiz" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Knowledge Check"
    And I switch to the main frame
    And I click on "Taking Care of the Course" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Etiquette - Care For the Course"
    And I switch to the main frame
    And I click on "Avoiding Distraction" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Etiquette - Avoiding Distraction"
    And I switch to the main frame
    And I click on "Playing Politely" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Etiquette - Playing the Game"
    And I switch to the main frame
    And I click on "Etiquette Quiz" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Knowledge Check"
    And I switch to the main frame
    And I click on "Handicapping Overview" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Handicapping"
    And I switch to the main frame
    And I click on "Calculating a Handicap" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Calculating a Handicap"
    And I switch to the main frame
    And I click on "Calculating a Handicapped Score" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Calculating a Score"
    And I switch to the main frame
    And I click on "Handicapping Example" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Calculating a Score"
    And I switch to the main frame
    And I click on "Handicapping Quiz" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Knowledge Check"
    And I switch to the main frame
    And I click on "How to Have Fun Playing Golf" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "How to Have Fun Golfing"
    And I switch to the main frame
    And I click on "How to Make Friends Playing Golf" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "How to Make Friends on the Golf Course"
    And I switch to the main frame
    And I click on "Having Fun Quiz" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Knowledge Check"
    And I switch to the main frame
    And I follow "Exit activity"
    And I wait until the page is ready
    And I should see "scorm1"
    And I am on homepage
    And I log out

    And I log in as "user4"
    And I am on "Course 1" course homepage
    And I follow "scorm1"
    And I should see "Normal"
    And I press "Enter"
    And I switch to "scorm_object" iframe
    And I should see "Play of the game"
    And I switch to the main frame
    And I click on "Par?" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Par"
    And I switch to the main frame
    And I click on "Keeping Score" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Scoring"
    And I switch to the main frame
    And I click on "Other Scoring Systems" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Other Scoring Systems"
    And I switch to the main frame
    And I click on "The Rules of Golf" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "The Rules of Golf"
    And I switch to the main frame
    And I click on "Playing Golf Quiz" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Knowledge Check"
    And I switch to the main frame
    And I click on "Taking Care of the Course" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Etiquette - Care For the Course"
    And I switch to the main frame
    And I click on "Avoiding Distraction" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Etiquette - Avoiding Distraction"
    And I switch to the main frame
    And I click on "Playing Politely" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Etiquette - Playing the Game"
    And I switch to the main frame
    And I click on "Etiquette Quiz" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Knowledge Check"
    And I switch to the main frame
    And I click on "Handicapping Overview" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Handicapping"
    And I switch to the main frame
    And I click on "Calculating a Handicap" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Calculating a Handicap"
    And I switch to the main frame
    And I click on "Calculating a Handicapped Score" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Calculating a Score"
    And I switch to the main frame
    And I click on "Handicapping Example" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Calculating a Score"
    And I switch to the main frame
    And I click on "Handicapping Quiz" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Knowledge Check"
    And I switch to the main frame
    And I click on "How to Have Fun Playing Golf" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "How to Have Fun Golfing"
    And I switch to the main frame
    And I click on "How to Make Friends Playing Golf" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "How to Make Friends on the Golf Course"
    And I switch to the main frame
    And I click on "Having Fun Quiz" "list_item"
    And I switch to "scorm_object" iframe
    And I should see "Knowledge Check"
    And I switch to the main frame
    And I follow "Exit activity"
    And I wait until the page is ready
    And I should see "scorm1"
    And I am on homepage
    And I log out

    Then I log in as "teacher"
    And I am on "Course 1" course homepage
    And I follow "scorm1"
    And I follow "Reports"
    And I set the field "Visible groups" to "Participants not in a group"
    And I should see "Test User4"
    And I should not see "Test User3"
    And I should not see "Test User2"
    And I should not see "Test User1"
    And I follow "Graph report"
    And I click on "Show chart data" "link"
    And "1" "text" should exist in the "0 - 10" "table_row"
    And I follow "Interactions report"
    And I should see "Test User4"
    And I should not see "Test User3"
    And I should not see "Test User2"
    And I should not see "Test User1"
    And I follow "Objectives report"
    And I should see "Test User4"
    And I should not see "Test User3"
    And I should not see "Test User2"
    And I should not see "Test User1"
    And I log out

