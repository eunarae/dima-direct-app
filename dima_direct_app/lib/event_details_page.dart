import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventDetailsPage extends StatefulWidget {
  final DateTime date;
  final String eventDetails;
  final Function(String)? onSave;

  const EventDetailsPage({
    required this.date,
    required this.eventDetails,
    this.onSave,
    super.key,
  });

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  String _eventDetails = '';
  String _startTime = '09:00';
  String _endTime = '10:00';
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _eventDetails = widget.eventDetails;
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _eventDetails = prefs.getString('eventDetails') ?? '';
      _startTime = prefs.getString('startTime') ?? '09:00';
      _endTime = prefs.getString('endTime') ?? '10:00';
      _tags = prefs.getStringList('tags') ?? [];
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('eventDetails', _eventDetails);
    await prefs.setString('startTime', _startTime);
    await prefs.setString('endTime', _endTime);
    await prefs.setStringList('tags', _tags);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '일정 정보 - ${widget.date.year}-${widget.date.month}-${widget.date.day}',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '날짜',
              style: TextStyle(
                color: Color(0xFF565656),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${widget.date.year}-${widget.date.month}-${widget.date.day}',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 32),
            const Text(
              '시간',
              style: TextStyle(
                color: Color(0xFF565656),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '시작 시간: $_startTime, 종료 시간: $_endTime',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 32),
            const Text(
              '메모',
              style: TextStyle(
                color: Color(0xFF565656),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _eventDetails,
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 32),
            const Text(
              '태그',
              style: TextStyle(
                color: Color(0xFF565656),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              children: _tags.map((tag) => Chip(label: Text(tag))).toList(),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (widget.onSave != null) {
                    widget.onSave!(_eventDetails);
                  }
                  await _saveData();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEC268F),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '수정하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
