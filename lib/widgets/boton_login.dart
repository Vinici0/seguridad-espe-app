import 'package:flutter/material.dart';

class BotonForm extends StatelessWidget {
  final String text;
  final Function onPressed;

  const BotonForm({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MaterialButton(
        onPressed: () => this.onPressed(),
        elevation: 2,
        highlightElevation: 5,
        color: Colors.indigo,
        shape: const StadiumBorder(),
        minWidth: double.infinity,
        height: 50,
        child: Text(this.text,
            style: const TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }
}
