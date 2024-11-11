import 'package:fsek_mobile/april_fools.dart';
import 'package:flutter/material.dart';
import 'package:fsek_mobile/models/cafe/cafe_shift.dart';
import 'package:fsek_mobile/screens/cafe/cafe_shift.dart';
import 'package:fsek_mobile/services/cafe.service.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CafePage extends StatefulWidget {
  @override
  _CafePageState createState() => _CafePageState();
}

class _CafePageState extends State<CafePage> {
  DateTime _now = DateTime.now().toLocal();
  DateTime _focusedDay = DateTime.now().toLocal();
  DateTime _selectedDay = DateTime.now().toLocal();
  List<CafeShift> _selectedEvents = [];
  Map<DateTime, List<CafeShift>> _events = {};

  void initState() {
    _selectedDay = DateTime.utc(_now.year, _now.month, _now.day);
    locator<CafeService>().getShiftsForCalendar().then((value) => setState(() {
          this._events = value;
          _selectedEvents = _getEventsForDay(_selectedDay);
        }));
    super.initState();
  }

  List<CafeShift> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  Widget createCafeShiftCard(CafeShift shift) {
    var t = AppLocalizations.of(context)!;
    return Card(
      color: (shift.user != null)
          ? Theme.of(context).colorScheme.surfaceTint
          : null,
      child: InkWell(
        onTap: () => openCafeShiftPage(shift),
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 7),
                child: Column(
                  children: [
                    Text(
                      shift.duration ?? "för alltid",
                      style: TextStyle(
                        fontSize: 15,
                        color: (Theme.of(context).colorScheme.primary),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      shift.user?.name ?? t.cafeShiftShift,
                      style: TextStyle(
                        fontSize: 18,
                        color: (shift.user != null ? Theme.of(context).colorScheme.onInverseSurface : Theme.of(context).colorScheme.onSurface),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void openCafeShiftPage(CafeShift shift) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CafeShiftPage(
          shiftId: shift.id ?? -1,
          user: shift.user,
        ),
      ),
    ).then(
      // after returning from cafe_shift page, update the calendar
      (value) => locator<CafeService>()
          .getShiftsForCalendar()
          .then((value) => setState(() {
                this._events = value;
                _selectedEvents = _getEventsForDay(_selectedDay);
              })),
    );
  }

  List<Widget> createPairShifts(List<CafeShift> dayShifts) {
    // create pairs of shifts (which we will assume to have the same time)
    List<Widget> pairList = [];
    Row pair;
    for (var i = 0; i < dayShifts.length / 2; i++) {
      pair = Row(
        children: [
          Expanded(child: createCafeShiftCard(dayShifts[2 * i])),
          Expanded(child: createCafeShiftCard(dayShifts[2 * i + 1])),
        ],
      );
      pairList.add(pair);
    }
    return pairList;
  }

  @override
  Widget build(BuildContext context) {
    String locale = Localizations.localeOf(context).toString();
    return Scaffold(
      appBar: AppBar(
        title: Text("Hilbert Café"),
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(),
        child: ListView(
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
              calendarFormat: CalendarFormat.week,
              availableCalendarFormats: {CalendarFormat.week: "Week"},
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
            ...createPairShifts(_selectedEvents),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    locator<CafeService>().getShiftsForCalendar().then((value) => setState(() {
          this._events = value;
        }));
  }
}
