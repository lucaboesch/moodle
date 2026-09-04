@javascript @theme_boost
Feature: Course reuse navigation
  As a teacher
  I can navigate to course reuse pages

  Background:
    Given the following "courses" exist:
      | fullname | shortname | newsitems |
      | Course 1 | C1        | 5 |
    And the following "users" exist:
      | username | firstname | lastname | email |
      | teacher1 | Teacher | 1 | teacher1@example.com |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |

  Scenario: A Teacher can navigate to the course Import page.
    Given I log in as "teacher1"
    When I am on "Course 1" course homepage
    And I navigate to "Course reuse" in current page administration
    Then I should not see "Find a course to import data from:"
    And I should see "Import"
    And I should see "Backup"
    And I should see "Restore"
    And I should not see "Copy course"

  Scenario Outline: A Teacher can navigate to other Course reuse pages.
    Given I log in as "teacher1"
    When I am on "Course 1" course homepage
    And I navigate to "Course reuse" in current page administration
    And I follow "<adminpage>"
    Then I should see "<content>"

    Examples:
      | adminpage     | content                                                                                    |
      |   Backup      | Backup settings                                                                            |
      |   Restore     | Upload a backup file                                                                       |
      |   Import      | Find a course to import data from:                                                         |
      |   Reset       | This feature allows you to clear all user data and reset the course to its original state  |

  Scenario: An Administrator can view the course copy page.
    Given I log in as "admin"
    When I am on "Course 1" course homepage
    And I navigate to "Course reuse" in current page administration
    And I follow "Copy course"
    Then I should see "Create a copy of this course in any course category"

  Scenario Outline: There is the correct default for "Include enrolment methods" in the course copy page form
    Given I log in as "admin"
    And the following config values are set as admin:
      | config                     | value     | plugin  |
      | restore_general_enrolments | <setting> | restore |
    When I am on "Course 1" course homepage
    And I navigate to "Course reuse" in current page administration
    And I follow "Copy course"
    Then the field "Include enrolment methods" matches value "<formvalue>"

    Examples:
      | setting | formvalue |
      | 0       | No        |
      | 1       | Yes       |
      | 2       | Yes       |
