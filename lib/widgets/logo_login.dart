import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String text;
  const Logo({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
          const SizedBox(
              width: 180,
              child: Image(image: AssetImage('assets/logoespe.png'))),
          Text(this.text,
              style: const TextStyle(
                  color: Colors.indigo,
                  fontSize: 40,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
