import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void mostrarAlerta(BuildContext context, String titulo, String subtitulo) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(subtitulo),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFF6165FA)),
              ),
            ),
          ],
        );
      },
    );
  } else {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(titulo),
          content: Text(subtitulo),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
