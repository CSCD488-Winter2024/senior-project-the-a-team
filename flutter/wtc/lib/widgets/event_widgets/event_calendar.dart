import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wtc/User/user.dart';
import 'package:wtc/widgets/event_widgets/event.dart';
import 'package:wtc/widgets/post_widgets/post_body_box.dart';
import 'package:wtc/widgets/post_widgets/post_tag_box.dart';

User user =
    User(userId: Guid.newGuid, username: "TestUser", email: "TestUser@wtc.org");

Event event1 = Event(
  title: "event 1",
  body: "This is a test",
  tags: const ["event", "tag2"],
  date: DateTime.utc(2024, 4, 15),
  time: const TimeOfDay(hour: 13, minute: 0),
  header: '',
  user: user,
  interestCount: 50,
  created: DateTime.utc(2024, 4, 15),
  postId: Guid.newGuid,
  location: 'Everywhere',
  attendingCount: 10000,
  maybeCount: 200,
);
Event event2 = Event(
  title: "Starbucks Sale",
  body: "Everything at Starbucks is 50% off!",
  tags: const ["event", "tag2"],
  date: DateTime.utc(2024, 4, 22),
  time: const TimeOfDay(hour: 13, minute: 0),
  header: '',
  user: user,
  interestCount: 50,
  created: DateTime.utc(2024, 4, 15),
  postId: Guid.newGuid,
  location: 'Local Starbs',
  attendingCount: 10000,
  maybeCount: 200,
);
Event event3 = Event(
  title: "event 3",
  body: "This is a test",
  tags: const ["event", "tag2"],
  date: DateTime.utc(2024, 4, 22),
  time: const TimeOfDay(hour: 13, minute: 0),
  header: '',
  user: user,
  interestCount: 50,
  created: DateTime.utc(2024, 4, 15),
  postId: Guid.newGuid,
  location: 'Everywhere',
  attendingCount: 10000,
  maybeCount: 200,
);

class EventCalendar extends StatefulWidget {
  const EventCalendar({super.key});

  @override
  State<EventCalendar> createState() => _EventCalendar();
}

class _EventCalendar extends State<EventCalendar> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<Event>> events =
      {}; //Used to show events as dots on the calendar
  List<Event> eventPosts = [
    event1,
    event2,
    event3,
    event3,
    event3,
    event3,
    event3,
  ];
  List<Event> _selectedEvents =
      []; //Actual list of events that will be displayed beneath the calendar

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = _getEventsForDay(_selectedDay!);

    for (int i = 0; i < eventPosts.length; i++) {
      if (events[eventPosts[i].date] != null) {
        events[eventPosts[i].date]?.add(eventPosts[i]);
      } else {
        List<Event> temp = [];
        temp.add(eventPosts[i]);
        events.addAll({eventPosts[i].date: temp});
      }
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2024, 12, 31),
            eventLoader: _getEventsForDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents = _getEventsForDay(_selectedDay!);
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: _buildEventButtonList(),
          )
        ],
      ),
    );
  }

  Widget _buildEventList() {
    return ListView.builder(
      itemCount: _selectedEvents.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(
                '${_selectedEvents[index].title} Date: ${_selectedEvents[index].date.toString().split(' ')[0]} Time: ${_selectedEvents[index].time.toString().split('(')[1].split(')')[0]}'));
      },
    );
  }

  Widget _buildEventButtonList() {
    return ListView.builder(
      itemCount: _selectedEvents.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => const Color(0xffd4bc93))),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          scrollable: true,
                          title: Container(
                            decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(
                                    Radius.elliptical(20, 15))),
                            child: Text(
                              _selectedEvents[index].title,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          content: Column(
                            children: [
                              Text(
                                _selectedEvents[index]
                                    .date
                                    .toString()
                                    .split(' ')[0],
                              ),
                              Text(
                                _selectedEvents[index]
                                    .time
                                    .toString()
                                    .split('(')[1]
                                    .split(')')[0],
                              ),
                              PostTagBox(tags: _selectedEvents[index].tags),
                              PostBodyBox(
                                  body: "\n${_selectedEvents[index].body}\n"),
                              SizedBox(
                                  width: 600,
                                  child: Text(
                                    "Attending: ${_selectedEvents[index].attendingCount}   Maybe Going: ${_selectedEvents[index].maybeCount}",
                                    textAlign: TextAlign.center,
                                  ))
                            ],
                          ));
                    });
              },
              child: Text(
                _selectedEvents[index].title,
              )),
        );
      },
    );
  }
}
