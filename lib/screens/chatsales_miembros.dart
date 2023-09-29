import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MienbrosChatScreen extends StatefulWidget {
  static const String mienbrosChatroute = 'miembrosChat';

  const MienbrosChatScreen({Key? key}) : super(key: key);

  @override
  State<MienbrosChatScreen> createState() => _MienbrosChatScreenState();
}

class _MienbrosChatScreenState extends State<MienbrosChatScreen> {
  MembersBloc membersBloc = MembersBloc();
  RoomBloc roomBloc = RoomBloc();
  AuthBloc authBloc = AuthBloc();

  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    membersBloc = BlocProvider.of<MembersBloc>(context, listen: false);
    roomBloc = BlocProvider.of<RoomBloc>(context, listen: false);
    authBloc = BlocProvider.of<AuthBloc>(context);
    _cargarUsuarios();
    super.initState();
  }

  @override
  void dispose() {
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
              child: CircularProgressIndicator(
                color: Color(0xFF7ab466),
              ),
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

  // ignore: non_constant_identifier_names
  ListView _ListViewUsuarios(List<Usuario> miembros) {
    return ListView.separated(
      itemCount: miembros.length,
      physics: const BouncingScrollPhysics(),
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
            backgroundImage: miembro.google
                ? NetworkImage(miembro.img!)
                : miembro.img == null
                    ? const AssetImage('assets/no-image.png') as ImageProvider
                    : NetworkImage(
                        '${Environment.apiUrl}/uploads/usuario/usuarios/${miembro.uid}'),
          ),
          title: Row(
            children: [
              Text(
                miembro.nombre.length <= 15
                    ? miembro.nombre
                    : miembro.nombre.substring(0, 15),
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              roomBloc.state.salaSeleccionada.propietario == miembro.uid
                  ? const Text(
                      '(Administrador)',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          subtitle: Text(
            miembro.email,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
          onTap: () {
            if (roomBloc.state.salaSeleccionada.propietario ==
                    authBloc.state.usuario!.uid &&
                miembro.uid != authBloc.state.usuario!.uid) {
              _mostrarDialogEliminar(miembro);
            }
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
              style: const TextStyle(color: Colors.black87),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Color(0xFF7ab466)),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  membersBloc.add(DeleteMemberByIdEvent(
                      roomBloc.state.salaSeleccionada.uid, miembro.uid));
                  Navigator.of(context).pop();
                  Navigator.pop(context);
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
                  style: TextStyle(color: Color(0xFF7ab466)),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  membersBloc.add(DeleteMemberByIdEvent(
                      roomBloc.state.salaSeleccionada.uid, miembro.uid));
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      },
    );
  }
}
