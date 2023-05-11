import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/widgets/group_contenido.dart';

class CodigoAddGrupoScreen extends StatelessWidget {
  static final String codigoAddGruporoute = 'codigoGrupoAdd';

  final TextEditingController nomController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Unirse a un Grupo',
            //alinea a la izquierda
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
          //alineacion de los elementos a la izquierda
          child: GroupContenido(
              textoHint: 'AAA-AAA',
              textoButton: 'Unirme al Grupo',
              textoTitulo: 'Código',
              textoInfo:
                  'Ingresa el código del grupo que te compartieron para unirte al grupo que fuiste invitado.'),
        ),
      ),
    );
  }
}
