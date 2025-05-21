import 'package:flutter/material.dart';
import '../dashboard_calender.dart' as calender;
import '../dashboard_camp.dart' as campt;
import '../booking_section/input_data.dart';
import '../camp_section/create_camp.dart' as create;
import '../camp_section/edit_camp.dart' as editCamp;
import '../login_register_section/login_action.dart' as loginAction;
import '../login_register_section/register_action.dart' as registerAction;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/dashboard_calender':
        return MaterialPageRoute(
          builder: (context) => const calender.DashboardCalender(),
        );
      case '/dashboard_camp':
        return MaterialPageRoute(
          builder: (context) => const campt.DashboardCamp(),
        );
      case '/register':
        return MaterialPageRoute(
          builder: (context) => const registerAction.register_section(),
        );
      case '/input_data':
        return MaterialPageRoute(builder: (context) => CampVipPage());
      case '/create_camp':
        return MaterialPageRoute(
          builder: (context) => const create.CreateCamp(),
        );
      case '/edit_camp':
        return MaterialPageRoute(
          builder: (context) => const editCamp.EditCamp(),
        );
      case '/login':
        return MaterialPageRoute(
          builder:
              (context) => loginAction.LoginPage(
                onLogin: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/dashboard_calender',
                  );
                },
              ),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(title: const Text("Error")),
          body: const Center(child: Text('Error page')),
        );
      },
    );
  }
}
