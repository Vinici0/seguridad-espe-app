import 'package:flutter/material.dart';

class PruductScreen extends StatelessWidget {
  static const String routeName = 'product';
  const PruductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments ?? 'No data';
    return Scaffold(
      body: Center(
        child: Text('$args', style: TextStyle(fontSize: 30)),
      ),
    );
  }
}
