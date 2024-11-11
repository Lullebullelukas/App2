import 'package:fsek_mobile/april_fools.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fsek_mobile/models/home/calendarevent.dart';
import 'package:fsek_mobile/services/event.service.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/screens/event/event.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now().toLocal();
  DateTime _now = DateTime.now().toLocal();
  DateTime _selectedDay = DateTime.now().toLocal();
  List<CalendarEvent> _selectedEvents = [];
  Map<DateTime, List<CalendarEvent>> _events = {};

  void initState() {
    _selectedDay = DateTime.utc(_now.year, _now.month, _now.day);

    locator<EventService>().getEvents().then((value) => setState(() {
          this._events = value;
          _selectedEvents = _getEventsForDay(_selectedDay);
        }));
    super.initState();
  }

  void openEventPage(CalendarEvent event) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EventPage(eventId: event.id ?? -1)));
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  Widget createEventCard(CalendarEvent event) {
    String locale = Localizations.localeOf(context).toString();
    return Container(
      child: Card(
        // Hide card for introduction events
        shadowColor: event.is_introduction == true ? Colors.transparent : null,
        color: event.is_introduction == true ? Colors.transparent : null,
        child: InkWell(
          onTap: () => openEventPage(event),
          child: Container(
            // Introduction events have a different background
            decoration: event.is_introduction == true
                ? BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/img/nollning-24/schedule/event_card_background.png"),
                      fit: BoxFit.fill,
                    ),
                  )
                : null,

            margin: EdgeInsets.zero,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 7),
                    child: Text(
                      event.title ?? "no title",
                      style: TextStyle(
                        fontSize: 20,
                        // Double ternary just works :)
                        color: (event.is_introduction == true
                            ? Color(0xFF630B0B)
                            : Theme.of(context).colorScheme.primary),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 20,
                      ),
                      Text(
                        /* better error checking */
                        "  " +
                            DateFormat("HH:mm").format(event.start?.toLocal() ?? DateTime.now()) +
                            " - " +
                            DateFormat("HH:mm").format(event.end?.toLocal() ?? DateTime.now()) +
                            ", " +
                            DateFormat("MMMMd", locale).format(event.start?.toLocal() ?? DateTime.now()),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Alcohol is served
                            if (event.drink == true) Icon(Icons.wine_bar_rounded, size: 20),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.room,
                        size: 20,
                      ),
                      Text(
                        "  " + (event.location ?? "intigheten"),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ],
              ),
              margin: event.is_introduction == true
                  ? EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 6, 15, 15, 15)
                  : EdgeInsets.all(10),
            ),
          ),
        ),
        // Introduction events background needs access to entire card
        margin: event.is_introduction == true ? EdgeInsets.symmetric(vertical: 4) : EdgeInsets.all(4),
      ),
    );
  }

  Future<void> _onRefresh() async {
    locator<EventService>().getEvents().then((value) => setState(() {
          this._events = value;
          _selectedEvents = _getEventsForDay(_selectedDay);
        }));
  }

  @override
  Widget build(BuildContext context) {
    String locale = Localizations.localeOf(context).toString();
    if (locale == "sv") {
      DateFormat("MMMMEEEEd", "sv_SE").format(_selectedDay);
    } else {
      DateFormat("MMMMEEEEd", "en_US").format(_selectedDay);
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).colorScheme.background,
      child: RefreshIndicator(
        onRefresh: () => _onRefresh(),
        child: ListView(
          children: [
            Column(
              children: [
                TableCalendar(
                  calendarStyle: CalendarStyle(markerDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground,
                      shape: BoxShape.circle)),
                  availableGestures: AvailableGestures.horizontalSwipe,
                  locale: locale,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  firstDay: DateTime.now().subtract(Duration(days: 365 * 5)),
                  lastDay: DateTime.now().add(Duration(days: 365 * 5)),
                  focusedDay: _focusedDay,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay; // update `_focusedDay` here as well
                      _selectedEvents = _getEventsForDay(selectedDay);
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  eventLoader: (day) {
                    return _getEventsForDay(day);
                  },
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 20,
                  color: Theme.of(context).colorScheme.primary,
                  child: Text(
                    /* It's too late to write pretty code, take this formatting space*/
                    "  " + DateFormat("MMMMEEEEd", locale).format(_selectedDay),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              ],
            ),
            ..._selectedEvents.map((CalendarEvent e) => createEventCard(e)),
            Container(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
