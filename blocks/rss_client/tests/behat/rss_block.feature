@block_rss
Feature: Add and configure RSS block
  In order to add more functionality to pages
  As a teacher
  I need to add rss feeds

  Background:
    Given the following "courses" exist:
      | fullname | shortname | format |
      | RSS Test Course | C1        | topics |

  Scenario: Add a Remote RSS feeds block
    When I log in as "admin"
    And I navigate to "Plugins > Blocks > Remote RSS feeds" in site administration
    And I follow "Add/edit feeds"
    And I click on "Add a new feed" "button"
    Then I should see "Add a new feed"
    And I set the field "Feed URL" to "http://download.moodle.org/unittest/rsstest.xml"
    And I set the field "Custom title (leave blank to use title supplied by feed):" to "My RSS feed URL"
    And I click on "Add a new feed" "button"
    Then I should see "My RSS feed URL"
    And I should see "http://download.moodle.org/unittest/rsstest.xml"

  @javascript
  Scenario: Switch Remote RSS feeds block "Title" setting
    Given I log in as "admin"
    And I navigate to "Plugins > Blocks > Remote RSS feeds" in site administration
    And I follow "Add/edit feeds"
    And I click on "Add a new feed" "button"
    And I set the field "Feed URL" to "http://download.moodle.org/unittest/rsstest.xml"
    And I set the field "Custom title (leave blank to use title supplied by feed):" to "My RSS feed URL"
    And I click on "Add a new feed" "button"
    And I am on "RSS Test Course" course homepage with editing mode on
    When I add the "Remote RSS feeds" block
    Then I should see "Click the edit icon above to configure this block to display RSS feeds"
    When I configure the "Remote news feed" block
    And I set the following fields to these values:
      | Choose the feeds which you would like to make available in this block: | My RSS feed URL |
    And I press "Save changes"
    Then I should see "My RSS feed URL"
    When I configure the "My RSS feed URL" block
    And I set the field "Title:" to "$NASTYSTRING1"
    And I press "Save changes"
    Then I should see "$NASTYSTRING1"
    And I should not see "My RSS feed URL"

  @javascript
  Scenario: Switch Remote RSS feeds block "Source Site" setting
    Given I log in as "admin"
    And I navigate to "Plugins > Blocks > Remote RSS feeds" in site administration
    And I follow "Add/edit feeds"
    And I click on "Add a new feed" "button"
    And I set the field "Feed URL" to "http://download.moodle.org/unittest/rsstest.xml"
    And I set the field "Custom title (leave blank to use title supplied by feed):" to "My RSS feed URL"
    And I click on "Add a new feed" "button"
    And I am on "RSS Test Course" course homepage with editing mode on
    When I add the "Remote RSS feeds" block
    Then I should see "Click the edit icon above to configure this block to display RSS feeds"
    When I configure the "Remote news feed" block
    And I set the following fields to these values:
      | Choose the feeds which you would like to make available in this block: | My RSS feed URL |
    And I press "Save changes"
    Then I should see "My RSS feed URL"
    And I configure the "My RSS feed URL" block
    And I select "No" from the "Should a link to the original site (channel link) be displayed? (Note that if no feed link is supplied in the news feed then no link will be shown) :" singleselect
    And I press "Save changes"
    Then I should not see "Source site..."
    When I configure the "My RSS feed URL" block
    And I select "Yes" from the "Should a link to the original site (channel link) be displayed? (Note that if no feed link is supplied in the news feed then no link will be shown) :" singleselect
    And I press "Save changes"
    Then I should see "Source site..."

  @javascript
  Scenario: Switch Remote RSS feeds block "Max Entries" setting
    Given I log in as "admin"
    And I navigate to "Plugins > Blocks > Remote RSS feeds" in site administration
    And I follow "Add/edit feeds"
    And I click on "Add a new feed" "button"
    And I set the field "Feed URL" to "http://download.moodle.org/unittest/rsstest.xml"
    And I set the field "Custom title (leave blank to use title supplied by feed):" to "My RSS feed URL"
    And I click on "Add a new feed" "button"
    And I am on "RSS Test Course" course homepage with editing mode on
    When I add the "Remote RSS feeds" block
    Then I should see "Click the edit icon above to configure this block to display RSS feeds"
    When I configure the "Remote news feed" block
    And I set the following fields to these values:
      | Choose the feeds which you would like to make available in this block: | My RSS feed URL |
    And I press "Save changes"
    Then I should see "My RSS feed URL"
    And I am on "RSS Test Course" course homepage with editing mode on
    And I configure the "My RSS feed URL" block
    And I set the field "Max number entries to show per block." to "not a number"
    And I press "Save changes"
    Then I should see "You must enter a number here."
    And I set the field "Max number entries to show per block." to "1"
    And I press "Save changes"
    Then I should see "My RSS feed URL"
    # Should see the first item in the feed:
    And I should see "Google HOP contest encourages pre-University students to work on Moodle"
    # But not the second item:
    And I should not see "Moodle Bugathon!"
    When I configure the "My RSS feed URL" block
    And I set the field "Max number entries to show per block." to "2"
    And I press "Save changes"
    Then I should see "My RSS feed URL"
    # Should see the first item in the feed:
    And I should see "Google HOP contest encourages pre-University students to work on Moodle"
    # And the second item:
    And I should see "Moodle Bugathon!"

  @javascript
  Scenario: Enable Remote RSS feeds block "Display each link's description" setting
    Given I log in as "admin"
    And I navigate to "Plugins > Blocks > Remote RSS feeds" in site administration
    And I follow "Add/edit feeds"
    And I click on "Add a new feed" "button"
    And I set the field "Feed URL" to "http://download.moodle.org/unittest/rsstest.xml"
    And I set the field "Custom title (leave blank to use title supplied by feed):" to "My RSS feed URL"
    And I click on "Add a new feed" "button"
    And I am on "RSS Test Course" course homepage with editing mode on
    When I add the "Remote RSS feeds" block
    Then I should see "Click the edit icon above to configure this block to display RSS feeds"
    When I configure the "Remote news feed" block
    And I set the following fields to these values:
      | Choose the feeds which you would like to make available in this block: | My RSS feed URL |
      | Display each link's description?                                       | Yes             |
    And I press "Save changes"
    Then I should see "My RSS feed URL"
    And I should see "You can find out all the details on the Moodle/GHOP contest site."
