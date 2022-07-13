<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

// NOTE: no MOODLE_INTERNAL test here, this file may be required by behat before including /config.php.

require_once(__DIR__ . '/../../../../../lib/behat/behat_base.php');

/**
 * Steps definitions related with the drag and drop header.
 * @package    qbank_columnsortorder
 * @category   test
 * @copyright  2022 Catalyst IT Australia Pty Ltd
 * @author     Nathan Nguyen <nathannguyen@catalyst-ca.net>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class behat_qbank_columnsortorder extends behat_base {
    /**
     * Drags and drops a header into another header.
     *
     * @Given /^I drag "(?P<element_string>(?:[^"]|\\")*)" \
     * and I drop it in header "(?P<container_element_string>(?:[^"]|\\")*)"$/
     * @param string $source source element
     * @param string $target target element
     */
    public function i_drag_and_i_drop_it_in_header(string $source, string $target) {
        $source = "//div[@class='move-handle']/span[@title='" . $this->escape($source) . "']";
        $target = "//th[@data-name='" . $this->escape($target) . "']";
        $sourcetype = 'xpath_element';
        $targettype = 'xpath_element';

        $generalcontext = behat_context_helper::get('behat_general');
        // Adds support for firefox scrolling.
        $sourcenode = $this->get_node_in_container($sourcetype, $source, 'table', 'table-responsive');
        $this->execute_js_on_node($sourcenode, '{{ELEMENT}}.scrollIntoView();');

        $generalcontext->i_drag_and_i_drop_it_in($source, $sourcetype, $target, $targettype);
    }

    /**
     * Pin a header.
     *
     * @Given /^I pin header "(?P<element_string>(?:[^"]|\\")*)"$/
     * @param string $source source element
     */
    public function i_pin_header(string $source) {
        $xpathtarget = "//div[@class='pin-handle']/span[@title='" . $this->escape($source) . "']";
        $this->execute('behat_general::i_click_on', [$xpathtarget, 'xpath_element']);
    }

    /**
     * Check whether a header is pinned.
     * @Given /^I should see pinned header "(?P<element_string>(?:[^"]|\\")*)"$/
     * @param string $source source element
     */
    public function i_should_see_pinned_header(string $source) {
        $xpath = "//th[contains(@class, 'pinned')][@data-name='" . $this->escape($source) . "']";
        $this->execute('behat_general::should_exist', array($xpath, 'xpath_element'));
    }

    /**
     * Hide a header.
     *
     * @Given /^I hide header "(?P<element_string>(?:[^"]|\\")*)"$/
     * @param string $source source element
     */
    public function i_hide_header(string $source) {
        $xpathtarget = "//*[@id='showhidecolumn']//a[@data-toggle='dropdown']";
        $this->execute('behat_general::i_click_on', [$xpathtarget, 'xpath_element']);
        $xpathtarget = "//div[@class='dropdown-item']//label[text()[contains(.,'" . $this->escape($source) . "')]]";
        $this->execute('behat_general::i_click_on', [$xpathtarget, 'xpath_element']);
    }

}
