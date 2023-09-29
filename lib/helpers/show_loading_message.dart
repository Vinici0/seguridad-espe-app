import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoadingMessage(BuildContext context) {
  // Android
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Calculando ruta'),
        content: Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: const [
              Text(
                'Espere por favor...',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(0xFF7ab466),
              ),
            ],
          ),
        ),
      ),
    );
    return;
  }

  // iOS
  showCupertinoDialog(
    context: context,
    builder: (context) => const CupertinoAlertDialog(
      title: Text('Calculando ruta'),
      content: CupertinoActivityIndicator(),
    ),
  );
}
