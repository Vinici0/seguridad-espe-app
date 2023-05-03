import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/prueba/prueba_bloc.dart';
import 'package:flutter_maps_adv/screens/prueba/prueba2.dart';

class PruebaScreen extends StatelessWidget {
  static const String routemap = 'prueba';
  const PruebaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, PruebaScreen2.routemap);
          },
        ),
        Center(
          child: BlocBuilder<PruebaBloc, PruebaState>(
            builder: (context, state) {
              return Center(
                child: Text('PruebaScreen1 ${state.usuario?.nombre ?? 'null'}'),
              );
            },
          ),
        )
      ]),
    );
  }
}
