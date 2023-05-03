import 'package:flutter/material.dart';

class CodigoGrupoScreen extends StatelessWidget {
  static final String codigoGruporoute = 'codigoGrupo';
  const CodigoGrupoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Grupo',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
          //alineacion de los elementos a la izquierda

          child: Column(
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  child: const Text('Nombre',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ))),
              SizedBox(height: 10),
              Container(
                height: 40,
                child: const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre',
                  ),
                ),
              ),
              SizedBox(height: 10),
              // //Boton de crear grupo
              MaterialButton(
                //todo el ancho del contenedor
                minWidth: double.infinity,
                color: Colors.blue,
                onPressed: () {
                  print('crear grupo');
                },
                child: Text('Crear Grupo',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
