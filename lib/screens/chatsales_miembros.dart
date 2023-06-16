import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';

class MienbrosChatScreen extends StatelessWidget {
  static const String mienbrosChatroute = 'mienbrosChat';
  const MienbrosChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = BlocProvider.of<RoomBloc>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: false,
        elevation: 0.5,
        title: const Text('Miembros del Grupo',
            //alinea a la izquierda
            style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: chatProvider.state.usuariosSala.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Text(
                  chatProvider.state.usuariosSala[index].nombre
                      .substring(0, 2)
                      .toUpperCase(),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                chatProvider.state.usuariosSala[index].nombre,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                chatProvider.state.usuariosSala[index].email,
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
