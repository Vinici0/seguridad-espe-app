import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';

class EditNombreScreen extends StatefulWidget {
  static const String editNombreroute = 'editNombre';
  const EditNombreScreen({Key? key}) : super(key: key);

  @override
  State<EditNombreScreen> createState() => _EditNombreScreenState();
}

class _EditNombreScreenState extends State<EditNombreScreen> {
  AuthBloc authBloc = AuthBloc();
  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
    _textController.text = authBloc.state.usuario!.nombre;
  }

  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: false,
        title: const Text(
          'Cambiar Nombre',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          IconButton(
            onPressed: () {
              authBloc.updateUsuario(
                  _textController.text, authBloc.state.usuario!.telefono ?? '');
              Navigator.pop(context);
            },
            //icono de un visto
            icon: const Icon(
              Icons.check,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Nombres',
                labelStyle: TextStyle(
                  color: Color(0xFF6165FA), // Color del texto del label
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(
                        0xFF6165FA), // Color de la línea de abajo del TextField
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
