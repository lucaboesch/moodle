@core @core_grades @javascript
Feature: View scales names and values correctly shown regarding the selected page language
  In order to use scales for grading in multiple languages
  As a teacher / admin
  I need to be able to add scales in multiple languages
  I want user to be able to read their scale grades in the selected page language

  Scenario: Multilang filter is correctly applied to scales
    Given the following "users" exist:
      | username | firstname | lastname | email |
      | teacher1 | Teacher | 1 | teacher1@example.com |
      | student1 | Student | 1 | student1@example.com |
    And the following "courses" exist:
      | fullname | shortname | format |
      | Course 1 | C1 | topics |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
      | student1 | C1 | student |
    And the "multilang" filter is "on"
    And the "multilang" filter applies to "content and headings"
    And the following "scales" exist:
      | name                                                                                              | scale                                                                                                                                                                                                |
      | <span lang="ca" class="multilang">CA</span><span lang="en" class="multilang">EN</span> lang scale | <span lang="en" class="multilang">Eligible</span><span lang="ca" class="multilang">Apte</span>,<span lang="en" class="multilang">Non Eligible</span><span lang="ca" class="multilang">No Apte</span> |
    And the following "activities" exist:
      | activity | name            | intro                    | course   | idnumber    | assignsubmission_onlinetext_enabled | submissiondrafts |
      | assign   | Multilang test  | Testing multilang scales | C1       | assign0     | 1                                   | 0                |
    And the following config values are set as admin:
      | enableoutcomes | 1 |
    And the following "grade outcomes" exist:
      | fullname  | shortname | course | scale                                                                                             |
      | Outcome 1 | OT1       | C1     | <span lang="ca" class="multilang">CA</span><span lang="en" class="multilang">EN</span> lang scale |
    And the following "grade items" exist:
      | itemname              | course | outcome | gradetype | scale                                                                                             |
      | Test outcome item one | C1     | OT1     | Scale     | <span lang="ca" class="multilang">CA</span><span lang="en" class="multilang">EN</span> lang scale |
    And I log in as "admin"
    And I set the following administration settings values:
      | grade_report_showranges    | 1 |
    # View standard scale
    When I navigate to "Grades > Scales" in site administration
    Then I should see "EN lang scale"
    And I should see "Eligible, Non Eligible"
    # Add new competency framework
    When I am on homepage
    And I navigate to "Competencies > Competency frameworks" in site administration
    And I press "Add new competency framework"
    And I set the following fields to these values:
      | Name      | Competency 1  |
      | ID number | comp1         |
      | Scale     | EN lang scale |
    And I press "Configure scales"
    Then the following should not exist in the "table-condensed" table:
      | Scale value          |
      | EligibleApte         |
      | Non EligibleNo Apte  |
    Then I am on homepage
    And I log out
    # Submit assignment
    And I log in as "student1"
    And I am on "Course 1" course homepage
    And I follow "Multilang test"
    When I press "Add submission"
    And I set the following fields to these values:
      | Online text | Grade me in multiple languages |
    And I press "Save changes"
    Then I should see "Submitted for grading"
    And I log out
    # Configure assignment
    When I log in as "teacher1"
    And I am on "Course 1" course homepage
    When I follow "Multilang test"
    And I navigate to "Edit settings" in current page administration
    And I expand all fieldsets
    And I set the field "grade[modgrade_type]" to "Scale"
    And I set the field "grade[modgrade_scale]" to "EN lang scale"
    And I press "Save and display"
    # Grade assignment
    Then I navigate to "View all submissions" in current page administration
    And I click on "Grade" "link" in the "Student 1" "table_row"
    And I set the field "Grade" to "Eligible"
    And I press "Save changes"
    And I press "Ok"
    # View course scale
    When I am on "Course 1" course homepage
    And I navigate to "Scales" in the course gradebook
    And I press "Add a new scale"
    And I set the following fields to these values:
      | Name  | <span lang="ca" class="multilang">CA</span><span lang="en" class="multilang">EN</span> local lang scale |
      | Scale | <span lang="en" class="multilang">Pass</span><span lang="ca" class="multilang">Aprova</span>,<span lang="en" class="multilang">Fail</span><span lang="ca" class="multilang">Suspèn</span>   |
    And I press "Save changes"
    Then I should see "EN local lang scale"
    And I should see "Pass, Fail"
    # View grades in Grader report
    When I navigate to "View > Grader report" in the course gradebook
    Then the following should exist in the "user-grades" table:
      | -1-                | -4-       |
      | Student 1          | Eligible  |
    And the following should exist in the "user-grades" table:
      | -1-                | -2-                   |
      | Range              | Eligible–Non Eligible |
      | Overall average    | Eligible              |
    # Change grades in Grader report
    When I navigate to "View > Grader report" in the course gradebook
    And I turn editing mode on
    Then the following should not exist in the "user-grades" table:
      | -1-                | -4-          |
      | Student 1          | EligibleApte |
    # View Outcomes report
    And I navigate to "Setup > Gradebook setup" in the course gradebook
    And I navigate to "View > Grader report" in the course gradebook
    When I give the grade "Eligible" to the user "Student 1" for the grade item "Test outcome item one"
    And I press "Save changes"
    And I navigate to "View > Outcomes report" in the course gradebook
    Then "Eligible (1)" "text" should exist
    # View Single view
    When I navigate to "View > Single view" in the course gradebook
    And I select "Student 1" from the "Select user..." singleselect
    Then the following should not exist in the "generaltable" table:
      | -2-                | -5-          |
      | Multilang test     | EligibleApte |
    # View User report
    And I navigate to "View > User report" in the course gradebook
    When the "Select all or one user" select box should contain "All users (1)"
    Then the following should exist in the "user-grade" table:
      | Grade item     | Grade    | Range                 |
      | Multilang test | Eligible | Eligible–Non Eligible |
    # View Gradebook setup
    When I navigate to "Setup > Gradebook setup" in the course gradebook
    Then "Multilang test" row "Max grade" column of "generaltable" table should not contain "Non EligibleNo Apte"
    # Grade assignment using quick grading
    When I am on "Course 1" course homepage
    And I follow "Multilang test"
    And I navigate to "View all submissions" in current page administration
    Then the following should not exist in the "generaltable" table:
      | Email address        | Grade        | Final grade  |
      | student1@example.com | EligibleApte | EligibleApte |
    When I click on "Quick grading" "checkbox"
    Then I should not see "Non EligibleNo Apte" in the "//select[@class='quickgrade']/option[@value='2']" "xpath_element"
    And I set the field "User grade" to "Eligible"
    And I press "Save all quick grading changes"
    And I should see "The grade changes were saved"
    And I press "Continue"
    And I log out
    # Check the grade is correct
    And I log in as "student1"
    And I am on "Course 1" course homepage
    And I follow "Multilang test"
    And I should see "Grade me in multiple languages"
    Then I should not see "EligibleApte"