@qbehaviour @qbehaviour_adaptivenopenalty
Feature: Quiz adaptivenopenalty override mark
  In order to manually mark a question in adaptive mode
  As a teacher
  I need to override a mark for that user.

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | One      | teacher1@example.com |
      | student1 | Student   | One      | student1@example.com |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | student1 | C1     | student        |
    And the following "question categories" exist:
      | contextlevel | reference | name           |
      | Course       | C1        | Test questions |
    And the following "activities" exist:
      | activity   | name   | intro              | course | idnumber |
      | quiz       | Quiz 1 | Quiz 1 description | C1     | quiz1    |
    And I log in as "teacher1"
    And I am on "Course 1" course homepage

  @javascript
  Scenario: Add a gapselect question to a Adaptive mode quiz, answer as student and then override
    When I follow "Quiz 1"
    And I navigate to "Edit settings" in current page administration
    And I expand all fieldsets
    And I set the field "How questions behave" to "Adaptive mode"
    And I click on "Save and display" "button"
    And I navigate to "Question bank" node in "Course administration"

    # Create a new question.
    And I add a "Select missing words" question filling the form with:
      | Question name             | Select missing words 001      |
      | Question text             | The [[1]] [[2]] on the [[3]]. |
      | General feedback          | The cat sat on the mat.       |
      | id_choices_0_answer       | cat                           |
      | id_choices_1_answer       | sat                           |
      | id_choices_2_answer       | mat                           |
      | id_choices_3_answer       | dog                           |
      | id_choices_4_answer       | table                         |
      | Hint 1                    | First hint                    |
      | Hint 2                    | Second hint                   |
    Then I should see "Select missing words 001"
    And I am on "Course 1" course homepage
    And I follow "Quiz 1"
    And I navigate to "Edit quiz" in current page administration

    # Add Essay Select missing words 001 from question bank.
    And I open the "last" add to quiz menu
    And I follow "from question bank"
    And I click on "Add to quiz" "link" in the "Select missing words 001" "table_row"
    And I set the max mark for question "Select missing words 001" to "2.0"
    And I log out
    And I log in as "student1"
    And I am on "Course 1" course homepage
    And I follow "Quiz 1"
    And I press "Attempt quiz now"

    # Answer question correctly
    And I set space "1" to "cat" in the select missing words question
    And I set space "2" to "sat" in the select missing words question
    And I set space "3" to "mat" in the select missing words question
    And I press "Finish attempt ..."
    And I press "Submit all and finish"
    And I click on "Submit all and finish" "button" in the "Confirmation" "dialogue"
    And I log out

    # Override mark
    And I log in as "teacher1"
    And I am on "Course 1" course homepage
    And I follow "Quiz 1"
    And I follow "Attempts: 1"
    And I follow "Review attempt"
    And I follow "Make comment or override mark"
    And I switch to "commentquestion" window
    And I set the field "Mark" to "1.0"
    And I press "Save" and switch to main window
    And I should not see "Marks for this submission: 2.00/2.00"
    And I log out

    # Cross-check as student
    And I log in as "student1"
    And I am on "Course 1" course homepage
    And I follow "Quiz 1"
    And I follow "Review"
    Then I should not see "Marks for this submission: 2.00/2.00"
