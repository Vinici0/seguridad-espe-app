import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/resources/services/salas_provider.dart';

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
    final chatProvider = BlocProvider.of<SalasProvider>(context, listen: false);
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
        Container(
          height: 40,
          child: TextField(
            cursorColor: Colors.black,
            decoration: InputDecoration(
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6165FA)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6165FA)),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6165FA)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6165FA)),
              ),
              hintText: textoHint,
              //color del texto plomo suave - #999
              labelStyle: TextStyle(color: Color(0x99999999)),
              hintStyle: TextStyle(color: Color(0x99999999)),
              //color del de palpitacion del texto
              focusColor: Color(0xFF6165FA),
              contentPadding: EdgeInsets.all(10),
            ),
            controller: nomController,
          ),
        ),
        SizedBox(height: 10),
        // //Boton de crear grupo
        textoInfo != null
            ? Container(
                alignment: Alignment.centerLeft,
                child: Text(textoInfo!,
                    style: TextStyle(
                      color: Color.fromARGB(255, 112, 109, 109),
                      fontSize: 12,
                    )))
            : Container(),
        MaterialButton(
          //todo el ancho del contenedor
          minWidth: double.infinity,
          color: Color(0xffF3F3F3),
          onPressed: () {
            if (nomController.text.isNotEmpty) {
              chatProvider.createSala(nomController.text);
              Navigator.pop(context);
            }
          },
          child: Text(textoButton,
              style: TextStyle(color: Color(0xFF6165FA), fontSize: 14)),
        ),
      ],
    );
  }
}
