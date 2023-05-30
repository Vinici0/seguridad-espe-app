import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/screens/chatsales_miembros.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetalleSalaScreen extends StatelessWidget {
  static const String detalleSalaroute = 'detalleSala';
  const DetalleSalaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = BlocProvider.of<RoomBloc>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: false,
        elevation: 0.5,
        title: Text('Detalle',
            //alinea a la izquierda
            style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(int.parse(
                          '0xFF${chatProvider.state.salaSeleccionada.color.substring(0, 2)}DDBB${chatProvider.state.salaSeleccionada.color.substring(4)}')),
                      Color(int.parse(
                          '0xFF${chatProvider.state.salaSeleccionada.color}')),
                      Color.fromARGB(255, 230, 116, 226),
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
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            //acerca de
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        'Acerca de',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        chatProvider.state.salaSeleccionada.nombre,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    //miembros
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        'Miembros',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        ///MienbrosChatScreen.mienbrosChatroute
                        Navigator.pushNamed(
                            context, MienbrosChatScreen.mienbrosChatroute);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              "Miembros de la sala",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          //un icon de flecha mas info
                          Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(Icons.arrow_forward_ios, size: 20)),
                        ],
                      ),
                    ),
                    //codigo de sala
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
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
                                  text: chatProvider
                                      .state.salaSeleccionada.codigo),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.content_copy, size: 20),
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
            ),
          ],
        ),
      ),
    );
  }
}
