@mod @mod_url
Feature: View activity icons in the URL resource
  In order to have visibility of URL file types
  As a student
  I need to be able to see the correct icons

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | student1 | Vinnie    | Student1 | student1@example.com |
      | teacher1 | Darrell   | Teacher1 | teacher1@example.com |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | student1 | C1     | student        |
      | teacher1 | C1     | editingteacher |

  Scenario: View icons for archive file types
    Given the following "activity" exists:
      | activity    | url                            |
      | course      | C1                             |
      | idnumber    | archivefile                    |
      | name        | An Archive File link           |
      | intro       | URL description                |
      | externalurl | https://moodle.org/zipfile.zip |
    When I am on the "An Archive File link" "url activity" page logged in as teacher1
    Then the "src" attribute of "img.activityicon" "css_element" should contain "archive"

  Scenario: View icons for audio file types
    Given the following "activity" exists:
      | activity    | url                            |
      | course      | C1                             |
      | idnumber    | audiofile                      |
      | name        | An Audio File link             |
      | intro       | URL description                |
      | externalurl | https://moodle.org/aacfile.aac |
    When I am on the "An Audio File link" "url activity" page logged in as teacher1
    Then the "src" attribute of "img.activityicon" "css_element" should contain "audio"

  Scenario: View icons for avi file types
    Given the following "activity" exists:
      | activity    | url                            |
      | course      | C1                             |
      | idnumber    | avifile                        |
      | name        | An Avi File link               |
      | intro       | URL description                |
      | externalurl | https://moodle.org/avifile.avi |
    When I am on the "An Avi File link" "url activity" page logged in as teacher1
    Then the "src" attribute of "img.activityicon" "css_element" should contain "avi"
