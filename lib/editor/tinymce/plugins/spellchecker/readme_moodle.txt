This is a modification of php spellchecker plugin by Moxiecode Systems AB,
see https://github.com/tinymce/tinymce_spellchecker_php

List of changes:
* Add support for curl proxy when accessing Google spell service.
* Workaround for error() function collisions.
* Modified config file to use Moodle $CFG (in MDL-33041). Then, in MDL-47951, amended the path to Moodle config.php.
* Moved static files to /tinymce/ subfolder.
* MDL-25736 - French spellchecker fixes.
* Fix htmlentities conversion in GoogleSpell.php
* Constructors in Moxiecode_JSONReader, Moxiecode_JSON, Moxiecode_Logger, SpellChecker are renamed to __construct()
