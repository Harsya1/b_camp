import 'package:flutter/material.dart';
import 'dashboard_camp.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DashboardCalender extends StatefulWidget {
  const DashboardCalender({super.key});

  @override
  State<DashboardCalender> createState() => _DashboardCalenderState();
}

class _DashboardCalenderState extends State<DashboardCalender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Calendar')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: const Text(
                'B-Camp Admin Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Dashboard Camp'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardCamp(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Dashboard Calendar'),
              onTap: () {
                Navigator.pop(context); // Tetap di halaman ini
              },
            ),
          ],
        ),
      ),
      body: _contentCalendar(), // Gunakan widget kalender di sini
    );
  }

  Widget _contentCalendar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kalender Booking',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SfCalendar(
              view: CalendarView.month, // Tampilan kalender bulanan
              firstDayOfWeek: 1, // Mulai dari hari Senin
              dataSource: _getCalendarDataSource(), // Data untuk kalender
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                showAgenda: true, // Menampilkan agenda di bawah kalender
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk mendapatkan data sumber kalender
  MeetingDataSource _getCalendarDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    meetings.add(
      Meeting(
        eventName: 'Meeting with Team',
        from: DateTime.now(),
        to: DateTime.now().add(const Duration(hours: 2)),
        background: Colors.blue,
        isAllDay: false,
      ),
    );
    meetings.add(
      Meeting(
        eventName: 'Project Deadline',
        from: DateTime.now().add(const Duration(days: 1)),
        to: DateTime.now().add(const Duration(days: 1, hours: 3)),
        background: Colors.red,
        isAllDay: true,
      ),
    );
    return MeetingDataSource(meetings);
  }
}

// Model untuk data kalender
class Meeting {
  Meeting({
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    this.isAllDay = false,
  });

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
}

// DataSource untuk kalender
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}
