@qtype @qtype_ddimageortext
Feature: Test importing drag and drop onto image questions
  As a teacher
  In order to reuse drag and drop onto image questions
  I need to import them

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
    And I log in as "admin"
    And I am on "Course 1" course homepage
    And I follow "Test quiz"
    And I navigate to "Question bank" in current page administration
    And I click on "jump" "select"
    And I click on "Import" "option"

  @javascript @_file_upload
  Scenario: import drag and drop onto image question
    And I set the field "id_format_xml" to "1"
    And I upload "question/type/ddimageortext/tests/fixtures/testquestion.moodle.xml" file to "Import" filemanager
    And I press "id_submitbutton"
    Then I should see "Parsing questions from import file."
    And I should see "Importing 1 questions from file"
    And I should see "Identify the features in this cross-section by dragging the labels into the boxes."
    And I press "Continue"
    And I should see "Imported Drag and drop onto image 001"
