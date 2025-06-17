class NotificationItem {
  final int id;
  final String name;
  final String gender;
  final String campName;
  final String kamarName;
  final DateTime checkOut;
  final bool isCompleted;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.name,
    required this.gender,
    required this.campName,
    required this.kamarName,
    required this.checkOut,
    required this.isCompleted,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'gender': gender,
    'campName': campName,
    'kamarName': kamarName,
    'checkOut': checkOut.toIso8601String(),
    'isCompleted': isCompleted,
    'createdAt': createdAt.toIso8601String(),
  };

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      campName: json['campName'],
      kamarName: json['kamarName'],
      checkOut: DateTime.parse(json['checkOut']),
      isCompleted: json['isCompleted'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
