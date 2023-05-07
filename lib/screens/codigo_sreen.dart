import 'package:flutter/material.dart';

class CodigoGrupoScreen extends StatelessWidget {
  static final String codigoGruporoute = 'codigoGrupo';
  const CodigoGrupoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Grupo',
            style: TextStyle(color: Color(0xfff833AB4), fontSize: 20)),
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
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xfff833AB4)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xfff833AB4)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xfff833AB4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xfff833AB4)),
                    ),
                    hintText: 'Nombre del grupo',
                    //color del texto plomo suave - #999
                    labelStyle: TextStyle(color: Color(0x99999999)),
                    hintStyle: TextStyle(color: Color(0x99999999)),
                    //color del de palpitacion del texto
                    focusColor: Color(0xfff833AB4),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // //Boton de crear grupo
              MaterialButton(
                //todo el ancho del contenedor
                minWidth: double.infinity,
                color: Color(0xffF3F3F3),
                onPressed: () {
                  print('crear grupo');
                },
                child: Text('Crear Grupo',
                    style: TextStyle(color: Color(0xfff833AB4), fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
