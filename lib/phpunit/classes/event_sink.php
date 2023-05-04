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
 * Event sink.
 *
 * @package    core
 * @category   phpunit
 * @copyright  2013 Petr Skoda {@link http://skodak.org}
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */


/**
 * Event redirection sink.
 *
 * @package    core
 * @category   phpunit
 * @copyright  2013 Petr Skoda {@link http://skodak.org}
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class phpunit_event_sink {
    /** @var \core\event\base[] array of events */
    protected $events = array();

    /**
     * Stop event redirection.
     *
     * Use if you do not want event redirected any more.
     */
    public function close() {
        phpunit_util::stop_event_redirection();
    }

    /**
     * To be called from phpunit_util only!
     *
     * @private
     * @param \core\event\base $event record from event_read table
     */
    public function add_event(\core\event\base $event) {
        /* Number events from 0. */
        $this->events[] = $event;
    }

    /**
     * Returns all redirected events.
     *
     * The instances are records form the event_read table.
     * The array indexes are numbered from 0 and the order is matching
     * the creation of events.
     *
     * @return \core\event\base[]
     */
    public function get_events(?callable $filter = null): array {
        if ($filter) {
            return array_filter($this->events, $filter);
        }
        return $this->events;
    }

    /**
     * Return all redirected events for a given component.
     *
     * @param string $component Component name.
     * @return array List of events.
     */
    public function get_events_by_component(string $component): array {
        $component = core_component::normalize_componentname($component);

        return $this->get_events(
            fn ($event) => core_component::normalize_componentname($event->component) === $component,
        );
    }

    /**
     * Return all redirected events for a given component and type.
     *
     * @param string $component Component name.
     * @param string $type Event type.
     * @return array List of events.
     */
    public function get_events_by_component_and_name(
        string $component,
        string $type,
    ): array {
        return array_filter($this->get_events_by_component($component), function($event) use ($name) {
            return $event->eventname == $type;
        });
    }

    /**
     * Return number of events redirected to this sink.
     *
     * @return int
     */
    public function count() {
        return count($this->events);
    }

    /**
     * Removes all previously stored events.
     */
    public function clear() {
        $this->events = array();
    }
}
