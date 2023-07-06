import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/models/comentarios.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MienbrosChatScreen extends StatefulWidget {
  static const String mienbrosChatroute = 'miembrosChat';

  MienbrosChatScreen({Key? key}) : super(key: key);

  @override
  State<MienbrosChatScreen> createState() => _MienbrosChatScreenState();
}

class _MienbrosChatScreenState extends State<MienbrosChatScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  RoomBloc chatProvider = RoomBloc();
  final usuariosAll = [];

  @override
  void initState() {
    chatProvider = BlocProvider.of<RoomBloc>(context);
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = BlocProvider.of<RoomBloc>(context);
    final miembros = chatProvider.state.usuariosSala;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: false,
        elevation: 0.5,
        title: const Text(
          'Miembros del Grupo',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        child: Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: miembros.length,
            itemBuilder: (context, index) {
              return ListTile(
                //al final de la lista icono si esta conectado
                trailing: miembros[index].online
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.check_circle,
                        color: Colors.red,
                      ),
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: miembros[index].img != null
                      ? NetworkImage(miembros[index].img!)
                      : null,
                  child: miembros[index].img == null
                      ? const Icon(
                          Icons.person,
                          color: Colors.white,
                        ) //Icono por defecto
                      : null,
                ),
                title: Text(
                  miembros[index].nombre,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  miembros[index].email,
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _cargarUsuarios() async {
    await chatProvider
        .cargarUsuariosSala(chatProvider.state.salaSeleccionada.uid);
    usuariosAll.addAll(chatProvider.usuariosAllSala);

    setState(() {});
    _refreshController.refreshCompleted();
  }
}
