import 'package:flutter/material.dart';

class InformationScreen extends StatelessWidget {
  static const String information = 'information';
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('InformationScreen'),
      ),
    );
  }
}
