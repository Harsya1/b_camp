import 'package:flutter/material.dart';

class CampDetail extends StatefulWidget {
  const CampDetail({super.key});

  @override
  State<CampDetail> createState() => _CampDetail();
}

class _CampDetail extends State<CampDetail> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Camp Detail Screen'),
      ),
    );
  }
}
