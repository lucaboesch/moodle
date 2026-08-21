@mod @mod_quiz
Feature: Attempt a quiz in secure layout
  As a student
  In order to demonstrate what I know
  I need to be able to attempt quizzes in secure layout

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email               |
      | student  | Student   | One      | student@example.com |
      | teacher  | Teacher   | One      | teacher@example.com |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
    And the following "course enrolments" exist:
      | user    | course | role           |
      | student | C1     | student        |
      | teacher | C1     | editingteacher |
    And the following "activities" exist:
      | activity | name   | intro              | course | idnumber | grade | navmethod | browsersecurity | showuserpicture | timeopen      | timeclose    |
      | quiz     | Quiz 1 | Quiz 1 description | C1     | quiz1    | 100   | free      | securewindow    | 2               | ##yesterday## | ##tomorrow## |
    And the following "question categories" exist:
      | contextlevel    | reference | name           |
      | Activity module | quiz1     | Test questions |
    And the following "questions" exist:
      | questioncategory | qtype     | name | questiontext    |
      | Test questions   | truefalse | TF1  | First question  |
      | Test questions   | truefalse | TF2  | Second question |
    And quiz "Quiz 1" contains the following questions:
      | question | page | maxmark |
      | TF1      | 1    |         |

  @javascript
  Scenario: Large user image in the quiz navigation in secure layout
    Given I am on the "Quiz 1" "mod_quiz > View" page logged in as "student"
    And I press "Attempt quiz"
    And I switch to a second window
    Then "Student One" "link" should not exist in the "Quiz navigation" "block"

  @javascript
  Scenario: A quiz page on the secure layout shows both the course name and the quiz name in attempt, summary, and review
    Given I am on the "Quiz 1" "mod_quiz > View" page logged in as "student"
    And I should see "Quiz 1"
    And I should see "Quiz 1 description"
    When I press "Attempt quiz"
    And I switch to a second window
    Then I should see "Course 1"
    And I should see "Quiz 1"
    And the "class" attribute of "body" "css_element" should contain "limitedwidth"
    But I should not see "Quiz 1 description"
    And I should not see "Opened:"
    And I should not see "Closes:"
    And I click on "True" "radio"
    And I follow "Finish attempt ..."
    And I should see "Course 1"
    And I should see "Quiz 1"
    And the "class" attribute of "body" "css_element" should contain "limitedwidth"
    But I should not see "Quiz 1 description"
    And I should not see "Opened:"
    And I should not see "Closes:"
    And I click on "Submit all and finish" "button"
    And I click on "Submit all and finish" "button" in the "Submit all your answers and finish?" "dialogue"
    And I should see "Course 1"
    And I should see "Quiz 1"
    And the "class" attribute of "body" "css_element" should contain "limitedwidth"
    But I should not see "Quiz 1 description"
    And I should not see "Opened:"
    And I should not see "Closes:"

  @javascript
  Scenario: A quiz review page on the secure layout shows both the course name and the quiz name
    Given user "student" has attempted "Quiz 1" with responses:
      | slot | response |
      |   1  | True     |
    When I am on the "Quiz 1" "mod_quiz > View" page logged in as "student"
    And I click on "Review" "button"
    And I switch to a second window
    Then I should see "Course 1"
    And I should see "Quiz 1"
    Then the "class" attribute of "body" "css_element" should contain "limitedwidth"
    But I should not see "Quiz 1 description"
    And I should not see "Opened:"
    And I should not see "Closes:"
    And I should not see "Back"

  @javascript
  Scenario: A quiz page on the secure layout with linear navigation enabled should not display previous and next
    Given I log in as "teacher"
    And I am on "Course 1" course homepage with editing mode on
    And I move "Quiz 1" activity to section "2"
    And I log out
    When I am on the "Quiz 1" "mod_quiz > View" page logged in as "student"
    Then I should see "Quiz 1"
    And I should not see "Previous"
    And I should not see "Next"
