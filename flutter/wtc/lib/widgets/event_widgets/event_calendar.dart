import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wtc/widgets/event_widgets/event.dart';
import 'package:wtc/widgets/post_widgets/post_body_box.dart';
import 'package:wtc/widgets/post_widgets/post_tag_box.dart';
import 'package:wtc/widgets/going_maybe_count_buttons.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({super.key});

  @override
  State<EventCalendar> createState() => _EventCalendar();
}

class _EventCalendar extends State<EventCalendar> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DateTime? _selectedDay;
  DateTime? today;
  DateTime? _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  List<Event>? eventPosts;
  Map<DateTime, List<Event>> events =
      {}; //Used to show events as dots on the calendar
  List<Event> _selectedEvents =
      []; //Actual list of events that will be displayed beneath the calendar
  List<String> _userTags = ['NONE'];

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    _focusedDay = DateTime.utc(today!.year, today!.month, today!.day);
    _selectedDay = _focusedDay;
    //print(_userTags);
    _initializeEvents();
  }

  Future<void> _initializeEvents() async {
    var userTags = await _getUsersTags();
    setState(() {
      if (userTags.isNotEmpty) {
        _userTags = userTags;
      }
    });
    eventPosts = await getEvents();
    setState(() {
      for (var event in eventPosts!) {
        if (events[event.date] != null) {
          events[event.date]?.add(event);
        } else {
          events[event.date] = [event];
        }
      }
      _selectedEvents = _getEventsForDay(_selectedDay!);
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  Future<List<String>> _getUsersTags() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    var userInfo =
        await _firestore.collection("users").doc(currentUser?.uid).get();
    List<dynamic> userTagsDynamic = userInfo.data()?['tags'] ?? ['none'];
    List<String> userTags = userTagsDynamic.cast<String>();
    return userTags;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Color(0xfff0e8d6),
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              color: Colors.black,
            ),
            selectedDecoration: BoxDecoration(
              color: Color(0xffd4bc93),
              shape: BoxShape.circle,
            ),
          ),
          focusedDay: _focusedDay!,
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2124, 12, 31),
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
                                color: Color(0xFF45302A),
                                borderRadius: BorderRadius.all(
                                    Radius.elliptical(20, 15))),
                            child: Text(
                              _selectedEvents[index].title,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
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
                              GoingMaybeCountButtons(
                                postID: _selectedEvents[index].postId,
                              )
                            ],
                          ));
                    });
              },
              child: Text(
                _selectedEvents[index].title,
                style: const TextStyle(
                  color: Colors.black,
                ),
              )),
        );
      },
    );
  }

  Future<List<Event>> getEvents() async {
    List<Event> events = [];
    try {
      CollectionReference collection = _firestore.collection('_posts');
      QuerySnapshot snapshot = await collection
          .where('type', isEqualTo: 'Event')
          .where('tags', arrayContainsAny: _userTags)
          .orderBy('timestamp', descending: true)
          .get();
      for (var doc in snapshot.docs) {
        var tempTags = doc['tags'] as List<dynamic>;
        List<String> postTags = [];
        String dateCreated = doc['createdAt'] as String;

        for (int i = 0; i < tempTags.length; i++) {
          postTags.add(tempTags[i]);
        }
        String dateOfEvent = doc['eventDate'] as String;
        String timeOfEvent = doc['eventTime'] as String;
        var time = timeOfEvent.split(' ');
        int hour = 0;
        if (time[1] == "PM") {
          if (time[0].split(":")[0] == "12") {
            hour = 12;
          } else {
            hour = int.parse(time[0].split(":")[0]) + 12;
          }
        } else {
          hour = int.parse(time[0].split(":")[0]);
        }
        int minute = int.parse(time[0].split(":")[1]);
        Event event = Event(
          title: doc['title'] as String,
          body: doc['body'] as String,
          tags: postTags,
          header: doc['header'] as String,
          interestCount: doc['interestCount'] as int,
          created: DateTime(
              int.parse(dateCreated.split("-")[0]),
              int.parse(dateCreated.split("-")[1]),
              int.parse(dateCreated.split("-")[2])),
          postId: Guid(doc['postID'] as String),
          userEmail: doc['user'] as String,
          date: DateTime.utc(
            int.parse(dateOfEvent.split("-")[0]),
            int.parse(dateOfEvent.split("-")[1]),
            int.parse(dateOfEvent.split("-")[2]),
          ),
          time: TimeOfDay(hour: hour, minute: minute),
          location: doc['address'] as String,
          attendingCount: doc['attendingCount'] as int,
          maybeCount: doc['maybeCount'] as int,
          isMyPost: false,
          pfp: doc['pfp'] as String,
          username: doc['username'] as String,
        );

        events.add(event);
      }
    } catch (e) {
      // do nothing
    }
    return events;
  }
}
