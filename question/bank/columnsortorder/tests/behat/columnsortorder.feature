@qbank @qbank_columnsortorder @javascript
Feature: An plugin column can be reordered and displayed in the question bank view.
  In order to reorganise the question bank view columns
  As an admin or a teacher
  I need to be able to reorder them

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
    And the following "courses" exist:
      | fullname | shortname | format |
      | Course 1 | C1        | weeks  |
    And the following "course enrolments" exist:
      | user      | course | role           |
      | teacher1  | C1     | editingteacher |
    And the following "question category" exist:
      | contextlevel    | reference      | name                |
      | Course          | C1             | Default for C1      |
    And the following "questions" exist:
      | questioncategory    | qtype | name                     | user     | questiontext                  | idnumber  |
      | Default for C1      | essay | Test question to be seen | teacher1 | Write about whatever you want | idnumber2 |

  Scenario: Teacher can see proper view
    Given I am on the "Test quiz Q001" "quiz activity" page logged in as "teacher1"
    When I navigate to "Question bank" in current page administration
    And I apply category filter with "Question category 1" category
    And I should see "Test question to be seen"
    Then I should see "Teacher 1"

  Scenario: Reordering question bank columns
    Given I log in as "admin"
    When I navigate to "Plugins > Question bank plugins > Column sort order" in site administration
    And I drag "Created by" and I drop it in header "T"
    When I log in as "teacher1"
    And I am on "Course 1" course homepage
    And I navigate to "Question bank" in current page administration
    And I apply category filter with "Question category 1" category
    Then ".creatorname" "css_element" should appear before ".qtype" "css_element"

  Scenario: Disabling and enabling column display is proper
    Given I log in as "admin"
    When I navigate to "Plugins > Question bank plugins > Column sort order" in site administration
    And I should see "Created by"
    And I click on "Manage question bank plugins" "link"
    And I click on "Disable" "link" in the "View creator" "table_row"
    And I click on "Column sort order" "link"
    Then "Currently disabled question bank plugins:" "text" should appear before "Created by" "text"
    And I click on "Manage question bank plugins" "link"
    And I click on "Enable" "link" in the "View creator" "table_row"
    And I click on "Column sort order" "link"
    Then I should not see "Currently disabled question bank plugins:"
    And I should see "Created by"

  Scenario: Custom fields are reorderable
    Given I log in as "admin"
    When I navigate to "Plugins > Question bank plugins > Question custom fields" in site administration
    And I press "Add a new category"
    And I click on "Add a new custom field" "link"
    And I follow "Checkbox"
    And I set the following fields to these values:
      | Name       | checkboxcustomcolumn |
      | Short name | chckcust             |
    And I press "Save changes"
    Then I should see "checkboxcustomcolumn"
    And I navigate to "Plugins > Question bank plugins > Column sort order" in site administration
    And I should see "checkboxcustomcolumn"
    And I change the window size to "large"
    Then "checkboxcustomcolumn" "text" should appear after "Created by" "text"
    And I drag "checkboxcustomcolumn" and I drop it in header "Created by"
    And I reload the page
    Then "checkboxcustomcolumn" "text" should appear before "Created by" "text"
    And I click on "Manage question bank plugins" "link"
    And I click on "Disable" "link" in the "Question custom fields" "table_row"
    And I click on "Column sort order" "link"
    Then "Currently disabled question bank plugins:" "text" should appear before "chckcust" "text"
    And I click on "Manage question bank plugins" "link"
    And I click on "Enable" "link" in the "Question custom fields" "table_row"
    And I click on "Column sort order" "link"
    Then I should not see "Currently disabled question bank plugins:"
    And I should see "checkboxcustomcolumn"

  Scenario: Separation of site config and user preference
    Given I log in as "teacher1"
    And I am on "Course 1" course homepage
    And I turn editing mode on
    And I wait "3" seconds
    And I wait until the page is ready
    And I navigate to "Question bank" in current page administration
    And I set the field "Select a category" to "Default for C1"
    And "Status" "text" should appear before "Created by" "text"
    And I drag "Created by" and I drop it in header "Status"
    And I reload the page
    And "Status" "text" should appear after "Created by" "text"
    And I log in as "admin"
    And I navigate to "Plugins > Question bank plugins > Column sort order" in site administration
    And "Status" "text" should appear before "Created by" "text"

  Scenario: Admin can hide a column in site administration page
    Given I log in as "admin"
    When I navigate to "Plugins > Question bank plugins > Column sort order" in site administration
    And I hide header "Created by"
    And I reload the page
    Then I should not see "Created by"

  Scenario: Admin can pin a column in site administration page
    Given I log in as "admin"
    When I navigate to "Plugins > Question bank plugins > Column sort order" in site administration
    And I pin header "Created by"
    And I reload the page
    Then I should see pinned header "Created by"
