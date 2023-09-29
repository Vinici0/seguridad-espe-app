import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        color: const Color(0xFF7ab466),
        shape: const StadiumBorder(),
        minWidth: double.infinity,
        height: 50,
        child: text == "Google"
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.google,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(text,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                ],
              )
            : Text(text,
                style: const TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }
}
