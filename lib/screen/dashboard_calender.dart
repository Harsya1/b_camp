import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'dashboard_camp.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:supercharged/supercharged.dart';

class DashboardCalender extends StatefulWidget {
  const DashboardCalender({super.key});

  @override
  State<DashboardCalender> createState() => _DashboardCalenderState();
}

class _DashboardCalenderState extends State<DashboardCalender> {
  int selectedRoomIndex = 0;
  final CalendarController _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Calendar')),
      drawer: _buildDrawer(),
      body: Row(
        children: [
          _buildRoomList(),
          Expanded(child: _contentCalendar(selectedRoomIndex)),
        ],
      ),
    );
  }

  // Drawer menu dengan tombol login di bawah
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              child: const Text(
                'B-Camp Admin Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Dashboard Camp'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardCamp()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Dashboard Calendar'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Daftar kamar di kiri
  Widget _buildRoomList() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      color: Colors.grey[100],
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => setState(() => selectedRoomIndex = index),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    selectedRoomIndex == index
                        ? "FFCA07".toColor()
                        : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'No. kamar',
                    style: TextStyle(fontSize: 8, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Konten utama: dropdown + kalender
  Widget _contentCalendar(int roomIndex) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownSearch<String>(
            mode: Mode.form,
            items: (filter, cs) => ['VVIP', 'VIP', 'Barack'],
            selectedItem: 'VVIP',
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                labelText: 'Pilih Camp',
                hintText: 'Pilih tipe',
              ),
            ),
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SfCalendar(
                controller: _calendarController,
                view: CalendarView.month,
                firstDayOfWeek: 1,
                dataSource: _getCalendarDataSource(roomIndex),
                monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                  showAgenda: true,
                ),
                headerStyle: CalendarHeaderStyle(
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  backgroundColor: "FFCA07".toColor(),
                ),
                headerHeight: 50,
                headerDateFormat: 'MMMM yyyy',
                onTap: (calendarTapDetails) {
                  // Optional: handle tap on calendar
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Data dummy kalender per kamar
  MeetingDataSource _getCalendarDataSource(int roomIndex) {
    final List<Meeting> meetings = [];
    if (roomIndex == 0) {
      meetings.add(
        Meeting(
          eventName: 'Meeting with Team',
          from: DateTime.now(),
          to: DateTime.now().add(const Duration(days: 5)),
          background: Colors.blue,
          isAllDay: false,
        ),
      );
      meetings.add(
        Meeting(
          eventName: 'Maintenance',
          from: DateTime.now().add(const Duration(days: 3)),
          to: DateTime.now().add(const Duration(days: 3, hours: 3)),
          background: Colors.red,
          isAllDay: true,
        ),
      );
    } else if (roomIndex == 1) {
      meetings.add(
        Meeting(
          eventName: 'Project Deadline',
          from: DateTime.now().add(const Duration(days: 1)),
          to: DateTime.now().add(const Duration(days: 1, hours: 3)),
          background: Colors.green,
          isAllDay: true,
        ),
      );
      meetings.add(
        Meeting(
          eventName: 'Client Visit',
          from: DateTime.now().add(const Duration(days: 5)),
          to: DateTime.now().add(const Duration(days: 5, hours: 2)),
          background: Colors.orange,
          isAllDay: false,
        ),
      );
    }
    return MeetingDataSource(meetings);
  }
}

// Model data kalender
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

// DataSource untuk Syncfusion Calendar
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].from;

  @override
  DateTime getEndTime(int index) => appointments![index].to;

  @override
  String getSubject(int index) => appointments![index].eventName;

  @override
  Color getColor(int index) => appointments![index].background;

  @override
  bool isAllDay(int index) => appointments![index].isAllDay;
}
