import 'package:flutter/material.dart';
import '../dashboard_calender.dart' as calender; // Alias untuk dashboard_calender.dart
import '../dashboard_camp.dart' as campt; // Alias untuk dashboard_camp.dart

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/dashboard_calender':
        return MaterialPageRoute(builder: (_) => const calender.DashboardCalender());
      case '/dashboard_camp':
        return MaterialPageRoute(builder: (_) => const campt.DashboardCamp());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("Error")),
          body: const Center(child: Text('Error page')),
        );
      },
    );
  }
}