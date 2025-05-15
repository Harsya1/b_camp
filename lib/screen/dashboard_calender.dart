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
  int selectedRoomIndex =
      0; // Indeks kamar yang dipilih, default ke kamar 1 (indeks 0)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Booking Calendar')),
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
      body: Row(
        children: [
          // ListView untuk daftar kamar
          Container(
            width:
                MediaQuery.of(context).size.width * 0.2, // 20% dari lebar layar
            color: Colors.grey[100], // Latar belakang abu-abu lebih gelap
            child: ListView.builder(
              itemCount: 2, // Jumlah kamar dikurangi menjadi 2
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRoomIndex = index; // Perbarui kamar yang dipilih
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          selectedRoomIndex == index
                              ? "FFCA07"
                                  .toColor() // Warna untuk kamar yang dipilih
                              : Colors
                                  .white, // Warna untuk kamar yang tidak dipilih
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'No. kamar', // Teks di atas nomor kamar
                          style: TextStyle(
                            fontSize: 8, // Ukuran font kecil
                            color: Colors.black, // Warna teks hitam
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ), // Jarak antara teks dan nomor kamar
                        Text(
                          '${index + 1}', // Nomor kamar
                          style: const TextStyle(
                            fontSize: 16, // Ukuran font untuk nomor kamar
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Warna teks hitam
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Kalender utama di sebelah kanan
          Expanded(
            child: _contentCalendar(
              selectedRoomIndex,
            ), // Kirim indeks kamar yang dipilih
          ),
        ],
      ),
    );
  }

  Widget _contentCalendar(int roomIndex) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kalender Booking - Kamar ${roomIndex + 1}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SfCalendar(
              view: CalendarView.month, // Tampilan kalender bulanan
              firstDayOfWeek: 1, // Mulai dari hari Senin
              dataSource: _getCalendarDataSource(
                roomIndex,
              ), // Data untuk kalender
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

  // Fungsi untuk mendapatkan data sumber kalender berdasarkan kamar
  MeetingDataSource _getCalendarDataSource(int roomIndex) {
    final List<Meeting> meetings = <Meeting>[];

    if (roomIndex == 0) {
      // Data untuk kamar 1
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
          eventName: 'Maintenance',
          from: DateTime.now().add(const Duration(days: 3)),
          to: DateTime.now().add(const Duration(days: 3, hours: 3)),
          background: Colors.red,
          isAllDay: true,
        ),
      );
    } else if (roomIndex == 1) {
      // Data untuk kamar 2
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
