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
 * Displays IP address on map.
 *
 * This script is not compatible with IPv6.
 *
 * @package    iplookup
 * @copyright  2008 Petr Skoda (http://skodak.org)
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

require('../config.php');
require_once('lib.php');
require_once('locallib.php');

require_login(0, false);
if (isguestuser()) {
    // Guest users cannot perform lookups.
    throw new require_login_exception('Guests are not allowed here.');
}

$ip   = optional_param('ip', getremoteaddr(), PARAM_RAW);
$user = optional_param('user', 0, PARAM_INT);

if (isset($CFG->iplookup)) {
    // Clean up of old settings.
    set_config('iplookup', NULL);
}

$PAGE->set_url('/iplookup/index.php', array('id'=>$ip, 'user'=>$user));
$PAGE->set_pagelayout('popup');
$PAGE->set_context(context_system::instance());

$info = array($ip);
$note = array();

if (cleanremoteaddr($ip) === false) {
    print_error('invalidipformat', 'error');
}

if (!ip_is_public($ip)) {
    print_error('iplookupprivate', 'error');
}

$info = iplookup_find_location($ip);

if ($info['error']) {
    // Can not display.
    notice($info['error']);
}

if ($user) {
    if ($user = $DB->get_record('user', array('id'=>$user, 'deleted'=>0))) {
        // note: better not show full names to everybody
        if (has_capability('moodle/user:viewdetails', context_user::instance($user->id))) {
            array_unshift($info['title'], fullname($user));
        }
    }
}
array_unshift($info['title'], $ip);

$title = implode(' - ', $info['title']);
$PAGE->set_title(get_string('iplookup', 'admin').': '.$title);
$PAGE->set_heading($title);
echo $OUTPUT->header();
$mapproviders = array ( 'worldmap', 'openstreetmap', 'google' );
$mapprovider_id = get_config('iplookup','mapprovider');
$mapprovider = $mapproviders[$mapprovider_id];
$lon = $info['longitude'];
$lat = $info['latitude'];

if ($mapprovider == "openstreetmap" ){
	openstreetmap($lat, $lon);
}elseif ($mapprovider == "worldmap" ){
	worldmap($lat, $lon);
}elseif ($mapprovider == "google" ){
    if (empty($CFG->googlemapkey3)) {
	openstreetmap($lat, $lon);
    }else{
	googlemap($lat, $lon);
    }
}

echo '<div id="details">'. get_string('coordinates', 'admin') .': '. $info['latitude'] . ', ' . $info['longitude'] .'</div>';
echo '<div id="note">'.$info['note'].'</div>';
echo '<div id="debug">' . get_string('mapprovider','admin') . ': '. $mapprovider .'</div>';

echo $OUTPUT->footer();

