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

/**
 * Block section_links restore steplib.
 *
 * @package   block_section_links
 * @copyright 2025 Luca Bösch <luca.boesch@bfh.ch>
 * @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

/**
 * Specialised restore task for the section_links block
 */
class restore_section_links_block_task extends restore_block_task {
    /**
     * Does nothing.
     *
     * @return void
     */
    protected function define_my_settings() {
    }

    /**
     * Does nothing.
     *
     * @return void
     */
    protected function define_my_steps() {
    }

    /**
     * This plugin has no fileareas yet.
     *
     * @return array
     */
    public function get_fileareas() {
        return [];
    }

    /**
     * This function returns an empty array as the restore functions cannot handle
     * arrays in configdata. The link decoding is done in after_restore().
     *
     * @return array
     */
    public function get_configdata_encoded_attributes() {
        return [];
    }

    /**
     * Returns empty array
     *
     * @return array
     */
    public static function define_decode_contents() {
        return [];
    }

    /**
     * Returns empty array
     *
     * @return array
     */
    public static function define_decode_rules() {
        return [];
    }

    /**
     * This method is called after the complete restore process is done. It calls the
     * link decoders again to handle the showsectionnumber in configdata.
     *
     * @return void
     */
    public function after_restore() {
        global $DB;

        $blockid = $this->get_blockid();

        if ($configdata = $DB->get_field('block_instances', 'configdata', ['id' => $blockid])) {
            $config = $this->decode_configdata($configdata);

            if (isset($config->showsectionname) && !isset($config->showsectionnumber)) {
                // If a 'showsectionname' value is found, add a 'showsectionnumber' => 1 for that config.
                $config->showsectionnumber = 1;

                $configdata = base64_encode(serialize($config));
                $DB->set_field('block_instances', 'configdata', $configdata, ['id' => $blockid]);
            }
        }
    }
}
