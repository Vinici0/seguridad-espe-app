import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/widgets/group_contenido.dart';

class CodigoAddGrupoScreen extends StatelessWidget {
  static const String codigoAddGruporoute = 'codigoGrupoAdd';

  final TextEditingController nomController = TextEditingController();

  CodigoAddGrupoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        //color de la flecha de regreso
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 0.5,
        title: const Text('Únete a un grupo',
            //alinea a la izquierda
            style: TextStyle(color: Colors.black87, fontSize: 20)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
                  //alineacion de los elementos a la izquierda
                  child: const GroupContenido(
                      textoHint: '000-000',
                      textoButton: 'Únete a un grupo',
                      textoTitulo: 'Código',
                      textoInfo:
                          'Ingresa el código del grupo que te compartieron para unirte al grupo que fuiste invitado.'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
