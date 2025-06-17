import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:select2dot1/select2dot1.dart';
import 'package:b_camp/screen/routes/app_drawer.dart';
import 'package:b_camp/service/database/controller/itemBookingController.dart';
import 'package:badges/badges.dart' as badges;
import 'package:b_camp/service/auth/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/database/model/notification_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class DashboardCalendar extends StatefulWidget {
  const DashboardCalendar({Key? key}) : super(key: key);

  @override
  _DashboardCalendarState createState() => _DashboardCalendarState();
}

class _DashboardCalendarState extends State<DashboardCalendar> {
  int selectedRoomIndex = 0;
  final CalendarController _calendarController = CalendarController();
  List<SingleCategoryModel> campOptions = [];
  List<Map<String, dynamic>> selectedTypeKamar = [];
  String? selectedValue;
  bool isLoading = true;
  bool isLoadingKamar = false;
  Timer? _notificationTimer;
  Timer? _sessionCheckTimer; // Add this line

  // Remove cache completely for fresh data always

  // Add unique key for Select2dot1 to force rebuild
  int _selectKey = 0;

  // Add new field for dismissed notifications
  Set<int> dismissedNotificationIds = {};

  // Add FlutterLocalNotificationsPlugin instance
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    try {
      await _initializeNotifications();
      await _loadCampData();
      await _checkAndUpdateNotifications();
      _startNotificationCheck();
      _startSessionCheck();
    } catch (e) {
      print('Error initializing dashboard: $e');
    }
  }

  // Initialize notifications
  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
        _showNotifications(context);
      },
    );
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
              singleItemCategoryList:
                  typesList
                      .map(
                        (type) => SingleItemCategoryModel(
                          nameSingleItem: type,
                          value: '$campId-$type',
                        ),
                      )
                      .toList(),
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
      final kamarList = await ItemBookingController.getRoomsForType(
        campId,
        type,
      );
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
      child:
          isLoadingKamar
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
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            selectedRoomIndex == index
                                ? const Color(0xFFFFCA07)
                                : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              selectedRoomIndex == index
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
                              color:
                                  selectedRoomIndex == index
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
              child:
                  (() {
                    final filteredOptions =
                        campOptions
                            .where(
                              (cat) => cat.singleItemCategoryList.isNotEmpty,
                            )
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
                          if (newValue != selectedValue ||
                              selectedTypeKamar.isEmpty) {
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
                          Icon(
                            Icons.calendar_month,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Pilih tipe camp untuk melihat kalender',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    // Force rebuild calendar with unique key - NO CACHE
                    KeyedSubtree(
                      key: ValueKey(
                        'calendar_${selectedValue}_${selectedRoomIndex}_${DateTime.now().millisecondsSinceEpoch}',
                      ),
                      child: FutureBuilder<MeetingDataSource>(
                        future: _getCalendarDataSource(roomIndex),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                                  const Icon(
                                    Icons.error,
                                    size: 64,
                                    color: Colors.red,
                                  ),
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
                                  details.date.month ==
                                  details.visibleDates[10].month;
                              final bool isToday = DateUtils.isSameDay(
                                details.date,
                                DateTime.now(),
                              );
                              return Center(
                                child: Container(
                                  decoration:
                                      isToday
                                          ? BoxDecoration(
                                            color: Colors.orange.withOpacity(
                                              0.2,
                                            ),
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
                            initialDate:
                                _calendarController.displayDate ??
                                DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(3000),
                            monthPickerDialogSettings:
                                MonthPickerDialogSettings(
                                  headerSettings: PickerHeaderSettings(
                                    headerBackgroundColor: const Color(
                                      0xFFFFCA07,
                                    ),
                                    headerCurrentPageTextStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  dateButtonsSettings:
                                      PickerDateButtonsSettings(
                                        selectedMonthBackgroundColor:
                                            const Color(0xFFFFCA07),
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
      final bookings = await ItemBookingController.getBookingsForCalendar(
        kamarId,
      );
      print('Fresh bookings loaded: ${bookings.length} for kamar $kamarId');

      final events =
          bookings.map((booking) {
            print(
              'Booking: ${booking['nama']} - ${booking['start_date']} to ${booking['end_date']}',
            );
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

  List<NotificationItem> notifications = [];

  @override
  void dispose() {
    _notificationTimer?.cancel();
    _sessionCheckTimer?.cancel();
    super.dispose();
  }

  void _startNotificationCheck() {
    // Check for notifications every minute
    _notificationTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkAndUpdateNotifications();
    });
  }

  void _startSessionCheck() {
    _sessionCheckTimer?.cancel(); // Cancel existing timer if any
    _sessionCheckTimer = Timer.periodic(const Duration(minutes: 5), (
      timer,
    ) async {
      final isValid = await SessionManager.isSessionValid();
      if (!isValid && mounted) {
        timer.cancel();
        await SessionManager.clearSession();
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  // 1. Update _checkAndUpdateNotifications method
  Future<void> _checkAndUpdateNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Load dismissed IDs from storage
      dismissedNotificationIds = Set<int>.from(
        prefs.getStringList('dismissed_notifications')?.map(int.parse) ?? [],
      );

      final bookings = await ItemBookingController.getAllBookingsWithDetails();
      final now = DateTime.now();
      List<NotificationItem> newNotifications = [];

      for (var booking in bookings) {
        if (booking['end_date'] == null) continue;

        final id = int.parse(booking['id'].toString());
        // Skip if notification was dismissed
        if (dismissedNotificationIds.contains(id)) continue;

        final checkOut = DateTime.parse(booking['end_date']);
        final daysUntilCheckout = checkOut.difference(now).inDays;
        final isCompleted = checkOut.isBefore(now);

        // Auto remove old notifications after 7 days
        if (isCompleted &&
            checkOut.add(const Duration(days: 7)).isBefore(now)) {
          dismissedNotificationIds.add(id);
          continue;
        }

        if (daysUntilCheckout <= 2 ||
            (isCompleted &&
                checkOut.add(const Duration(days: 7)).isAfter(now))) {
          newNotifications.add(
            NotificationItem(
              id: id,
              name: booking['nama'] ?? 'Unknown',
              gender: booking['gender'] ?? 'Unknown',
              campName: booking['kamar']['camp']['nama_camp'] ?? 'Unknown Camp',
              kamarName: booking['kamar']['nama_kamar'] ?? 'Unknown Room',
              checkOut: checkOut,
              isCompleted: isCompleted,
              createdAt: now,
            ),
          );
        }
      }

      // Save dismissed IDs
      await prefs.setStringList(
        'dismissed_notifications',
        dismissedNotificationIds.map((id) => id.toString()).toList(),
      );

      // Show system notification for new items
      for (var notification in newNotifications) {
        if (!notification.isCompleted &&
            notification.checkOut.difference(now).inDays <= 2) {
          _showSystemNotification(
            notification.id,
            'Pengingat Check-out',
            '${notification.name} akan check-out dalam ${notification.checkOut.difference(now).inDays} hari',
          );
        } else if (notification.isCompleted) {
          _showSystemNotification(
            notification.id,
            'Status Inap',
            '${notification.name} telah selesai menginap',
          );
        }
      }

      if (mounted) {
        setState(() {
          notifications = newNotifications;
        });
        // Add this line to update badge
        await _updateAppBadge();
      }
    } catch (e) {
      print('Error in _checkAndUpdateNotifications: $e');
    }
  }

  // 2. Update _updateAppBadge method
  Future<void> _updateAppBadge() async {
    try {
      if (Platform.isIOS) {
        // Add platform check
        await flutterLocalNotificationsPlugin.initialize(
          InitializationSettings(
            iOS: DarwinInitializationSettings(defaultPresentBadge: true),
          ),
        );
      }
    } catch (e) {
      print('Error updating app badge: $e');
    }
  }

  // 3. Add import for Platform
  // import 'dart:io' show Platform;

  // Add method to show system notification
  Future<void> _showSystemNotification(
    int id,
    String title,
    String body,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'booking_notifications',
      'Booking Notifications',
      channelDescription: 'Notifications for booking status',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(id, title, body, details);
  }

  List<Widget> _buildActions() {
    return [
      IconButton(icon: const Icon(Icons.refresh), onPressed: _completeRefresh),
      const SizedBox(width: 10),
      badges.Badge(
        position: badges.BadgePosition.topEnd(top: 0, end: 3),
        showBadge: notifications.isNotEmpty,
        badgeContent: Text(
          notifications.length.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red),
        child: IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () => _showNotifications(context),
        ),
      ),
    ];
  }

  // Update _showNotifications method
  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setDialogState) {
              return NotificationDialog(
                notifications: notifications,
                onDismiss: (id) async {
                  // Add to dismissed set
                  dismissedNotificationIds.add(id);

                  // Save to storage
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setStringList(
                    'dismissed_notifications',
                    dismissedNotificationIds
                        .map((id) => id.toString())
                        .toList(),
                  );

                  setState(() {
                    notifications.removeWhere((item) => item.id == id);
                  });

                  setDialogState(() {});

                  if (notifications.isEmpty) {
                    Navigator.pop(context);
                  }
                },
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text('Dashboard Calendar'),
        backgroundColor: const Color(0xFFF2F2F2),
        actions: _buildActions(),
      ),
      drawer: const AppDrawer(),
      body: Row(
        children: [
          _buildRoomList(),
          Expanded(child: _contentCalendar(selectedRoomIndex)),
        ],
      ),
    );
  }
}

class NotificationDialog extends StatelessWidget {
  final List<NotificationItem> notifications;
  final Function(int) onDismiss;

  const NotificationDialog({
    Key? key,
    required this.notifications,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'Notifikasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child:
                  notifications.isEmpty
                      ? const Center(child: Text('Tidak ada notifikasi'))
                      : ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return NotificationListItem(
                            notification: notification,
                            onDismiss: onDismiss,
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationListItem extends StatelessWidget {
  final NotificationItem notification;
  final Function(int) onDismiss;

  const NotificationListItem({
    Key? key,
    required this.notification,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysLeft = notification.checkOut.difference(now).inDays;

    return Dismissible(
      key: Key('notification_${notification.id}'),
      onDismissed: (_) => onDismiss(notification.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${notification.name} (${notification.gender})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => onDismiss(notification.id),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Camp: ${notification.campName}'),
            Text('Kamar: ${notification.kamarName}'),
            const SizedBox(height: 4),
            if (!notification.isCompleted)
              Text(
                'Durasi inap sisa: $daysLeft hari',
                style: TextStyle(
                  color: daysLeft <= 2 ? Colors.red : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              )
            else
              const Text(
                'Status inap: Selesai',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
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
