import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';

class GroupContenido extends StatelessWidget {
  final String textoTitulo;
  final String textoHint;
  final String textoButton;
  final String? textoInfo;
  const GroupContenido({
    super.key,
    required this.textoTitulo,
    required this.textoHint,
    required this.textoButton,
    this.textoInfo,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController nomController = TextEditingController();
    final chatProvider = BlocProvider.of<RoomBloc>(context, listen: false);
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            child: Text(textoTitulo,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                ))),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: TextField(
            cursorColor: Colors.black,
            decoration: InputDecoration(
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6165FA)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6165FA)),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6165FA)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6165FA)),
              ),
              hintText: textoHint,
              labelStyle: const TextStyle(color: Color(0x99999999)),
              hintStyle: const TextStyle(color: Color(0x99999999)),
              focusColor: const Color(0xFF6165FA),
              contentPadding: const EdgeInsets.all(10),
            ),
            controller: nomController,
          ),
        ),
        const SizedBox(height: 10),
        textoInfo != null
            ? Container(
                alignment: Alignment.centerLeft,
                child: Text(textoInfo!,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 112, 109, 109),
                      fontSize: 12,
                    )))
            : Container(),
        MaterialButton(
          minWidth: double.infinity,
          color: const Color(0xffF3F3F3),
          onPressed: () {
            if (textoButton == 'Crear Grupo') {
              chatProvider.add(SalaCreateEvent(nomController.text));
            } else {
              chatProvider.add(SalaJoinEvent(nomController.text));
            }
            Navigator.pop(context);
          },
          child: Text(textoButton,
              style: const TextStyle(color: Color(0xFF6165FA), fontSize: 14)),
        ),
      ],
    );
  }
}
