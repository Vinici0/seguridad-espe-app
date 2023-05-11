import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/resources/services/salas_provider.dart';

class DetalleSalaScreen extends StatelessWidget {
  static const String detalleSalaroute = 'detalleSala';
  const DetalleSalaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = BlocProvider.of<SalasProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Detalle',
            //alinea a la izquierda
            style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
      body: Center(
        child: Text(chatProvider.salaSeleccionada.nombre),
      ),
    );
  }
}
