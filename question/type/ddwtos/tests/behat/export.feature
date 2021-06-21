@qtype @qtype_ddwtos
Feature: Test exporting drag and drop into text questions
  As a teacher
  In order to be able to reuse my drag and drop into text questions
  I need to export them

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
      | questioncategory | qtype  | name         | template |
      | Test questions   | ddwtos | Drag to text | fox      |
    And I log in as "admin"
    And I am on "Course 1" course homepage
    And I follow "Test quiz"
    And I navigate to "Question bank" in current page administration
    And I click on "jump" "select"
    And I click on "Export" "option"

  @javascript
  Scenario: Export a drag and drop into text question
    And I set the field "id_format_xml" to "1"
    And I press "Export questions to file"
    And following "click here" should download between "1550" and "1700" bytes
    # If the download step is the last in the scenario then we can sometimes run
    # into the situation where the download page causes a http redirect but behat
    # has already conducted its reset (generating an error). By putting a logout
    # step we avoid behat doing the reset until we are off that page.
    And I log out
