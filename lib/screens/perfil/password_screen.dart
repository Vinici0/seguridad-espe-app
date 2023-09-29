import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';

class PasswordScreen extends StatefulWidget {
  static const String passwordroute = 'password';
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  AuthBloc authBloc = AuthBloc();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isEmpty = true; // Variable para controlar si los campos están vacíos
  bool _passwordsMatch =
      true; // Variable para controlar si las contraseñas coinciden

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();

    _currentPasswordController.addListener(() {
      setState(() {});
    });

    _newPasswordController.addListener(() {
      setState(() {});
    });

    _confirmPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: false,
        title: const Text(
          'Cambiar Contraseña',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              //validar que los campos tenga mas de 6 caracteres
              if (_newPasswordController.text.length < 6) {
                // ignore: use_build_context_synchronously
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text(
                          'La contraseña debe tener al menos 6 caracteres.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cerrar el diálogo
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Color(0xFF7ab466)),
                          ),
                        ),
                      ],
                    );
                  },
                );
                return;
              }

              if (_newPasswordController.text !=
                  _confirmPasswordController.text) {
                _passwordsMatch = false;
                _showPasswordMismatchDialog();
                return;
              }

              final resul = await authBloc.cambiarContrasena(
                authBloc.state.usuario!.email,
                _currentPasswordController.text,
                _newPasswordController.text,
              );
              //Si es false, mostrar un diálogo de error
              if (resul == false) {
                // ignore: use_build_context_synchronously
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text(
                          'No se pudo cambiar la contraseña. Por favor, asegúrate de que la contraseña actual sea correcta.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cerrar el diálogo
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Color(0xFF7ab466)),
                          ),
                        ),
                      ],
                    );
                  },
                );
                return;
              }

              Navigator.pop(context);
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
              controller: _currentPasswordController,
              maxLength: 50,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: 'Contraseña Actual',
                labelStyle: const TextStyle(
                  color: Color(0xFF7ab466),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: _isEmpty ? Colors.red : const Color(0xFF7ab466),
                  ),
                ),
              ),
              obscureText: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _newPasswordController,
              maxLength: 50,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                labelStyle: const TextStyle(
                  color: Color(0xFF7ab466),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: _isEmpty ? Colors.red : const Color(0xFF7ab466),
                  ),
                ),
              ),
              obscureText: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _confirmPasswordController,
              maxLength: 50,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: 'Confirmar Nueva Contraseña',
                labelStyle: const TextStyle(
                  color: Color(0xFF7ab466),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: _isEmpty ? Colors.red : const Color(0xFF7ab466),
                  ),
                ),
              ),
              obscureText: true,
            ),
          ),
        ],
      ),
    );
  }

  void _showPasswordMismatchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Contraseñas no coinciden'),
          content: Text(
              'Las contraseñas no coinciden. Por favor, asegúrate de que sean iguales.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('OK', style: TextStyle(color: Color(0xFF7ab466))),
            ),
          ],
        );
      },
    );
  }

  void _checkPasswordRequirements() {
    final newPassword = _newPasswordController.text;
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(newPassword);
    final hasNumber = RegExp(r'[0-9]').hasMatch(newPassword);
    final meetsLengthRequirement = newPassword.length >= 6;

    setState(() {
      _passwordsMatch =
          _newPasswordController.text == _confirmPasswordController.text;

      // Actualizar _isEmpty y _passwordsMatch según las condiciones
      _isEmpty = _currentPasswordController.text.isEmpty ||
          newPassword.isEmpty ||
          _confirmPasswordController.text.isEmpty;
      _passwordsMatch = _passwordsMatch &&
          meetsLengthRequirement &&
          hasUpperCase &&
          hasNumber;
    });
  }
}
