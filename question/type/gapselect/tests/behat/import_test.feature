@qtype @qtype_gapselect @javascript
Feature: Import and export select missing words questions
  As a teacher
  In order to reuse my select missing words questions
  I need to be able to import and export them

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

  @javascript @_file_upload
  Scenario: Import and export select missing words questions
    And I am on "Course 1" course homepage
    And I follow "Test quiz"
    And I navigate to "Question bank" in current page administration
    And I click on "jump" "select"
    And I click on "Import" "option"
    # Import sample file.
    When I set the field "id_format_xml" to "1"
    And I upload "question/type/gapselect/tests/fixtures/testquestion.moodle.xml" file to "Import" filemanager
    And I press "id_submitbutton"
    Then I should see "Parsing questions from import file."
    And I should see "Importing 1 questions from file"
    And I should see "1. The [[1]] [[2]] on the [[3]]."
    And I press "Continue"
    And I should see "Imported Select missing words 001"
