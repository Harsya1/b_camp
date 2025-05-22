import 'package:flutter/material.dart';
import '../dashboard_calender.dart' as calender;
import '../dashboard_camp.dart' as campt;
import '../booking_section/input_data.dart' as inputdata;
import '../camp_section/create_camp.dart' as create;
import '../booking_section/placeholder_booking.dart' as booking;
import '../camp_section/placeholder_camp.dart' as placecamp;
import '../camp_section/list_kamar.dart' as listKamar;
import '../camp_section/create_kamar.dart' as createKamar;
import '../camp_section/crud_camp.dart' as crudCamp;
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
      case '/booking_section':
        return MaterialPageRoute(
          builder: (context) => const booking.BookingSection(),
        );
      case '/register':
        return MaterialPageRoute(
          builder: (context) => const registerAction.register_section(),
        );
      case '/input_data':
        return MaterialPageRoute(
          builder: (context) => const inputdata.InputData(),
        );
      case '/create_camp':
        return MaterialPageRoute(
          builder: (context) => const create.CreateCamp(),
        );
      case '/create_kamar':
        return MaterialPageRoute(
          builder: (context) => const createKamar.CreateKamar(),
        );
      case '/placeholder_camp':
        return MaterialPageRoute(
          builder: (context) => const placecamp.PlaceholderCamp(),
        );
      case '/crud_camp':
        return MaterialPageRoute(
          builder: (context) => const crudCamp.CrudCamp(),
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
      case '/list_kamar':
        return MaterialPageRoute(
          builder: (context) => const listKamar.ListKamar(),
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
