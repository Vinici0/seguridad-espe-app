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
  bool _isEmpty = true; // Variable para controlar si el TextField está vacío

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
    _textController.text = authBloc.state.usuario!.nombre;

    _textController.addListener(() {
      setState(() {
        _isEmpty = _textController.text.isEmpty;
      });
    });
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
              if (_isEmpty) return;
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
              textCapitalization: TextCapitalization.sentences,
              controller: _textController,
              maxLength: 50,
              onChanged: (value) {
                setState(() {
                  _isEmpty = value.isEmpty;
                });
              },
              decoration: InputDecoration(
                labelText: 'Nombres',
                labelStyle: const TextStyle(
                  color: Color(0xFF7ab466),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: _isEmpty ? Colors.red : const Color(0xFF7ab466),
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
