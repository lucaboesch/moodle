@qbank @qbank_columnsortorder @javascript
Feature: An plugin column can be pinned.
  As an admin or a teacher
  I need to be able to pin a column

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
    And the following "courses" exist:
      | fullname | shortname | format |
      | Course 1 | C1        | weeks  |
    And the following "activity" exists:
      | activity | quiz           |
      | course   | C1             |
      | name     | Test quiz Q001 |
    And the following "course enrolments" exist:
      | user      | course | role           |
      | teacher1  | C1     | editingteacher |
    And the following "question category" exist:
      | contextlevel    | reference      | name                |
      | Activity module | Test quiz Q001 | Question category 1 |
    And the following "questions" exist:
      | questioncategory    | qtype | name                     | user     | questiontext                  | idnumber  |
      | Question category 1 | essay | Test question to be seen | teacher1 | Write about whatever you want | idnumber1 |

  Scenario: Admin can pin a column in site administration page
    Given I log in as "admin"
    When I navigate to "Plugins > Question bank plugins > Column sort order" in site administration
    And I pin header "Created by"
    And I reload the page
    Then I should see pinned header "Created by"
