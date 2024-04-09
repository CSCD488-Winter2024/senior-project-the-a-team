import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wtc/widgets/post_widgets/post.dart';

Post event1 = Post(
    title: "event 1",
    body: "This is a test",
    tags: const ["event", "tag2"],
    isAlert: false,
    isEvent: true,
    date: DateTime.utc(2024, 4, 22),
    time: const TimeOfDay(hour: 13, minute: 0));
Post event2 = Post(
    title: "event 2",
    body: "This is a test",
    tags: const ["event", "tag2", "tag7"],
    isAlert: false,
    isEvent: true,
    date: DateTime.utc(2024, 4, 22),
    time: const TimeOfDay(hour: 13, minute: 0));
Post event3 = Post(
    title: "event 3",
    body: "This is a test",
    tags: const ["event", "tag2"],
    isAlert: false,
    isEvent: true,
    date: DateTime.utc(2024, 4, 15),
    time: const TimeOfDay(hour: 13, minute: 0));

List<Post> eventPosts = [event1, event2, event3];

class EventCalendar extends StatefulWidget {
  const EventCalendar({super.key});

  @override
  State<EventCalendar> createState() => _EventCalendar();
}

class _EventCalendar extends State<EventCalendar> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime?, List<Post>> events = {
    //used to add dots on the calendar
    event1.date: [event1, event2],
    event3.date: [event3]
  };
  List<Post> _selectedEvents =
      []; //Actual list of events that will be displayed beneath the calendar

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = _getEventsForDay(_selectedDay!);
  }

  List<Post> _getEventsForDay(DateTime day) {
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
            child: _buildEventList(),
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
}
