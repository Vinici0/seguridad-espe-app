import 'package:flutter/material.dart';

class EditPerfilScreen extends StatelessWidget {
  static const String editPerfilroute = 'editPerfil';
  const EditPerfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: false,
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: const Center(
        child: Text('EditPerfilScreen'),
      ),
    );
  }
}
