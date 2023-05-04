@tool @tool_uploadcourse @_file_upload
Feature: An admin can copy courses using a CSV file
  In order to copy courses using a CSV file
  As an admin
  I need to be able to upload a CSV file and navigate through the upload course process

  Background:
    Given the following "courses" exist:
      | fullname       | shortname | category | format | hiddensections |
      | Course 1       | C1        | 0        | topics | 1              |
      | Another course | CF1       | 0        | topics | 0              |
    And I log in as "admin"
    And I navigate to "Courses > Upload courses" in site administration

  @javascript
  Scenario: Copy a course by uploading a CSV file
    Given I upload "admin/tool/uploadcourse/tests/fixtures/coursecopy.csv" file to "File" filemanager
    And I set the field "Upload mode" to "Create new courses only, skip existing ones"
    And I click on "Preview" "button"
    When I click on "Upload courses" "button"
    Then I should see "Course created"
    And I should see "Course restored"
    And I should see "Courses total: 1"
    And I should see "Courses created: 1"
    And I should see "Courses updated: 0"
    And I should see "Courses deleted: 0"
    And I should see "Courses errors: 0"
    And I am on site homepage
    And I should see "Course 1"
    And I should see "Course 4"
    And I am on "Course 4" course homepage
    And I navigate to "Edit settings" in current page administration
    Then the field "Hidden sections" matches value "Hidden sections are completely invisible"
