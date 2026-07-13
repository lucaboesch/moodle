<?php

/// This file allows to manage the default behaviour of the display formats

require_once("../../config.php");
require_once($CFG->libdir.'/adminlib.php');
require_once("lib.php");

$id   = required_param('id', PARAM_INT);
$mode = optional_param('mode', '', PARAM_ALPHANUMEXT);

$url = new moodle_url('/mod/glossary/formats.php', array('id'=>$id));
if ($mode !== '') {
    $url->param('mode', $mode);
}
$PAGE->set_url($url);

admin_externalpage_setup('managemodules'); // this is hacky, tehre should be a special hidden page for it

if ( !$displayformat = $DB->get_record("glossary_formats", array("id"=>$id))) {
    throw new \moodle_exception('invalidglossaryformat', 'glossary');
}

$form = data_submitted();
if ( $mode == 'visible' and confirm_sesskey()) {
    if ( $displayformat ) {
        if ( $displayformat->visible ) {
            $displayformat->visible = 0;
        } else {
            $displayformat->visible = 1;
        }
        $DB->update_record("glossary_formats",$displayformat);
    }
    redirect("$CFG->wwwroot/$CFG->admin/settings.php?section=modsettingglossary#glossary_formats_header");
    die;
} elseif ( $mode == 'edit' and $form and confirm_sesskey()) {

    $displayformat->popupformatname = $form->popupformatname;
    $displayformat->showgroup   = $form->showgroup;
    $displayformat->defaultmode = $form->defaultmode;
    $displayformat->defaulthook = $form->defaulthook;
    $displayformat->sortkey     = $form->sortkey;
    $displayformat->sortorder   = $form->sortorder;

    // Extract visible tabs from array into comma separated list.
    $visibletabs = implode(',', $form->visibletabs ?? []);

    // Include 'standard' tab by default along with other tabs.
    // This way we don't run into the risk of users not selecting any tab for displayformat.
    $displayformat->showtabs = GLOSSARY_STANDARD.','.$visibletabs;

    $DB->update_record("glossary_formats",$displayformat);
    redirect("$CFG->wwwroot/$CFG->admin/settings.php?section=modsettingglossary#glossary_formats_header");
    die;
}

$strmodulename = get_string("modulename", "glossary");
$strdisplayformats = get_string("displayformats","glossary");

echo $OUTPUT->header();

echo $OUTPUT->heading($strmodulename . ': ' . get_string("displayformats","glossary"));

echo $OUTPUT->box(get_string("configwarning", 'admin'), "generalbox boxaligncenter boxwidthnormal");
echo "<br />";

$yes = get_string("yes");
$no  = get_string("no");

echo '<form method="post" action="formats.php" id="form">';
echo '<table width="90%" align="center" class="generalbox table-reboot">';

echo "<tr>";
echo "<td colspan=\"3\" class=\"text-center pb-3\"><strong>";
echo get_string('displayformat' . $displayformat->name, 'glossary');
echo "</strong></td>";
echo "</tr>";
echo "<tr class=\"align-middle\">";
echo "<td class=\"text-end pe-3\" width=\"20%\">";
echo html_writer::label(get_string('popupformat', 'glossary'), 'menupopupformatname');
echo "</td>";
echo "<td>";
// Get available formats.
$recformats = $DB->get_records("glossary_formats");

$formats = [];

// Take names.
foreach ($recformats as $format) {
    $formats[$format->name] = get_string("displayformat$format->name", "glossary");
}
// Sort it.
asort($formats);

