import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/widgets/group_contenido.dart';

class CodigoCreateGrupoScreen extends StatelessWidget {
  static final String codigoGruporoute = 'codigoGrupo';

  const CodigoCreateGrupoScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Crear Grupo',
            //alinea a la izquierda
            style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
          //alineacion de los elementos a la izquierda

          child: GroupContenido(
            textoHint: 'Nombre del grupo',
            textoButton: 'Crear Grupo',
            textoTitulo: 'Nombre',
          ),
        ),
      ),
    );
  }
}
