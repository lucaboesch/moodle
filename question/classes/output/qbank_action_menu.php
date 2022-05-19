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

namespace core_question\output;

use moodle_url;
use renderer_base;
use templatable;
use renderable;
use url_select;

/**
 * Rendered HTML elements for tertiary nav for Question bank.
 *
 * Provides the links for question bank tertiary navigation, below
 * are the links provided for the urlselector:
 * Questions, Categories, Import, Export and any other community plugins.
 * Also "Add category" button is added to tertiary nav for the categories.
 * The "Add category" would take the user to separate page, add category page.
 * To make it properly work with the base api call, make sure your plugin has a
 * checking for optional param 'baseurl' eg:
 * optional_param('baseurl', '/question/edit.php', PARAM_TEXT);
 * then pass it to the api to align it with the base api call from any activity or plugin.
 * question/bank/managecategories/category.php or question/bank/importquestions/import.php
 * can be used as an example while implementing it as a part of any qbank plugin have a
 * navigation node as a part of plugin feature.
 *
 * @package   core_question
 * @copyright 2021 Sujith Haridasan <sujith@moodle.com>
 * @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class qbank_action_menu implements templatable, renderable {

    /**
     * @var moodle_url
     */
    private $currenturl;

    /**
     * @var moodle_url
     */
    private $baseurl;

    /**
     * @var \context
     */
    private $context;

    /**
     * qbank_actionbar constructor.
     *
     * @param moodle_url $currenturl The current URL.
     * @param int $contextid for the navigation element.
     * @param string $baseurl base url for the api call.
     */
    public function __construct(moodle_url $currenturl, $contextid, $baseurl = null) {
        $this->currenturl = $currenturl;
        $this->context = \context::instance_by_id($contextid);
        // If the the current url already have the base url set.
        if ($currentbase = $this->currenturl->get_param('baseurl')) {
            $this->baseurl = $currentbase;
        } else if (!empty($baseurl)) {
            // If there is no base url set as a part of the current url but set from the original call.
            $this->baseurl = $baseurl;
            $this->currenturl->param('baseurl', $this->baseurl);
        } else {
            // If nothing is set, we use the default api url.
            $this->baseurl = '/question/edit.php';
            $this->currenturl->param('baseurl', $this->baseurl);
        }
    }

    /**
     * Provides the data for the template.
     *
     * @param renderer_base $output renderer_base object.
     * @return array data for the template
     */
    public function export_for_template(renderer_base $output): array {
        // The default array for the question bank menu to start with.
        $corenavigations = [
            'questions' =>
                [
                'title' => get_string('questions', 'question'),
                'url' => new moodle_url($this->baseurl, $this->currenturl->params())
                ],
            'categories' => [],
            'import' => [],
            'export' => []
        ];

        // Get all the qbank plugin and their feature objects.
        $plugins = \core_component::get_plugin_list_with_class('qbank', 'plugin_feature', 'plugin_feature.php');
        foreach ($plugins as $componentname => $plugin) {
            $pluginentrypoint = new $plugin();
            $pluginentrypointobject = $pluginentrypoint->get_navigation_node();
            // Don't need the plugins without navigation node.
            if ($pluginentrypointobject === null) {
                unset($plugins[$componentname]);
                continue;
            }
            foreach ($corenavigations as $key => $corenavigation) {
                if ($pluginentrypointobject->get_navigation_key() === $key) {
                    unset($plugins[$componentname]);
                    if (!\core\plugininfo\qbank::is_plugin_enabled($componentname)) {
                        unset($corenavigations[$key]);
                        break;
                    }
                    $corenavigations[$key] = [
                        'title' => $pluginentrypointobject->get_navigation_title(),
                        'url'   => new moodle_url($pluginentrypointobject->get_navigation_url(), $this->currenturl->params())
                    ];
                }
            }
        }

        // Mitigate the risk of regression.
        foreach ($corenavigations as $node => $corenavigation) {
            if (empty($corenavigation)) {
                unset($corenavigations[$node]);
            }
        }

        // Community/additional plugins with navigation node.
        $pluginnavigations = [];
        foreach ($plugins as $componentname => $plugin) {
            $pluginentrypoint = new $plugin();
            $pluginentrypointobject = $pluginentrypoint->get_navigation_node();
            // Don't need the plugins without navigation node.
            if ($pluginentrypointobject === null || !\core\plugininfo\qbank::is_plugin_enabled($componentname)) {
                unset($plugins[$componentname]);
                continue;
            }
            $pluginnavigations[$pluginentrypointobject->get_navigation_key()] = [
                'title' => $pluginentrypointobject->get_navigation_title(),
                'url'   => new moodle_url($pluginentrypointobject->get_navigation_url(), $this->currenturl->params()),
                'capabilities' => $pluginentrypointobject->get_navigation_capabilities()
            ];
        }

        // The actual menu to construct.
        $menu = [
            // Default qbank base page.
            $corenavigations['questions']['url']->out(false) => $corenavigations['questions']['title'],
        ];
        $contexts = new \core_question\local\bank\question_edit_contexts($this->context);
        // Add the core plugins in the menu.
        foreach ($corenavigations as $key => $corenavigation) {
            if ($contexts->have_one_edit_tab_cap($key)) {
                $menu[$corenavigation['url']->out(false)] = $corenavigation['title'];
            }
        }

        // Add the community plugins in the menu.
        foreach ($pluginnavigations as $key => $pluginnavigation) {
            if (is_array($pluginnavigation['capabilities']) && !$contexts->have_one_cap($pluginnavigation['capabilities'])) {
                continue;
            }
            $menu[$pluginnavigation['url']->out(false)] = $pluginnavigation['title'];
        }

        // URL select menu fot the question bank.
        $urlselect = new url_select($menu, $this->currenturl->out(false), null, 'questionbankaction');
        $urlselect->set_label(get_string('questionbanknavigation', 'question'), ['class' => 'accesshide']);

        return [
            'questionbankselect' => $urlselect->export_for_template($output)
        ];
    }
}
