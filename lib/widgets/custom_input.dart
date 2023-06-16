import 'package:flutter/material.dart';

class CustonInput extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;

  const CustonInput({
    Key? key,
    required this.icon,
    required this.placeholder,
    required this.textController,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  //offset: para mover la sobra
                  offset: Offset(0, 5),
                  blurRadius: 5)
            ]),
        child: TextField(
          controller: this.textController,
          autocorrect: false,
          obscureText: this.isPassword,
          keyboardType: this.keyboardType,
          decoration: InputDecoration(
              prefixIcon: Icon(this.icon, color: Colors.indigo),
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Colors.indigo)),
              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Colors.indigo)),
              hintText: this.placeholder),
        ),
      ),
    ]);
  }
}
