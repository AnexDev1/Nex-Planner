import 'package:flutter/material.dart';

class AddSchedulePage extends StatefulWidget {
  final Function(String, String, String) onAddSchedule;

  const AddSchedulePage({super.key, required this.onAddSchedule});

  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();

  TimeOfDay? _selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addClassSchedule() {
    if (_courseController.text.isNotEmpty &&
        _roomController.text.isNotEmpty &&
        _selectedTime != null) {
      widget.onAddSchedule(
        _selectedTime!.format(context),
        _courseController.text,
        _roomController.text,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Class Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _courseController,
              decoration: const InputDecoration(
                labelText: 'Course',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _roomController,
              decoration: const InputDecoration(
                labelText: 'Room',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedTime != null
                        ? 'Selected Time: ${_selectedTime!.format(context)}'
                        : 'No Time Selected',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addClassSchedule,
              child: const Text('Add Class'),
            ),
          ],
        ),
      ),
    );
  }
}
