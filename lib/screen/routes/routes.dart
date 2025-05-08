import 'package:flutter/material.dart';
import '../dashboard_calender.dart';
import '../dashboard_camp.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Jika ingin mengirim argument
    // final args = settings.arguments;
    switch (settings.name) {
      case '/dashboard_calender':
        return MaterialPageRoute(builder: (_) => const DashboardCalender());
      case '/dashboard_camp':
        return MaterialPageRoute(builder: (_) => const DashboardCamp());
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
