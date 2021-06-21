@qtype @qtype_ddmarker @_switch_window
Feature: Preview a drag-drop marker question
  As a teacher
  In order to check my drag-drop marker questions will work for students
  I need to preview them

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
    And the following "activities" exist:
      | activity   | name      | course | idnumber |
      | quiz       | Test quiz | C1     | quiz1    |
    And the following "question categories" exist:
      | contextlevel          | reference | name           |
      | Activity module       | quiz1     | Test questions |
    And the following "questions" exist:
      | questioncategory | qtype    | name         | template |
      | Test questions   | ddmarker | Drag markers | mkmap    |
    And I log in as "admin"
    And I am on "Course 1" course homepage
    And I follow "Test quiz"
    And I navigate to "Question bank" in current page administration

  @javascript @_bug_phantomjs
  Scenario: Preview a question using the mouse
    When I choose "Preview" action for "Drag markers" in the question bank
    And I drag "OU" to "322,213" in the drag and drop markers question
    And I drag "Railway station" to "144,84" in the drag and drop markers question
    And I drag "Railway station" to "195,180" in the drag and drop markers question
    And I drag "Railway station" to "267,302" in the drag and drop markers question
    And I press "Submit and finish"
    Then the state of "Please place the markers on the map of Milton Keynes" question is shown as "Correct"
    And I should see "Mark 1.00 out of 1.00"

  @javascript
  Scenario: Preview a question using the keyboard
    When I choose "Preview" action for "Drag markers" in the question bank
    And I type "up" "88" times on marker "Railway station" in the drag and drop markers question
    And I type "right" "26" times on marker "Railway station" in the drag and drop markers question
    And I press "Submit and finish"
    Then the state of "Please place the markers on the map of Milton Keynes" question is shown as "Partially correct"
    And I should see "Mark 0.25 out of 1.00"

  @javascript
  Scenario: Preview a question in multiple viewports
    When I choose "Preview" action for "Drag markers" in the question bank
    And I change viewport size to "large"
    And I drag "OU" to "322,213" in the drag and drop markers question
    And I drag "Railway station" to "144,84" in the drag and drop markers question
    And I drag "Railway station" to "195,180" in the drag and drop markers question
    And I press "Save"
    And I change viewport size to "640x768"
    And I press "Save"
    And I drag "Railway station" to "267,302" in the drag and drop markers question
    And I press "Save"
    And I press "Submit and finish"
    Then the state of "Please place the markers on the map of Milton Keynes" question is shown as "Correct"
    And I should see "Mark 1.00 out of 1.00"
