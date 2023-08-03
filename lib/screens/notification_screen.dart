import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  static const routeName = 'notifications_screen';
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title: const Text(
          'Tendencias',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        elevation: 0.5,
      ),
      body: const Center(
        child: Text('NotificationsScreen'),
      ),
    );
  }
}