echo html_writer::select($formats, 'popupformatname', $displayformat->popupformatname, false);
echo "</td>";
echo "<td width=\"60%\" class=\"ps-3\">";
print_string("cnfrelatedview", "glossary");
echo "</td>";
echo "</tr>";
echo "<tr class=\"align-middle\">";
echo "<td class=\"text-end pe-3\" width=\"20%\"><label for=\"defaultmode\">";
print_string('defaultmode', 'glossary');
echo "</label></td>";
echo "<td>";
echo "<select size=\"1\" id=\"defaultmode\" name=\"defaultmode\" class=\"select form-select\">";
$sletter = '';
$scat = '';
$sauthor = '';
$sdate = '';
switch (strtolower($displayformat->defaultmode)) {
    case 'letter':
        $sletter = ' selected="selected" ';
    break;

    case 'cat':
        $scat = ' selected="selected" ';
    break;

    case 'date':
        $sdate = ' selected="selected" ';
    break;

    case 'author':
        $sauthor = ' selected="selected" ';
    break;
}

echo "<option value=\"letter" . p($sletter) . "\">";
print_string("letter", "glossary");
echo "</option>";
echo "<option value=\"cat" . p($scat) . "\">";
print_string("cat", "glossary");
echo "</option>";
echo "<option value=\"date" . p($sdate) . "\">";
print_string("date", "glossary");
echo "</option>";
echo "<option value=\"author" . p($sauthor) . "\">";
print_string("author", "glossary");
echo "</option>";
echo "</select>";
echo "</td>";
echo "<td width=\"60%\" class=\"ps-3\">";
print_string("cnfdefaultmode", "glossary");
echo "</td>";
echo "</tr>";
echo "<tr class=\"align-middle\">";
echo "<td class=\"text-end pe-3\" width=\"20%\"><label for=\"defaulthook\">";
print_string('defaulthook', 'glossary');
echo "</label></td>";
echo "<td>";
echo "<select size=\"1\" id=\"defaulthook\" name=\"defaulthook\" class=\"select form-select\">";
$sall = '';
$sspecial = '';
$sallcategories = '';
$snocategorised = '';
switch (strtolower($displayformat->defaulthook)) {
    case 'all':
        $sall = ' selected="selected" ';
    break;

    case 'special':
        $sspecial = ' selected="selected" ';
    break;

    case '0':
        $sallcategories = ' selected="selected" ';
    break;

    case '-1':
        $snocategorised = ' selected="selected" ';
    break;
}
echo "<option value=\"ALL\"";
p($sall);
echo ">";
p(get_string("allentries", "glossary"));
echo "</option>";
echo "<option value=\"SPECIAL\"";
p($sspecial);
echo ">";
p(get_string("special", "glossary"));
echo "</option>";
echo "<option value=\"0\"";
p($sallcategories);
echo ">";
p(get_string("allcategories", "glossary"));
echo "</option>";
echo "<option value=\"-1\"";
p($snocategorised);
echo ">";
p(get_string("notcategorised", "glossary"));
echo "</option>";
echo "</select>";
echo "</td>";
echo "<td width=\"60%\" class=\"ps-3\">";
print_string("cnfdefaulthook", "glossary");
echo "</td>";
echo "</tr>";
echo "<tr class=\"align-middle\">";
echo "<td class=\"text-end pe-3\" width=\"20%\"><label for=\"sortkey\">";
print_string('defaultsortkey', 'glossary');
echo "</label></td>";
echo "<td>";
echo "<select size=\"1\" id=\"sortkey\" name=\"sortkey\" class=\"select form-select\">";
$sfname = '';
$slname = '';
$supdate = '';
$screation = '';
switch (strtolower($displayformat->sortkey)) {
    case 'firstname':
        $sfname = ' selected="selected" ';
    break;

    case 'lastname':
        $slname = ' selected="selected" ';
    break;

    case 'creation':
        $screation = ' selected="selected" ';
    break;

    case 'update':
        $supdate = ' selected="selected" ';
    break;
}
echo "<option value=\"CREATION\"";
p($screation);
echo ">";
p(get_string("sortbycreation", "glossary"));
echo "</option>";
echo "<option value=\"UPDATE\"";
p($supdate);
echo ">";
p(get_string("sortbylastupdate", "glossary"));
echo "</option>";
echo "<option value=\"FIRSTNAME\"";
p($sfname);
echo ">";
p(get_string("firstname"));
echo "</option>";
echo "<option value=\"LASTNAME\"";
p($slname);
echo ">";
p(get_string("lastname"));
echo "</option>";
echo "</select>";
echo "</td>";
echo "<td width=\"60%\" class=\"ps-3\">";
print_string("cnfsortkey", "glossary");
echo "</td>";
echo "</tr>";

