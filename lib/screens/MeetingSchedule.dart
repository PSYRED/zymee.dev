import 'package:flutter/material.dart';

import '../widgets/CalendarWidget.dart';

class MeetingSchedule extends StatefulWidget {
  const MeetingSchedule({Key? key}) : super(key: key);

  @override
  State<MeetingSchedule> createState() => _MeetingScheduleState();
}

class _MeetingScheduleState extends State<MeetingSchedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule Meeting"),
        centerTitle: true,
      ),
      body: CalendarWidget()
    );
  }
}
