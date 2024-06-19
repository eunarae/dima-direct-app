import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchedulePage extends StatefulWidget {
  final DateTime date;
  final String? eventDetails;
  final Function(String)? onSave;

  const SchedulePage({
    required this.date,
    this.eventDetails,
    this.onSave,
    super.key,
  });

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String _eventDetails = '';
  String _startTime = '09:00';
  String _endTime = '10:00';
  List<String> _tags = [];
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _eventDetails = widget.eventDetails ?? '';
    _selectedStartDate = widget.date;
    _selectedEndDate = widget.date;
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
          widget.eventDetails != null
              ? '일정 수정'
              : '일정 추가 - ${widget.date.year}-${widget.date.month}-${widget.date.day}',
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
              '날짜 선택하기',
              style: TextStyle(
                color: Color(0xFF565656),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildDateSelector(),
            const SizedBox(height: 32),
            const Text(
              '시간 선택하기',
              style: TextStyle(
                color: Color(0xFF565656),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildTimeInput(),
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
            _buildMemoField(),
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
            _buildTagInput(),
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
                child: Text(
                  widget.eventDetails != null ? '수정하기' : '저장하기',
                  style: const TextStyle(
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

  Widget _buildDateSelector() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context, true),
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFEC268F)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '시작: ${_selectedStartDate.year}-${_selectedStartDate.month}-${_selectedStartDate.day}',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context, false),
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFEC268F)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '종료: ${_selectedEndDate.year}-${_selectedEndDate.month}-${_selectedEndDate.day}',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime initialDate = isStart ? _selectedStartDate : _selectedEndDate;
    DateTime firstDate = DateTime(DateTime.now().year - 5);
    DateTime lastDate = DateTime(DateTime.now().year + 5);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        if (isStart) {
          _selectedStartDate = pickedDate;
        } else {
          _selectedEndDate = pickedDate;
        }
      });
    }
  }

  Widget _buildTimeInput() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: _startTime,
            decoration: InputDecoration(
              labelText: '시작 시간',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _startTime = value;
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            initialValue: _endTime,
            decoration: InputDecoration(
              labelText: '종료 시간',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _endTime = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMemoField() {
    return Container(
      width: double.infinity,
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFEC268F)),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (value) {
            setState(() {
              _eventDetails = value;
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '메모를 입력하세요...',
            hintStyle: TextStyle(color: Color(0xFF94A3B8)),
          ),
          maxLines: null,
          style: TextStyle(color: Color(0xFF1E293B)),
        ),
      ),
    );
  }

  Widget _buildTagInput() {
    TextEditingController _tagController = TextEditingController();

    return Wrap(
      spacing: 8.0,
      children: [
        for (var tag in _tags)
          Chip(
            label: Text(tag),
            onDeleted: () {
              setState(() {
                _tags.remove(tag);
              });
            },
          ),
        TextField(
          controller: _tagController,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _tags.add(value);
                _tagController.clear();
              });
            }
          },
          decoration: InputDecoration(
            hintText: '태그를 입력하세요...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFEC268F)),
            ),
          ),
        ),
      ],
    );
  }
}
