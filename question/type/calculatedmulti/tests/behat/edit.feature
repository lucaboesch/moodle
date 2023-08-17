@qtype @qtype_calculatedmulti
Feature: Test editing a Calculated multichoice question
  As a teacher
  In order to be able to update my Calculated multichoice questions
  I need to edit them

  Background:
    Given the following "users" exist:
      | username |
      | teacher  |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
    And the following "course enrolments" exist:
      | user    | course | role           |
      | teacher | C1     | editingteacher |
    And the following "question categories" exist:
      | contextlevel | reference | name           |
      | Course       | C1        | Test questions |

  Scenario: Add, edit and preview a Calculated multichoice question
    When I am on the "Course 1" "core_question > course question bank" page logged in as teacher
    And I press "Create a new question ..."
    And I set the field "Calculated multichoice" to "1"
    And I click on "Add" "button"
    And I set the following fields to these values:
      | Question name         | calculatedmulti-001                |
      | Question text         | Multiply those two: s^{A} and s{B} |
      | Allow HTML in answers | 1                                  |
      | Choice 1              | s<sup>{={A}*{B}}</sup>             |
      | Grade                 | 100%                               |
      | Choice 2              | s<sup>{={A}+{B}}</sup>             |
      | Choice 3              | s<sup>{={A}-{B}}</sup>             |
    And I press "id_submitbutton"
    And I should see "Choose wildcards dataset properties"
    And I press "id_submitbutton"
    And I should see "Edit the wildcards datasets"
    And I press "id_addbutton"
    And I set the following fields to these values:
      | id_number_2 | 6 |
      | id_number_1 | 4 |
    And I press "id_savechanges"
    # Checking that the wildcard values are there
    And I am on the "calculatedmulti-001" "core_question > edit" page logged in as teacher
    And I set the following fields to these values:
      | Question name | Edited question name |
    And I press "id_submitbutton"
    And I should see "Choose wildcards dataset properties"
    And I press "id_submitbutton"
    And I press "id_savechanges"
    And I should see "Edited question name"
    # Preview it.
    And I choose "Preview" action for "Edited question name" in the question bank
    Then I should not see "<sup>"
