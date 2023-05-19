import 'package:flutter/material.dart';

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lugares', style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Text('PlacesScreen'),
      ),
    );
  }
}
