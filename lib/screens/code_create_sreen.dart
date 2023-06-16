import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/widgets/group_contenido.dart';

class CodigoCreateGrupoScreen extends StatelessWidget {
  static const String codigoGruporoute = 'codigoGrupo';

  const CodigoCreateGrupoScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text('Crear Grupo',
            //alinea a la izquierda
            style: TextStyle(color: Colors.black87, fontSize: 20)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
              //alineacion de los elementos a la izquierda
              color: Colors.white,
              child: const GroupContenido(
                textoHint: 'Nombre del grupo',
                textoButton: 'Crear Grupo',
                textoTitulo: 'Nombre',
              ),
            ),
          )
        ],
      ),
    );
  }
}
