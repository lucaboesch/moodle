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
 * Provides a word and character count to a essay question textarea.
 *
 * @module     qtype_essay/wordcount
 * @copyright  2018 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
define([
        'jquery',
        'core/str',
        'qtype_essay/wordcount'
    ],
    function(
        $,
        Str
    ) {

        return {
            init: function($params) {
                var count = M.util.get_string('words', 'qtype_essay') + ': 0 / ' + $params.wordlimit + '<br />' +
                    M.util.get_string('characters', 'qtype_essay') + ': 0 / ' + $params.charlimit;
                $('[name="' + $params.editorname + 'wordcount"]').first().html(count);
            }
        };
    });
