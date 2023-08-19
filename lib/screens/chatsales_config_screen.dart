import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/screens/chatsales_miembros.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetalleSalaScreen extends StatelessWidget {
  static const String detalleSalaroute = 'detalleSala';
  const DetalleSalaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = BlocProvider.of<RoomBloc>(context);
    final auth = BlocProvider.of<AuthBloc>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: false,
        elevation: 0.5,
        title: const Text('Detalle',
            //alinea a la izquierda
            style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(int.parse(
                          '0xFF${chatProvider.state.salaSeleccionada.color.substring(0, 2)}DDBB${chatProvider.state.salaSeleccionada.color.substring(4)}')),
                      Color(int.parse(
                          '0xFF${chatProvider.state.salaSeleccionada.color}')),
                      const Color.fromARGB(255, 230, 116, 226),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: CircleAvatar(
                  radius: size.width * 0.07,
                  backgroundColor: Colors.transparent,
                  child: Text(
                    chatProvider.state.salaSeleccionada.nombre
                        .substring(0, 2)
                        .toUpperCase(),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            //acerca de
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      'Acerca de',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      chatProvider.state.salaSeleccionada.nombre,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  //miembros
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      'Miembros',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, MienbrosChatScreen.mienbrosChatroute);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: const Text(
                                "Miembros de la sala",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            //un icon de flecha mas info
                            const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.arrow_forward_ios, size: 20)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //codigo de sala
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      'Invitar a nuevos miembros',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                          text: chatProvider.state.salaSeleccionada.codigo));
                      // Agrega aquí una notificación o mensaje para indicar que se ha copiado el código al portapapeles
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController(
                                text:
                                    chatProvider.state.salaSeleccionada.codigo),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                            icon: const Icon(Icons.content_copy, size: 20),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text: chatProvider
                                      .state.salaSeleccionada.codigo));
                              Fluttertoast.showToast(
                                msg: 'Copiado',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.black87,
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              color: Colors.black26,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  child: Ink(
                      width: MediaQuery.of(context).size.width * 0.999,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: auth.state.usuario!.uid ==
                                chatProvider.state.salaSeleccionada.propietario
                            ? GestureDetector(
                                onTap: () {
                                  _showDialogEliminar(context, chatProvider);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Salir y eliminar grupo',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  _showDialog(context, chatProvider, auth);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Salir del grupo',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                      )),
                  onTap: () {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //showDialog si esta seguro de salir
  void _showDialog(BuildContext context, RoomBloc chatProvider, AuthBloc auth) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro de salir?'),
          content: const Text(
            'Si sales del grupo, no podrás ver los mensajes que se envíen en él.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'CANCELAR',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                chatProvider.add(AbandonarSalaEvent(auth.state.usuario!.uid));
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'SALIR',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: Colors.white,
          elevation: 4.0,
        );
      },
    );
  }

  //_showDialog si esta seguro de eliminar y salir
  void _showDialogEliminar(BuildContext context, RoomBloc chatProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro?'),
          content: const Text(
            'Al salir del grupo, se eliminará el grupo y ningún miembro tendrá acceso. Esta acción es irreversible.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'CANCELAR',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                chatProvider.add(
                    DeleteSalaEvent(chatProvider.state.salaSeleccionada.uid));
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'SALIR Y ELIMINAR',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: Colors.white,
          elevation: 4.0,
        );
      },
    );
  }
}
