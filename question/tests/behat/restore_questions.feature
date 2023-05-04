@core @core_question @_file_upload
Feature: The questions in a restored quiz activity can be edited
  In order to modify a question in a quiz I have imported
  As a teacher or admin
  I want to change its content

  @javascript
  Scenario: Restore a course including questions
    Given I log in as "admin"
    And I am on site homepage
    And I navigate to "Courses > Restore course" in site administration
    And I press "Manage backup files"
    And I upload "question/tests/fixtures/backup-moodle2-course-4-activity_examples-20220202-1815-nu.mbz" file to "Files" filemanager
    And I press "Save changes"
    And I restore "backup-moodle2-course-4-activity_examples-20220202-1815-nu.mbz" backup into a new course using this options:
    And I am on "Activity examples" course homepage
    And I am on the "Test quiz" "mod_quiz > Edit" page
    And I follow "Edit question Moodle activities"
    And I set the field "Question text" to "Match the activity to the description, please."
    And I press "id_submitbutton"
    Then I should see "Match the activity to the description, please."
