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
        'core/templates',
        'core/notification',
        'qtype_essay/wordcount'
    ],
    function(
        $,
        Str,
        templates,
        notification
    ) {
        return {
            /**
             * The number of times to try redetecting TinyMCE.
             *
             * @property TINYMCE_DETECTION_REPEATS
             * @type Number
             * @default 20
             * @private
             */
            TINYMCE_DETECTION_REPEATS: 20,
            /**
             * The amount of time (in milliseconds) to wait between TinyMCE detections.
             *
             * @property TINYMCE_DETECTION_DELAY
             * @type Number
             * @default 500
             * @private
             */
            TINYMCE_DETECTION_DELAY:  500,

            VALUE_CHANGE_ELEMENTS: 'input, textarea, [contenteditable="true"]',
            CHANGE_ELEMENTS:       'input, select',

            ctx: {},
            lastTimeout: null,
            wc_done: function(data, response) {
                console.log('ajax arrived');
                for (var key in data) {
                    if (data.hasOwnProperty(key)) {
                        this.set_wordcount(key, data[key].characters, data[key].words);
                    }
                }
                this.in_flight = false;
            },
            wc_failed: function() {
                this.in_flight = false;
                alert("failed");
            },
            set_wordcount_html: function(key, html) {
                $(document.getElementById(key + '_wordcount')).replaceWith(html);
            },
            set_wordcount: function(key, chars, words) {

                const max_chars = this.ctx[key].charlimit;
                const max_words = this.ctx[key].wordlimit;
                const words_ok = words <= max_words;
                const chars_ok = chars <= max_chars;
                var context = {
                    words_ok: words <= max_words,
                    chars_ok: chars <= max_chars,
                    max_words: max_words,
                    max_chars: max_chars,
                    chars: chars,
                    words: words
                };

                templates.render('qtype_essay/wordcount', context)
                    .then(function(html, js) {
                        $(document.getElementById(key + '_wordcount')).html(html);
                    })
                    .fail(notification.exception);
            },
            update_wordcount: function(edi) {
                if (this.lastTimeout !== null) {
                    window.clearTimeout(this.lastTimeout);
                }
                var mythis = this;
                //console.log('setTimeout', Math.random());
                this.lastTimeout = setTimeout(function() {
                    if (mythis.in_flight) {
                        console.log('event should be removed');
                    }
                    console.log('ajax sent');

                    if (typeof window.tinyMCE !== 'undefined') {
                        window.tinyMCE.selectedInstance.save();
                    }
                    mythis.in_flight = $.ajax({
                        url: M.cfg.wwwroot + "/question/type/essay/wc.ajax.php",
                        data: $('#responseform').serialize(),
                        method: 'POST',
                        context: mythis,
                        success: mythis.wc_done,
                        error: mythis.wc_failed
                    });
                }, 500);
            },
            update_wordcount_tinymce: function(editor) {
                this.update_wordcount();
            },
            init_tinymce: function(repeatcount) {
                if (typeof window.tinyMCE === 'undefined') {
                    if (repeatcount > 0) {
                        Y.later(this.TINYMCE_DETECTION_DELAY, this, this.init_tinymce, [repeatcount - 1]);
                    } else {
                        console.log('Gave up looking for TinyMCE.');
                    }
                    return;
                }
                window.tinyMCE.onAddEditor.add(this.init_tinymce_editor, this);
            },


            init_tinymce_editor: function(e, editor) {
                console.log(this);
                var mythis = this;
                editor.onChange.add(this.update_wordcount_tinymce, this);
                editor.onRedo.add(this.update_wordcount_tinymce, this);
                editor.onUndo.add(this.update_wordcount_tinymce, this);;
                editor.onKeyPress.add(this.update_wordcount_tinymce, this);
            },

            init: function($params) {
                if($params.readonly) {
                    return;
                }
                this.ctx[$params.editorname] = $params;
                this.lastTimeout = null;
                // This is for Atto and clear Textarea!

                var mythis = this;
                $('#responseform').find(this.VALUE_CHANGE_ELEMENTS).on('change keyup paste', function() {mythis.update_wordcount(); });
                // This is for TinyMCE only!
                this.init_tinymce();
                this.update_wordcount();

            }
        };
    });
