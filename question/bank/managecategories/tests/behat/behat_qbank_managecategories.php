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
require_once(__DIR__ . '/../../../../tests/behat/behat_question_base.php');

/**
 * Category filter helper
 *
 * @package    qbank_managecategories
 * @copyright  2022 Catalyst IT Australia Pty Ltd
 * @author     Nathan Nguyen <nathannguyen@catalyst-au.net>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class behat_qbank_managecategories extends behat_question_base {

    /**
     * Apply filter
     *
     * @When I apply category filter with :arg1 category
     * @param string $categoryname
     */
    public function i_apply_category_filter_with_category($categoryname) {
        // Type field.
        $this->execute('behat_forms::i_set_the_field_in_container_to', [
            "type",
            "Filter 1",
            "fieldset",
            "Category"
        ]);

        // Category name field.
        $this->execute('behat_forms::i_set_the_field_in_container_to', [
            get_string('placeholdertypeorselect'),
            "Filter 1",
            "fieldset",
            $categoryname
        ]);

        $this->execute("behat_general::i_click_on", array(get_string('applyfilters'), 'button'));
    }

    /**
     * Drags and drops the specified element in the question category list.
     *
     * @Given /^I drag "(?P<element_string>(?:[^"]|\\")*)" \
     * and I drop it in "(?P<container_element_string>(?:[^"]|\\")*)" in the question category list$/
     * @param string $source source element
     * @param string $target target element
     */
    public function i_drag_and_i_drop_it_in_question_category_list(string $source, string $target) {
        // Finding li element of the drag item.
        // To differentiate between drag event on li, and other mouse click events on other elements in the item.
        $source = "//li[contains(@class, 'list_item') and contains(., '" . $this->escape($source) . "')]";
        $target = "//li[contains(@class, 'list_item') and contains(., '" . $this->escape($target) . "')]";
        $sourcetype = 'xpath_element';
        $targettype = 'xpath_element';

        $generalcontext = behat_context_helper::get('behat_general');
        // Adds support for firefox scrolling.
        $sourcenode = $this->get_node_in_container($sourcetype, $source, 'region', 'categoriesrendered');
        $this->execute_js_on_node($sourcenode, '{{ELEMENT}}.scrollIntoView();');

        $generalcontext->i_drag_and_i_drop_it_in($source, $sourcetype, $target, $targettype);
    }

    /**
     * Select item from autocomplete list.
     *
     * @Given /^I click on "(?P<element_string>(?:[^"]|\\")*)" "(?P<selector_string>(?:[^"]|\\")*)" \
     * in the "(?P<modal_name>(?:[^"]|\\")*)" modal$/
     *
     * @param string $element the element
     * @param string $selectortype seletor type
     * @param string $modal name of the modal
     */
    public function i_click_on_in_the_modal(string $element, string $selectortype, string $modal) {
        $this->execute('behat_general::i_click_on_in_the',
            [$element, $selectortype, $modal, "dialogue"]
        );
    }
}
