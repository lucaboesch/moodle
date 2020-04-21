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

function worldmap($lat,$lon){
    $imgwidth  = 620;
    $imgheight = 310;
    $dotwidth  = 18;
    $dotheight = 30;
    $lon_sign = 1;
    $lon_margin = "left";
    if (right_to_left()){
    	$lon_sign = -1;
    	$lon_margin = "right";
    }

    $dx = round((( $lon_sign * $lon + 180 ) * ($imgwidth / 360)) - $imgwidth - $dotwidth/2);
    $dy = round((($lat) * ($imgheight / 90)) + $dotheight);

    echo '<div id="map" style="width:'.$imgwidth.'px; height:'.$imgheight.'px;">';
    echo '<img src="earth.jpeg" style="width:'.$imgwidth.'px; height:'.$imgheight.'px" alt="" />';
    echo '<img src="marker.gif" style="width:'.$dotwidth.'px; height:'.$dotheight.'px; margin-'.$lon_margin.':'.$dx.'px; margin-bottom:'.$dy.'px;" alt="'. $lat . ', ' . $lon .'" />';
    echo '</div>';
}
function openstreetmap($lat,$lon){
    //bounding box calculation to set the initial "zoom level" on the map:
    $bboxleft = $lon-1.8270;
    $bboxbottom = $lat-1.0962;
    $bboxright =  $lon+1.8270;
    $bboxtop =  $lat+1.0962;
    
    echo '<div id="map" style="width: 610px; height: 310px">';
    echo '<object data="https://www.openstreetmap.org/export/embed.html?bbox='.$bboxleft.'%2C'.$bboxbottom.'%2C'.$bboxright.'%2C'.$bboxtop.'&layer=mapnik&marker='.$lat.'%2C'.$lon.'" width="100%" height="100%"></object>';
    echo '</div>';

}
function googlemap($lat,$lon){
        if (is_https()) {
            $PAGE->requires->js(new moodle_url('https://maps.googleapis.com/maps/api/js', array('key'=>$CFG->googlemapkey3, 'sensor'=>'false')));
        } else {
            $PAGE->requires->js(new moodle_url('http://maps.googleapis.com/maps/api/js', array('key'=>$CFG->googlemapkey3, 'sensor'=>'false')));
        }
        $module = array('name'=>'core_iplookup', 'fullpath'=>'/iplookup/module.js');
        $PAGE->requires->js_init_call('M.core_iplookup.init3', array($info['latitude'], $info['longitude'], $ip), true, $module);
    
        echo '<div id="map" style="width: 650px; height: 360px"></div>';
}

