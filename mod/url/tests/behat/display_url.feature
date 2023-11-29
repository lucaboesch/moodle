@mod @mod_url
Feature: Teacher can specify different display options for a url
  In order to specify different display options for a url
  As a teacher
  I need to be able to set either auto, embed, open or pop-up

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
    And the following config values are set as admin:
      | displayoptions | 0,1,2,3,4,5,6 | url |

  Scenario: URL resource module with auto display option to an external website shows in limited width
    Given the following "activity" exists:
      | activity       | url                 |
      | course         | C1                  |
      | idnumber       | Music history       |
      | name           | Music history       |
      | intro          | URL description     |
      | externalurl    | https://moodle.org/ |
      | display        | 0                   |
    When I am on the "Music history" "url activity" page logged in as student1
    Then "Music history" "link" should exist
    And the "class" attribute of "body" "css_element" should contain "limitedwidth"

  Scenario: URL resource module with force download display option to an external website shows in limited width
    Given the following "activity" exists:
      | activity       | url                 |
      | course         | C1                  |
      | idnumber       | Music history       |
      | name           | Music history       |
      | intro          | URL description     |
      | externalurl    | https://moodle.org/ |
      | display        | 4                   |
    When I am on the "Music history" "url activity" page logged in as student1
    Then "Music history" "link" should exist
    And the "class" attribute of "body" "css_element" should contain "limitedwidth"

  Scenario: URL resource module with in frame display option to an external website shows in full width
    Given the following "activity" exists:
      | activity       | url                 |
      | course         | C1                  |
      | idnumber       | Music history       |
      | name           | Music history       |
      | intro          | URL description     |
      | externalurl    | https://moodle.org/ |
      | display        | 2                   |
    When I am on the "Music history" "url activity" page logged in as student1
    Then "Music history" "link" should exist
    And the "class" attribute of "body" "css_element" should not contain "limitedwidth"

  Scenario: URL resource module with embed display option to an external website shows in full width
    Given the following "activity" exists:
      | activity       | url                 |
      | course         | C1                  |
      | idnumber       | Music history       |
      | name           | Music history       |
      | intro          | URL description     |
      | externalurl    | https://moodle.org/ |
      | display        | 1                   |
    When I am on the "Music history" "url activity" page logged in as student1
    Then "Music history" "link" should exist
    And the "class" attribute of "body" "css_element" should not contain "limitedwidth"
