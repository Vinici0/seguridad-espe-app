import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/members/members_bloc.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MienbrosChatScreen extends StatefulWidget {
  static const String mienbrosChatroute = 'miembrosChat';

  MienbrosChatScreen({Key? key}) : super(key: key);

  @override
  State<MienbrosChatScreen> createState() => _MienbrosChatScreenState();
}

class _MienbrosChatScreenState extends State<MienbrosChatScreen> {
  MembersBloc membersBloc = MembersBloc();
  RoomBloc roomBloc = RoomBloc();
  List<Usuario> usuariosAll = [];
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    membersBloc = BlocProvider.of<MembersBloc>(context);
    roomBloc = BlocProvider.of<RoomBloc>(context);
    _cargarUsuarios();
    super.initState();
  }

  @override
  void dispose() {
    usuariosAll.clear();
    membersBloc.state.usuariosAll.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: false,
        elevation: 0.5,
        title: const Text(
          'Miembros del Grupo',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: BlocBuilder<MembersBloc, MembersState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SmartRefresher(
            controller: _refreshController,
            onRefresh: _cargarUsuarios,
            child: _ListViewUsuarios(state.usuariosAll),
          );
        },
      ),
    );
  }

  ListView _ListViewUsuarios(List<Usuario> miembros) {
    return ListView.separated(
      itemCount: miembros.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final miembro = miembros[index];

        return ListTile(
          trailing: miembro.online
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
            backgroundImage:
                miembro.img != null ? NetworkImage(miembro.img!) : null,
            child: miembro.img == null
                ? const Icon(
                    Icons.person,
                    color: Colors.white,
                  )
                : null,
          ),
          title: Text(
            miembro.nombre,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            miembro.email,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
          onTap: () {
            _mostrarDialogEliminar(miembro);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }

  _cargarUsuarios() async {
    await membersBloc.cargarUsuariosSala(roomBloc.state.salaSeleccionada.uid);
    setState(() {});
    _refreshController.refreshCompleted();
  }

  _mostrarDialogEliminar(Usuario miembro) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: const Text('Eliminar miembro'),
            content: Text(
              '¿Está seguro que desea eliminar a ${miembro.nombre} del grupo?',
              style: TextStyle(color: Colors.black87),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Color(0xFF6165FA)),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text('Eliminar miembro'),
            content: Text(
              '¿Está seguro que desea eliminar a ${miembro.nombre} del grupo?',
              style: const TextStyle(color: Colors.black87),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Color(0xFF6165FA)),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }
}
