import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetalleScreen extends StatelessWidget {
  static const String detalleroute = 'detalle';
  const DetalleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.red,
            child: AspectRatio(
              aspectRatio: 16 / 5,
              child: SvgPicture.asset(
                'assets/accidente.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
