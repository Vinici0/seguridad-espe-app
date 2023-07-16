import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/helpers/mostrar_alerta.dart';

class EditTelefonoScreen extends StatefulWidget {
  static const String editTelefonoeroute = 'editTelefono';
  const EditTelefonoScreen({Key? key}) : super(key: key);

  @override
  State<EditTelefonoScreen> createState() => _EditNombreScreenState();
}

class _EditNombreScreenState extends State<EditTelefonoScreen> {
  bool isValido = false;
  AuthBloc authBloc = AuthBloc();
  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
    _textController.text = authBloc.state.usuario!.telefono ?? '';
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
          'Cambiar Teléfono',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final phoneNumber = _textController.text.trim();
              if (isValidPhoneNumber(phoneNumber)) {
                await authBloc.updateUsuario(
                  authBloc.state.usuario!.nombre,
                  phoneNumber,
                );
                Navigator.pop(context);
              } else {
                mostrarAlerta(
                  context,
                  'Teléfono incorrecto',
                  'El número de teléfono debe tener 10 dígitos y comenzar con "09"',
                );
              }
            },
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
              keyboardType: TextInputType.number,
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Telefono',
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

  bool isValidPhoneNumber(String phoneNumber) {
    if (phoneNumber.length != 10) {
      return false;
    }

    if (!phoneNumber.startsWith('09')) {
      return false;
    }

    for (int i = 2; i < phoneNumber.length; i++) {
      if (!RegExp(r'[0-9]').hasMatch(phoneNumber[i])) {
        return false;
      }
    }
    return true;
  }
}
