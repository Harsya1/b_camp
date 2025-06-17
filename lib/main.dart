import 'package:flutter/material.dart';
import 'screen/routes/routes.dart';
import 'package:b_camp/service/auth/session_manager.dart';
import 'package:b_camp/screen/dashboard_calender.dart';
import 'package:b_camp/screen/login_register_section/login_action.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'B-Camp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/', // Set initial route
      onGenerateRoute: RouteGenerator.generateRoute,
      home: FutureBuilder<bool>(
        future: SessionManager.isSessionValid(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data == true) {
            return const DashboardCalendar();
          }

          return LoginPage(
            onLogin: () {
              Navigator.of(context).pushReplacementNamed('/dashboard_calender');
            },
          );
        },
      ),
    );
  }
}
