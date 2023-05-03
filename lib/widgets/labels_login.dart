import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String text;
  final String text2;

  const Labels(
      {Key? key, required this.ruta, required this.text, required this.text2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text, style: TextStyle(color: Colors.black54)),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, ruta);
          },
          child:
              Text(text2, style: TextStyle(color: Colors.indigo, fontSize: 18)),
        ),
      ],
    );
  }
}
