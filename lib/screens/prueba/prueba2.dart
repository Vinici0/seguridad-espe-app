import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/prueba/prueba_bloc.dart';
import 'package:flutter_maps_adv/models/usuario2.dart';
import 'package:flutter_maps_adv/screens/prueba/prueba.dart';

class PruebaScreen2 extends StatelessWidget {
  static const String routemap = 'prueba2';
  const PruebaScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PruebaBloc>(context).add(ActivarUsuario(
        Usuario2(nombre: 'Vinicio', edad: 35, profesiones: ["adawd"])));
    return Scaffold(
      body: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, PruebaScreen.routemap);
            },
          ),
          Center(
            child: BlocBuilder<PruebaBloc, PruebaState>(
              builder: (context, state) {
                return Center(
                  child:
                      Text('PruebaScreen2 ${state.usuario?.nombre ?? 'null'}'),
                );
              },
            ),
          )
        ],
      ),
      //agrega un boton color azul
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.accessibility_new),
        onPressed: () {
          // ignore: use_build_context_synchronously
        },
      ),
    );
  }
}
