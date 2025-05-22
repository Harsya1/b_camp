import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:select2dot1/select2dot1.dart';
import 'package:b_camp/screen/routes/app_drawer.dart';

class DashboardCalendar extends StatefulWidget {
  const DashboardCalendar({super.key});

  @override
  State<DashboardCalendar> createState() => _DashboardCalendarState();
}

class _DashboardCalendarState extends State<DashboardCalendar> {
  int selectedRoomIndex = 0;
  final CalendarController _calendarController = CalendarController();

  static const List<SingleCategoryModel> campOptions = [
    SingleCategoryModel(
      nameCategory: 'Camp Nomor 15',
      singleItemCategoryList: [
        SingleItemCategoryModel(nameSingleItem: "VVIP"),
        SingleItemCategoryModel(nameSingleItem: 'VIP'),
        SingleItemCategoryModel(nameSingleItem: 'Barrack'),
      ],
    ),
    SingleCategoryModel(
      nameCategory: 'Camp Nomor 16',
      singleItemCategoryList: [
        SingleItemCategoryModel(nameSingleItem: 'VIP'),
        SingleItemCategoryModel(nameSingleItem: 'Barrack'),
      ],
    ),
  ];

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
                        ? Color(0xFFFFCA07)
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

  Widget _contentCalendar(int roomIndex) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Select2dot1 sesuai contoh website
          SizedBox(
            width: 300,
            child: Select2dot1(
              selectDataController: SelectDataController(
                data: campOptions,
                isMultiSelect: true,
              ),
              pillboxTitleSettings: const PillboxTitleSettings(
                title: 'Pilih Tipe Camp',
                titleStyleDefault: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              pillboxSettings: PillboxSettings(
                defaultDecoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
              ),
              // Jika multi select:
              // pillboxContentMultiSettings: PillboxContentMultiSettings(
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.black, width: 1.5),
              //     borderRadius: BorderRadius.circular(8),
              //     color: Colors.white,
              //   ),
              // ),
              onChanged: (selectedItems) {
                if (selectedItems.isNotEmpty) {
                  final selectedItem = selectedItems.first;
                  print("Tipe Camp Terpilih: ${selectedItem.nameSingleItem}");
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  SfCalendar(
                    controller: _calendarController,
                    view: CalendarView.month,
                    headerHeight: 50,
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
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      backgroundColor: Color(0xFFFFCA07),
                    ),
                    headerDateFormat: 'MMMM yyyy',
                    monthCellBuilder: (
                      BuildContext context,
                      MonthCellDetails details,
                    ) {
                      final bool iscurrentMonth =
                          details.date.month == details.visibleDates[10].month;
                      final bool isToday = DateUtils.isSameDay(
                        details.date,
                        DateTime.now(),
                      );
                      return Center(
                        child: Container(
                          decoration:
                              isToday
                                  ? BoxDecoration(
                                    color: Colors.orange.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  )
                                  : null,
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            details.date.day.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  iscurrentMonth
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              color:
                                  isToday
                                      ? Colors.orange
                                      : (iscurrentMonth
                                          ? Colors.black
                                          : Colors.grey[400]),
                            ),
                          ),
                        ),
                      );
                    },
                    onTap: (calendarTapDetails) {},
                  ),
                  // Custom header overlay for month picker
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 50,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        final DateTime? selected = await showMonthPicker(
                          context: context,
                          initialDate:
                              _calendarController.displayDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(3000),
                          monthPickerDialogSettings: MonthPickerDialogSettings(
                            headerSettings: PickerHeaderSettings(
                              headerBackgroundColor: const Color(0xFFFFCA07),
                              headerCurrentPageTextStyle: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            dateButtonsSettings: PickerDateButtonsSettings(
                              selectedMonthBackgroundColor: const Color(
                                0xFFFFCA07,
                              ),
                              unselectedMonthsTextColor: Colors.black,
                            ),
                            actionBarSettings: PickerActionBarSettings(
                              confirmWidget: const Text(
                                'Pilih',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              cancelWidget: const Text(
                                'Batal',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
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
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        // child: Text(
                        //   // Tampilkan bulan dan tahun aktif
                        //   _calendarController.displayDate != null
                        //       ? "${_calendarController.displayDate!.month.toString().padLeft(2, '0')}-${_calendarController.displayDate!.year}"
                        //       : "${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}",
                        //   style: const TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.black,
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Data dummy kalender per kamar
  MeetingDataSource _getCalendarDataSource(int roomIndex) {
    final List<StayDuration> inap = [];
    if (roomIndex == 0) {
      inap.add(
        StayDuration(
          eventName: 'Yudo',
          from: DateTime.now().add(const Duration(days: 0)),
          to: DateTime.now().add(const Duration(days: 5)),
          background: Colors.blue,
          isAllDay: false,
        ),
      );
      inap.add(
        StayDuration(
          eventName: 'Anula',
          from: DateTime.now().add(const Duration(days: 3)),
          to: DateTime.now().add(const Duration(days: 3)),
          background: Colors.red,
          isAllDay: true,
        ),
      );
    } else if (roomIndex == 1) {
      inap.add(
        StayDuration(
          eventName: 'Baskara',
          from: DateTime.now().add(const Duration(days: 0)),
          to: DateTime.now().add(const Duration(days: 1)),
          background: Colors.green,
          isAllDay: true,
        ),
      );
      inap.add(
        StayDuration(
          eventName: 'Setya Mayang',
          from: DateTime.now().add(const Duration(days: 0)),
          to: DateTime.now().add(const Duration(days: 5)),
          background: Colors.orange,
          isAllDay: false,
        ),
      );
    }
    return MeetingDataSource(inap);
  }
}

// Model data kalender
class StayDuration {
  StayDuration({
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
  MeetingDataSource(List<StayDuration> source) {
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
