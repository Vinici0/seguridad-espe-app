import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Logo extends StatelessWidget {
  final String text;
  const Logo({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: 240,
            height: 240,
            child: SvgPicture.asset(
              'assets/iconvinculacion/login.svg',
            )),
      ],
    );
  }
}
