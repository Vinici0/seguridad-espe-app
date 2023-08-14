import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  static const routeName = 'image-view';
  const ImageViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('ImageViewScreen'),
      ),
    );
  }
}
