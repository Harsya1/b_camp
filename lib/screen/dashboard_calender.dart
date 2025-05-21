import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:supercharged/supercharged.dart';
import 'package:b_camp/screen/routes/app_drawer.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

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
      drawer: const AppDrawer(),
      body: Row(
        children: [
          _buildRoomList(),
          Expanded(child: _contentCalendar(selectedRoomIndex)),
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
                monthCellBuilder: (
                  BuildContext context,
                  MonthCellDetails details,
                ) {
                  final bool iscurrentMonth =
                      details.date.month == details.visibleDates[10].month;
                  return Center(
                    child: Text(
                      details.date.day.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            iscurrentMonth
                                ? FontWeight.bold
                                : FontWeight.normal,
                        color: iscurrentMonth ? Colors.black : Colors.grey[400],
                      ),
                    ),
                  );
                },
                onTap: (calendarTapDetails) async {
                  final DateTime? selected = await showMonthPicker(
                    context: context,
                    initialDate:
                        _calendarController.displayDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(3000),
                    monthPickerDialogSettings: MonthPickerDialogSettings(
                      headerSettings: PickerHeaderSettings(
                        headerBackgroundColor: const Color(0xFFFFCA07),
                        headerCurrentPageTextStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                  if (selected != null) {
                    setState(() {
                      _calendarController.displayDate = selected;
                    });
                  }
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
