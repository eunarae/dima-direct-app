import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'schedule.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final Map<DateTime, List<Map<String, dynamic>>> _events = {
    DateTime(2024, 4, 1): [
      {'title': '회의', 'startTime': '09:00', 'endTime': '10:00'},
      {'title': '점심 식사', 'startTime': '12:00', 'endTime': '13:00'},
    ],
    DateTime(2024, 4, 2): [
      {'title': '미팅', 'startTime': '11:00', 'endTime': '12:00'},
      {'title': '프로젝트 작업', 'startTime': '13:00', 'endTime': '15:00'},
    ],
    DateTime(2024, 4, 3): [
      {'title': '클라이언트 전화', 'startTime': '10:00', 'endTime': '10:30'},
    ],
  };

  List<Map<String, dynamic>> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _selectedEvents = _events[_selectedDate] ?? [];
    _sortEventsByStartTime();
  }

  void _sortEventsByStartTime() {
    _selectedEvents.sort((a, b) {
      final startA = a['startTime'] as String;
      final startB = b['startTime'] as String;
      return startA.compareTo(startB);
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _selectedEvents = _events[selectedDay] ?? [];
      _sortEventsByStartTime();
    });
  }

  void _addEvent(String title, String startTime, String endTime) {
    setState(() {
      if (_events[_selectedDate] != null) {
        _events[_selectedDate]?.add({
          'title': title,
          'startTime': startTime,
          'endTime': endTime,
        });
      } else {
        _events[_selectedDate] = [
          {'title': title, 'startTime': startTime, 'endTime': endTime}
        ];
      }
      _selectedEvents = _events[_selectedDate]!;
      _sortEventsByStartTime();
    });
  }

  void _editEvent(Map<String, dynamic> event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SchedulePage(
          date: _selectedDate,
          eventDetails: event['title'],
          onSave: (newEvent) {
            setState(() {
              _events[_selectedDate]?.remove(event);
              _events[_selectedDate]?.add({
                'title': newEvent,
                'startTime': event['startTime'],
                'endTime': event['endTime']
              });
              _selectedEvents = _events[_selectedDate]!;
              _sortEventsByStartTime();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildCalendar(),
            const SizedBox(height: 8.0),
            _buildEventTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            onPressed: () => _showYearMonthPicker(context),
            child: Row(
              children: [
                Text(
                  '${_selectedDate.year}년 ${_selectedDate.month}월',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.black),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SchedulePage(
                        date: _selectedDate,
                        onSave: (eventDetails) {
                          _addEvent(eventDetails, '09:00', '10:00');
                        })),
              );

              if (result != null) {
                _addEvent(result, '09:00', '10:00');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      locale: 'ko_KR',
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.utc(2025, 12, 31),
      focusedDay: _selectedDate,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDate, day);
      },
      onDaySelected: _onDaySelected,
      eventLoader: (day) {
        return _events[day]?.map((e) => e['title']).toList() ?? [];
      },
      headerVisible: false,
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.black),
        weekendStyle: TextStyle(color: Colors.red),
      ),
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Color(0xFFFFF0F0),
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          color: Color(0xFFEC268F),
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        weekendTextStyle: TextStyle(color: Colors.red),
        holidayTextStyle: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildEventTimeline() {
    return Expanded(
      child: ListView.builder(
        itemCount: 24,
        itemBuilder: (context, hour) {
          final hourString = hour.toString().padLeft(2, '0') + ':00';
          final eventsAtThisHour = _selectedEvents.where((event) {
            final eventStartTime = event['startTime'] as String;
            final eventStartHour = int.parse(eventStartTime.split(':')[0]);
            return hour == eventStartHour;
          }).toList();

          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$hourString',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                for (var event in eventsAtThisHour)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC268F),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          event['title'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          '${event['startTime']} - ${event['endTime']}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                Divider(
                  color: const Color(0xFFA4B9DE).withOpacity(0.2),
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showYearMonthPicker(BuildContext context) {
    final currentYear = DateTime.now().year;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 300,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  '연도 및 월 선택',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: _buildYearPicker(currentYear)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMonthPicker()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildYearPicker(int currentYear) {
    return ListWheelScrollView.useDelegate(
      controller: FixedExtentScrollController(
          initialItem: _selectedDate.year - currentYear + 2),
      itemExtent: 40,
      perspective: 0.003,
      diameterRatio: 1.2,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) {
        setState(() {
          _selectedDate = DateTime(
            currentYear + index - 2,
            _selectedDate.month,
            _selectedDate.day,
          );
        });
      },
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          final year = currentYear + index - 2;
          final isSelected = year == _selectedDate.year;
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFEC268F) : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$year년',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          );
        },
        childCount: 5,
      ),
    );
  }

  Widget _buildMonthPicker() {
    return ListWheelScrollView.useDelegate(
      controller:
          FixedExtentScrollController(initialItem: _selectedDate.month - 1),
      itemExtent: 40,
      perspective: 0.003,
      diameterRatio: 1.2,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) {
        setState(() {
          _selectedDate = DateTime(
            _selectedDate.year,
            index + 1,
            _selectedDate.day,
          );
        });
      },
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          final month = index + 1;
          final isSelected = month == _selectedDate.month;
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFEC268F) : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$month월',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          );
        },
        childCount: 12,
      ),
    );
  }
}
