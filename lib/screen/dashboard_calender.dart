import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:select2dot1/select2dot1.dart';
import 'package:b_camp/screen/routes/app_drawer.dart';
import 'package:b_camp/service/database/controller/itemBookingController.dart';

class DashboardCalendar extends StatefulWidget {
  const DashboardCalendar({super.key});

  @override
  State<DashboardCalendar> createState() => _DashboardCalendarState();
}

class _DashboardCalendarState extends State<DashboardCalendar> {
  int selectedRoomIndex = 0;
  final CalendarController _calendarController = CalendarController();
  List<SingleCategoryModel> campOptions = [];
  List<Map<String, dynamic>> selectedTypeKamar = [];
  String? selectedValue;
  bool isLoading = true;

  // Add cache map for calendar data
  final Map<int, MeetingDataSource> _calendarDataCache = {};

  @override
  void initState() {
    super.initState();
    _loadCampData();
  }

  // Add method to load camp data
  Future<void> _loadCampData() async {
    try {
      print('\n=== Memulai Memuat Data Camp ===');
      final types = await ItemBookingController.getAllCampTypesForCalendar();
      print('Jenis camp dimuat: ${types.length}');

      List<SingleCategoryModel> options = [];
      for (var campData in types) {
        final campId = campData['camp_id'];
        final campName = campData['camp_name'];
        final typesList = List<dynamic>.from(campData['types']);

        print('Memproses camp: $campName dengan ${typesList.length} tipe');

        if (typesList.isNotEmpty) {
          options.add(
            SingleCategoryModel(
              nameCategory: campName,
              singleItemCategoryList: typesList.map((type) => 
                SingleItemCategoryModel(
                  nameSingleItem: type,
                  value: '$campId-$type',
                )
              ).toList(),
            ),
          );
        }
      }

      if (mounted) {
        setState(() {
          campOptions = options;
          isLoading = false;
        });
      }
      print('Dimuat ${options.length} camp dengan tipe');
    } catch (e) {
      print('Error memuat data camp: $e');
      if (mounted) {
        setState(() {
          campOptions = [];
          isLoading = false;
        });
      }
    }
  }

  // Update _buildRoomList to use selectedTypeKamar
  Widget _buildRoomList() {
    print('Membangun daftar kamar, panjang selectedTypeKamar: ${selectedTypeKamar.length}');
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      color: Colors.grey[100],
      child: selectedTypeKamar.isEmpty
          ? const Center(
              child: Text(
                'Pilih tipe kamar',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: selectedTypeKamar.length,
              itemBuilder: (context, index) {
                final kamar = selectedTypeKamar[index];
                return GestureDetector(
                  onTap: () => setState(() => selectedRoomIndex = index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selectedRoomIndex == index
                          ? const Color(0xFFFFCA07)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        const SizedBox(height: 4),
                        Text(
                          kamar['nama_kamar'] ?? '${index + 1}',
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

  // Update _contentCalendar to handle loading state
  Widget _contentCalendar(int roomIndex) {
    print('Membangun konten kalender untuk roomIndex: $roomIndex');
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Select2dot1 sesuai contoh website
          SizedBox(
            width: 300,
            child: (() {
              // Filter hanya kategori yang punya item
              final filteredOptions = campOptions
                  .where((cat) => cat.singleItemCategoryList.isNotEmpty)
                  .toList();

              if (filteredOptions.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: const Text(
                    'Tidak ada data camp tersedia',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return Select2dot1(
                selectDataController: SelectDataController(
                  data: filteredOptions,
                  isMultiSelect: false,
                ),
                onChanged: (selectedItems) async {
                  if (selectedItems.isNotEmpty &&
                      selectedItems.first.value != null &&
                      selectedItems.first.value!.isNotEmpty) {
                    final selectedItem = selectedItems.first;
                    if (selectedItem.value != selectedValue) {
                      await _loadKamarList(selectedItem.value!);
                    }
                  }
                },
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
              );
            })(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  FutureBuilder<MeetingDataSource>(
                    future: _getCalendarDataSource(roomIndex),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (snapshot.hasError) {
                        print('Calendar Error: ${snapshot.error}');
                        return const Center(child: Text('Error loading calendar data'));
                      }

                      return SfCalendar(
                        controller: _calendarController,
                        view: CalendarView.month,
                        headerHeight: 50,
                        firstDayOfWeek: 1,
                        dataSource: snapshot.data ?? MeetingDataSource([]), // Add null check here
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
                      );
                    },
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

  // Add method to load kamar list
  Future<void> _loadKamarList(String value) async {
    // Add check to prevent reload if same value is selected
    if (value == selectedValue) return;

    try {
      print('\n=== Memuat Daftar Kamar untuk nilai: $value ===');
      final parts = value.split('-');
      if (parts.length != 2) return;

      final campId = int.parse(parts[0]);
      final type = parts[1];

      // Set selectedValue first to prevent reload
      setState(() {
        selectedValue = value;
        isLoading = true;
      });

      final kamarList = await ItemBookingController.getRoomsForType(campId, type);

      if (mounted) {
        setState(() {
          selectedTypeKamar = kamarList;
          selectedRoomIndex = 0;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error memuat daftar kamar: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Update _getCalendarDataSource to use real booking data
  Future<MeetingDataSource> _getCalendarDataSource(int roomIndex) async {
    if (selectedTypeKamar.isEmpty || roomIndex >= selectedTypeKamar.length) {
      print('Tidak ada kamar terpilih atau indeks di luar batas');
      return MeetingDataSource([]);
    }

    final selectedKamar = selectedTypeKamar[roomIndex];
    final kamarId = selectedKamar['id'];

    // Check cache first
    if (_calendarDataCache.containsKey(kamarId)) {
      return _calendarDataCache[kamarId]!;
    }

    try {
      final bookings = await ItemBookingController.getBookingsForCalendar(kamarId);
      print('Memproses ${bookings.length} booking untuk kalender');
      
      final events = bookings.map((booking) => StayDuration(
        eventName: booking['nama'] ?? 'No Name',
        from: DateTime.parse(booking['start_date']),
        to: DateTime.parse(booking['end_date']),
        background: Colors.blue,
        isAllDay: false,
      )).toList();

      final dataSource = MeetingDataSource(events);
      _calendarDataCache[kamarId] = dataSource;
      return dataSource;
    } catch (e) {
      print('Error memproses booking: $e');
      return MeetingDataSource([]);
    }
  }

  // Add this build method inside _DashboardCalendarState class
  @override
  Widget build(BuildContext context) {
    print('Membangun DashboardCalendar, isLoading: $isLoading');
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Calendar')),
      drawer: const AppDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                _buildRoomList(),
                Expanded(child: _contentCalendar(selectedRoomIndex)),
              ],
            ),
    );
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
