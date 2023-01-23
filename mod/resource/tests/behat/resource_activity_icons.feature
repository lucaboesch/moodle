@mod @mod_resource @_file_upload
Feature: View activity icons in the resource activity
  In order to have visibility of resource file types
  As a student
  I need to be able to see the correct icons

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | student1 | Student   | 1        | student1@example.com |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | student1 | C1     | student        |
    And I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on

  @javascript
  Scenario: View icon for an archive file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Myarchivefile |
      | Show size                 | 0             |
      | Show type                 | 0             |
      | Show upload/modified date | 0             |
    And I upload "mod/resource/tests/fixtures/7zfile.7z" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "archive"
    And I log out

  @javascript
  Scenario: View icon for an audio file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Myaudiofile |
      | Show size                 | 0           |
      | Show type                 | 0           |
      | Show upload/modified date | 0           |
    And I upload "mod/resource/tests/fixtures/aacfile.aac" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "audio"
    And I log out

  @javascript
  Scenario: View icon for an avi file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Myavifile |
      | Show size                 | 0         |
      | Show type                 | 0         |
      | Show upload/modified date | 0         |
    And I upload "mod/resource/tests/fixtures/avifile.avi" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "avi"
    And I log out

  @javascript
  Scenario: View icon for a base file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mybasefile |
      | Show size                 | 0          |
      | Show type                 | 0          |
      | Show upload/modified date | 0          |
    And I upload "mod/resource/tests/fixtures/accdbfile.accdb" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "base"
    And I log out

  @javascript
  Scenario: View icon for a bmp file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mybmpfile |
      | Show size                 | 0         |
      | Show type                 | 0         |
      | Show upload/modified date | 0         |
    And I upload "mod/resource/tests/fixtures/bmpfile.bmp" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "bmp"
    And I log out

  @javascript
  Scenario: View icon for a calc file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mycalcfile |
      | Show size                 | 0          |
      | Show type                 | 0          |
      | Show upload/modified date | 0          |
    And I upload "mod/resource/tests/fixtures/odsfile.ods" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "calc"
    And I log out

  @javascript
  Scenario: View icon for a chart file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mychartfile |
      | Show size                 | 0           |
      | Show type                 | 0           |
      | Show upload/modified date | 0           |
    And I upload "mod/resource/tests/fixtures/odcfile.odc" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "chart"
    And I log out

  @javascript
  Scenario: View icon for a document file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mydocumentfile |
      | Show size                 | 0              |
      | Show type                 | 0              |
      | Show upload/modified date | 0              |
    And I upload "mod/resource/tests/fixtures/docfile.doc" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "document"
    And I log out

  @javascript
  Scenario: View icon for a draw file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mydrawfile |
      | Show size                 | 0          |
      | Show type                 | 0          |
      | Show upload/modified date | 0          |
    And I upload "mod/resource/tests/fixtures/odgfile.odg" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "draw"
    And I log out

  @javascript
  Scenario: View icon for an eps file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Myepsfile |
      | Show size                 | 0         |
      | Show type                 | 0         |
      | Show upload/modified date | 0         |
    And I upload "mod/resource/tests/fixtures/epsfile.eps" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "eps"
    And I log out

  @javascript
  Scenario: View icon for an epub file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Myepubfile |
      | Show size                 | 0          |
      | Show type                 | 0          |
      | Show upload/modified date | 0          |
    And I upload "mod/resource/tests/fixtures/epubfile.epub" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "epub"
    And I log out

  @javascript
  Scenario: View icon for a flash file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Myflashfile |
      | Show size                 | 0           |
      | Show type                 | 0           |
      | Show upload/modified date | 0           |
    And I upload "mod/resource/tests/fixtures/cctfile.cct" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "flash"
    And I log out

  @javascript
  Scenario: View icon for a gif file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mygiffile |
      | Show size                 | 0         |
      | Show type                 | 0         |
      | Show upload/modified date | 0         |
    And I upload "mod/resource/tests/fixtures/giffile.gif" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "gif"
    And I log out

  @javascript
  Scenario: View icon for a h5p file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Myh5pfile |
      | Show size                 | 0         |
      | Show type                 | 0         |
      | Show upload/modified date | 0         |
    And I upload "mod/resource/tests/fixtures/h5pfile.h5p" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "h5p"
    And I log out

  @javascript
  Scenario: View icon for an image file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Myimagefile |
      | Show size                 | 0           |
      | Show type                 | 0           |
      | Show upload/modified date | 0           |
    And I upload "mod/resource/tests/fixtures/aifile.ai" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "image"
    And I log out

  @javascript
  Scenario: View icon for an impress file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Myimpressfile |
      | Show size                 | 0             |
      | Show type                 | 0             |
      | Show upload/modified date | 0             |
    And I upload "mod/resource/tests/fixtures/odpfile.odp" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "impress"
    And I log out

  @javascript
  Scenario: View icon for an isf file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Myisffile |
      | Show size                 | 0         |
      | Show type                 | 0         |
      | Show upload/modified date | 0         |
    And I upload "mod/resource/tests/fixtures/isffile.isf" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "isf"
    And I log out

  @javascript
  Scenario: View icon for a jpeg file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Myjpegfile |
      | Show size                 | 0          |
      | Show type                 | 0          |
      | Show upload/modified date | 0          |
    And I upload "mod/resource/tests/fixtures/jpegfile.jpeg" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "jpeg"
    And I log out

  @javascript
  Scenario: View icon for a markup file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mymarkupfile |
      | Show size                 | 0            |
      | Show type                 | 0            |
      | Show upload/modified date | 0            |
    And I upload "mod/resource/tests/fixtures/htcfile.htc" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "markup"
    And I log out

  @javascript
  Scenario: View icon for a math file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mymathfile |
      | Show size                 | 0          |
      | Show type                 | 0          |
      | Show upload/modified date | 0          |
    And I upload "mod/resource/tests/fixtures/mwfile.mw" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "math"
    And I log out

  @javascript
  Scenario: View icon for a moodle file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mymoodlefile |
      | Show size                 | 0            |
      | Show type                 | 0            |
      | Show upload/modified date | 0            |
    And I upload "mod/resource/tests/fixtures/mbzfile.mbz" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "moodle"
    And I log out

  @javascript
  Scenario: View icon for a mp3 file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mymp3file |
      | Show size                 | 0         |
      | Show type                 | 0         |
      | Show upload/modified date | 0         |
    And I upload "mod/resource/tests/fixtures/mp3file.mp3" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "mp3"
    And I log out

  @javascript
  Scenario: View icon for a mpeg file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mympegfile |
      | Show size                 | 0          |
      | Show type                 | 0          |
      | Show upload/modified date | 0          |
    And I upload "mod/resource/tests/fixtures/m3u8file.m3u8" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "mpeg"
    And I log out

  @javascript
  Scenario: View icon for a oth file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Myothfile |
      | Show size                 | 0         |
      | Show type                 | 0         |
      | Show upload/modified date | 0         |
    And I upload "mod/resource/tests/fixtures/othfile.oth" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "oth"
    And I log out

  @javascript
  Scenario: View icon for a pdf file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mypdffile |
      | Show size                 | 0         |
      | Show type                 | 0         |
      | Show upload/modified date | 0         |
    And I upload "mod/resource/tests/fixtures/pdffile.pdf" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "pdf"
    And I log out

  @javascript
  Scenario: View icon for a png file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mypngfile |
      | Show size                 | 0         |
      | Show type                 | 0         |
      | Show upload/modified date | 0         |
    And I upload "mod/resource/tests/fixtures/pngfile.png" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "png"
    And I log out

  @javascript
  Scenario: View icon for a powerpoint file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mypowerpointfile |
      | Show size                 | 0                |
      | Show type                 | 0                |
      | Show upload/modified date | 0                |
    And I upload "mod/resource/tests/fixtures/ppsfile.pps" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "powerpoint"
    And I log out

  @javascript
  Scenario: View icon for a publisher file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mypublisherfile |
      | Show size                 | 0               |
      | Show type                 | 0               |
      | Show upload/modified date | 0               |
    And I upload "mod/resource/tests/fixtures/pubfile.pub" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "publisher"
    And I log out

  @javascript
  Scenario: View icon for a quicktime file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Myquicktimefile |
      | Show size                 | 0               |
      | Show type                 | 0               |
      | Show upload/modified date | 0               |
    And I upload "mod/resource/tests/fixtures/3gpfile.3gp" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "quicktime"
    And I log out

  @javascript
  Scenario: View icon for a spreadsheet file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Myspreadsheetfile |
      | Show size                 | 0                 |
      | Show type                 | 0                 |
      | Show upload/modified date | 0                 |
    And I upload "mod/resource/tests/fixtures/csvfile.csv" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "spreadsheet"
    And I log out

  @javascript
  Scenario: View icon for a text file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mytextfile |
      | Show size                 | 0          |
      | Show type                 | 0          |
      | Show upload/modified date | 0          |
    And I upload "mod/resource/tests/fixtures/applescriptfile.applescript" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "text"
    And I log out

  @javascript
  Scenario: View icon for a tiff file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mytifffile |
      | Show size                 | 0          |
      | Show type                 | 0          |
      | Show upload/modified date | 0          |
    And I upload "mod/resource/tests/fixtures/tiffile.tif" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "tiff"
    And I log out

  @javascript
  Scenario: View icon for a video file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Myvideofile |
      | Show size                 | 0           |
      | Show type                 | 0           |
      | Show upload/modified date | 0           |
    And I upload "mod/resource/tests/fixtures/ogvfile.ogv" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "video"
    And I log out

  @javascript
  Scenario: View icon for a wav file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mywavfile |
      | Show size                 | 0         |
      | Show type                 | 0         |
      | Show upload/modified date | 0         |
    And I upload "mod/resource/tests/fixtures/wavfile.wav" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "wav"
    And I log out

  @javascript
  Scenario: View icon for a wmv file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mywmvfile |
      | Show size                 | 0         |
      | Show type                 | 0         |
      | Show upload/modified date | 0         |
    And I upload "mod/resource/tests/fixtures/asffile.asf" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "wmv"
    And I log out

  @javascript
  Scenario: View icon for a writer file type resource
    When I add a "File" to section "1"
    And I set the following fields to these values:
      | Name                      | Mywriterfile |
      | Show size                 | 0            |
      | Show type                 | 0            |
      | Show upload/modified date | 0            |
    And I upload "mod/resource/tests/fixtures/odtfile.odt" file to "Select files" filemanager
    And I press "Save and display"
    And I am on "Course 1" course homepage
    Then the "src" attribute of "img.activityicon" "css_element" should contain "writer"
    And I log out
