import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/helpers/mostrar_alerta.dart';

class EditTelefonoScreen extends StatefulWidget {
  static const String editTelefonoeroute = 'editTelefono';
  const EditTelefonoScreen({Key? key}) : super(key: key);

  @override
  State<EditTelefonoScreen> createState() => _EditTelefonoScreenState();
}

class _EditTelefonoScreenState extends State<EditTelefonoScreen> {
  bool isValido = false;
  AuthBloc authBloc = AuthBloc();
  bool _isPhoneNumberValid =
      true; // Variable para controlar si el número de teléfono es válido

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
                setState(() {
                  _isPhoneNumberValid = false;
                });
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
              maxLength: 10,
              onChanged: (value) {
                setState(() {
                  _isPhoneNumberValid = isValidPhoneNumber(value);
                });
              },
              decoration: InputDecoration(
                labelText: 'Telefono',
                labelStyle: const TextStyle(
                  color: Color(0xFF7ab466),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: _isPhoneNumberValid
                        ? const Color(0xFF7ab466)
                        : Colors.red,
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