echo "<tr class=\"align-middle\">";
echo "<td class=\"text-end pe-3\" width=\"20%\"><label for=\"sortorder\">";
print_string('defaultsortorder', 'glossary');
echo "</label></td>";
echo "<td>";
echo "<select size=\"1\" id=\"sortorder\" name=\"sortorder\" class=\"select form-select\">";
$sasc = '';
$sdesc = '';
switch (strtolower($displayformat->sortorder)) {
    case 'asc':
        $sasc = ' selected="selected" ';
    break;

    case 'desc':
        $sdesc = ' selected="selected" ';
    break;
}
echo "<option value=\"asc\"";
p($sasc);
echo ">";
p(get_string("ascending", "glossary"));
echo "</option>";
echo "<option value=\"desc\"";
p($sdesc);
echo ">";
p(get_string("descending", "glossary"));
echo "</option>";
echo "</select>";
echo "</td>";
echo "<td width=\"60%\" class=\"ps-3\">";
print_string("cnfsortorder", "glossary");
echo "</td>";
echo "</tr>";
echo "<tr class=\"align-middle\">";
echo "<td class=\"text-end pe-3\" width=\"20%\"><label for=\"showgroup\">";
print_string("includegroupbreaks", "glossary");
echo ":</label></td>";
echo "<td>";
echo "<select size=\"1\" id=\"showgroup\" name=\"showgroup\" class=\"select form-select\">";
$yselected = "";
$nselected = "";
if ($displayformat->showgroup) {
    $yselected = " selected=\"selected\" ";
} else {
    $nselected = " selected=\"selected\" ";
}

echo "<option value=\"1\"" . $yselected . ">";
p($yes);
echo "</option>";
echo "<option value=\"0\"" . $nselected . ">";
p($no);
echo "</option>";
echo "</select>";
echo "</td>";
echo "<td width=\"60%\" class=\"ps-3\">";
print_string("cnfshowgroup", "glossary");
echo "</td>";
echo "</tr>";

echo "<tr class=\"align-middle\">";
echo "<td class=\"text-end pe-3\" width=\"20%\"><label for=\"visibletabs\">";
print_string("visibletabs", "glossary");
echo "</label></td>";
echo "<td>";
        // Get all glossary tabs.
        $glossarytabs = glossary_get_all_tabs();
        // Extract showtabs value in an array.
        $visibletabs = glossary_get_visible_tabs($displayformat);
        $size = min(10, count($glossarytabs));
echo html_writer::select($glossarytabs, 'visibletabs[]', $visibletabs, false, [
    'id' => 'visibletabs',
    'multiple' => 'multiple',
    'size' => $size,
]);
echo "</td>";
echo "<td width=\"60%\" class=\"ps-3\">";
print_string("cnftabs", "glossary");
echo "</td>";
echo "</tr>";
echo "<tr>";
echo "<td colspan=\"3\" align=\"center\">";
echo "<input type=\"submit\" class=\"btn btn-primary\" value=\"";
print_string("savechanges");
echo "\"/></td>";
echo "</tr>";
echo "<input type=\"hidden\" name=\"id\" value=\"";
p($id);
echo "\" />";
echo "<input type=\"hidden\" name=\"sesskey\" value=\"" . sesskey() . "\" />";
echo "<input type=\"hidden\" name=\"mode\" value=\"edit\" />";

echo '</table></form>';

echo $OUTPUT->footer();
