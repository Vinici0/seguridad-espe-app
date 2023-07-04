import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';

class EditPerfilScreen extends StatelessWidget {
  static const String editPerfilroute = 'editPerfil';
  const EditPerfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: false,
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Center(
        child: Text(authBloc.state.usuario!.telefono),
      ),
    );
  }
}
