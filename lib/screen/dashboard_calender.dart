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
  bool isLoadingKamar = false;

  // Remove cache completely for fresh data always

  // Add unique key for Select2dot1 to force rebuild
  int _selectKey = 0;

  @override
  void initState() {
    super.initState();
    _loadCampData();
  }

  // Keep existing _loadCampData method
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

  // COMPLETE RESET when loading new kamar list
  Future<void> _loadKamarList(String value) async {
    print('\n=== COMPLETE RESET - Load Kamar List for: $value ===');
    print('Previous selectedValue: $selectedValue');
    
    try {
      final parts = value.split('-');
      if (parts.length != 2) return;

      final campId = int.parse(parts[0]);
      final type = parts[1];

      // COMPLETE STATE RESET
      setState(() {
        isLoadingKamar = true;
        selectedTypeKamar = [];
        selectedRoomIndex = 0;
        selectedValue = null; // Reset to null first
        _selectKey++; // Force Select2dot1 rebuild
      });

      print('State completely reset, loading fresh data...');

      // Load fresh data from API - NO CACHE
      final kamarList = await ItemBookingController.getRoomsForType(campId, type);
      print('Fresh data loaded: ${kamarList.length} kamar for type $type');

      if (mounted) {
        setState(() {
          selectedTypeKamar = kamarList;
          selectedValue = value; // Set new value after load
          selectedRoomIndex = 0;
          isLoadingKamar = false;
        });
        print('State updated with NEW data: ${kamarList.length} kamar');
        print('New selectedValue: $selectedValue');
      }
    } catch (e) {
      print('Error memuat daftar kamar: $e');
      if (mounted) {
        setState(() {
          selectedTypeKamar = [];
          selectedRoomIndex = 0;
          selectedValue = null;
          isLoadingKamar = false;
        });
      }
    }
  }

  // Complete refresh method
  void _completeRefresh() {
    print('=== COMPLETE REFRESH TRIGGERED ===');
    setState(() {
      selectedValue = null;
      selectedTypeKamar = [];
      selectedRoomIndex = 0;
      isLoadingKamar = false;
      _selectKey++; // Force Select2dot1 rebuild
    });
  }

  // Simple room selection without cache
  void _selectRoom(int index) {
    print('Selecting room index: $index');
    setState(() {
      selectedRoomIndex = index;
    });
  }

  Widget _buildRoomList() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      color: Colors.grey[100],
      child: isLoadingKamar
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Loading rooms...'),
                ],
              ),
            )
          : selectedTypeKamar.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon kamar dihapus
                      Text(
                        'Pilih tipe kamar',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: selectedTypeKamar.length,
                  itemBuilder: (context, index) {
                    final kamar = selectedTypeKamar[index];
                    return GestureDetector(
                      onTap: () => _selectRoom(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selectedRoomIndex == index
                              ? const Color(0xFFFFCA07)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedRoomIndex == index 
                                ? Colors.orange 
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              kamar['nama_kamar'] ?? 'Kamar ${index + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: selectedRoomIndex == index 
                                    ? Colors.black 
                                    : Colors.grey.shade700,
                              ),
                              textAlign: TextAlign.center,
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
          // Force rebuild Select2dot1 with unique key
          KeyedSubtree(
            key: ValueKey('select_$_selectKey'),
            child: SizedBox(
              width: 300,
              child: (() {
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
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return Select2dot1(
                  selectDataController: SelectDataController(
                    data: filteredOptions,
                    isMultiSelect: false,
                  ),
                  onChanged: (selectedItems) async {
                    print('\n=== Select2dot1 onChanged TRIGGERED ===');
                    print('Selected items: ${selectedItems.length}');
                    
                    if (selectedItems.isNotEmpty &&
                        selectedItems.first.value != null &&
                        selectedItems.first.value!.isNotEmpty) {
                      final newValue = selectedItems.first.value!;
                      
                      print('NEW VALUE: $newValue');
                      print('CURRENT selectedValue: $selectedValue');
                      
                      // ALWAYS load if different OR if no current data
                      if (newValue != selectedValue || selectedTypeKamar.isEmpty) {
                        print('LOADING NEW DATA - Complete reset');
                        await _loadKamarList(newValue);
                      } else {
                        print('Same value, skipping load');
                      }
                    } else {
                      print('No valid selection');
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
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  if (isLoadingKamar)
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading room data...'),
                        ],
                      ),
                    )
                  else if (selectedTypeKamar.isEmpty)
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_month, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Pilih tipe camp untuk melihat kalender',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  else
                    // Force rebuild calendar with unique key - NO CACHE
                    KeyedSubtree(
                      key: ValueKey('calendar_${selectedValue}_${selectedRoomIndex}_${DateTime.now().millisecondsSinceEpoch}'),
                      child: FutureBuilder<MeetingDataSource>(
                        future: _getCalendarDataSource(roomIndex),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Loading calendar...'),
                                ],
                              ),
                            );
                          }
                          
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error, size: 64, color: Colors.red),
                                  const SizedBox(height: 16),
                                  Text('Error: ${snapshot.error}'),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => _completeRefresh(),
                                    child: const Text('Reset'),
                                  ),
                                ],
                              ),
                            );
                          }

                          return SfCalendar(
                            controller: _calendarController,
                            view: CalendarView.month,
                            headerHeight: 50,
                            firstDayOfWeek: 1,
                            dataSource: snapshot.data ?? MeetingDataSource([]),
                            monthViewSettings: const MonthViewSettings(
                              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
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
                            monthCellBuilder: (BuildContext context, MonthCellDetails details) {
                              final bool iscurrentMonth = details.date.month == details.visibleDates[10].month;
                              final bool isToday = DateUtils.isSameDay(details.date, DateTime.now());
                              return Center(
                                child: Container(
                                  decoration: isToday
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
                                      fontWeight: iscurrentMonth ? FontWeight.bold : FontWeight.normal,
                                      color: isToday
                                          ? Colors.orange
                                          : (iscurrentMonth ? Colors.black : Colors.grey[400]),
                                    ),
                                  ),
                                ),
                              );
                            },
                            onTap: (calendarTapDetails) {},
                          );
                        },
                      ),
                    ),
                  
                  // Month picker overlay
                  if (!isLoadingKamar && selectedTypeKamar.isNotEmpty)
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
                            initialDate: _calendarController.displayDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(3000),
                            monthPickerDialogSettings: MonthPickerDialogSettings(
                              headerSettings: PickerHeaderSettings(
                                headerBackgroundColor: const Color(0xFFFFCA07),
                                headerCurrentPageTextStyle: const TextStyle(color: Colors.black),
                              ),
                              dateButtonsSettings: PickerDateButtonsSettings(
                                selectedMonthBackgroundColor: const Color(0xFFFFCA07),
                                unselectedMonthsTextColor: Colors.black,
                              ),
                              actionBarSettings: PickerActionBarSettings(
                                confirmWidget: const Text('Pilih', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                cancelWidget: const Text('Batal', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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

  // NO CACHE - Always fresh data
  Future<MeetingDataSource> _getCalendarDataSource(int roomIndex) async {
    if (selectedTypeKamar.isEmpty || roomIndex >= selectedTypeKamar.length) {
      print('No room selected or index out of bounds');
      return MeetingDataSource([]);
    }

    final selectedKamar = selectedTypeKamar[roomIndex];
    final kamarId = selectedKamar['id'];

    print('=== FRESH CALENDAR DATA REQUEST ===');
    print('Kamar ID: $kamarId');
    print('Kamar Name: ${selectedKamar['nama_kamar']}');
    print('Selected Value: $selectedValue');

    try {
      // ALWAYS fetch fresh data - NO CACHE
      final bookings = await ItemBookingController.getBookingsForCalendar(kamarId);
      print('Fresh bookings loaded: ${bookings.length} for kamar $kamarId');
      
      final events = bookings.map((booking) {
        print('Booking: ${booking['nama']} - ${booking['start_date']} to ${booking['end_date']}');
        return StayDuration(
          eventName: booking['nama'] ?? 'No Name',
          from: DateTime.parse(booking['start_date']),
          to: DateTime.parse(booking['end_date']),
          background: Colors.blue,
          isAllDay: false,
        );
      }).toList();

      print('Created ${events.length} calendar events');
      return MeetingDataSource(events);
    } catch (e) {
      print('Error loading fresh calendar data: $e');
      return MeetingDataSource([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              print('=== MANUAL COMPLETE REFRESH ===');
              _completeRefresh();
            },
            tooltip: 'Complete Refresh',
          ),
        ],
      ),
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

// Keep existing models unchanged
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
