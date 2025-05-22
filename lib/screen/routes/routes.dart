import 'package:flutter/material.dart';

import '../dashboard_calender.dart' as calender;
import '../dashboard_camp.dart' as campt;
import '../booking_section/input_data.dart' as inputdata;
import '../camp_section/create_camp.dart' as create;
import '../booking_section/placeholder_booking.dart' as booking;
import '../camp_section/placeholder_camp.dart' as placecamp;
import '../camp_section/edit_camp.dart' as editCamp;
import '../camp_section/edit_kamar.dart' as editKamar;
import '../camp_section/list_kamar.dart' as listKamar;
import '../camp_section/create_kamar.dart' as createKamar;
import '../camp_section/detail_kamar.dart' as detailKamar;
import '../camp_section/crud_camp.dart' as crudCamp;
import '../login_register_section/login_action.dart' as loginAction;

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
      case '/input_data':
        return MaterialPageRoute(
          builder: (context) => const inputdata.InputData(),
        );
      case '/create_camp':
        return MaterialPageRoute(
          builder: (context) => const create.CreateCamp(),
        );
      case '/create_kamar':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || args['camp_id'] == null) {
          throw Exception('Camp ID is required');
        }
        return MaterialPageRoute(
          builder: (context) => createKamar.CreateKamar(
            campId: args['camp_id'],
          ),
        );
      case '/placeholder_camp':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || args['id'] == null) {
          throw Exception('Camp ID is required');
        }
        return MaterialPageRoute(
          builder: (context) => placecamp.PlaceholderCamp(
            campId: args['id'],
          ),
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
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || args['camp_id'] == null || args['type'] == null) {
          throw Exception('Camp ID and type are required');
        }
        return MaterialPageRoute(
          builder: (context) => listKamar.ListKamar(
            campId: args['camp_id'],
            type: args['type'],
          ),
        );

      //ROUTE untuk EDIT DATA
      case '/edit_kamar':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || args['kamar_data'] == null || args['camp_id'] == null) {
          throw Exception('Kamar data and camp ID are required');
        }
        return MaterialPageRoute(
          builder: (context) => editKamar.EditKamar(
            kamarData: args['kamar_data'],
            campId: args['camp_id'],
          ),
        );
      case '/edit_camp':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null) {
          throw Exception('Camp data is required');
        }
        return MaterialPageRoute(
          builder: (context) => editCamp.EditCamp(
            campData: args,
          ),
        );
      case '/detail_kamar':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || args['kamar_id'] == null) {
          throw Exception('Kamar ID is required');
        }
        return MaterialPageRoute(
          builder: (context) => detailKamar.DetailKamar(
            kamarId: args['kamar_id'],
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
