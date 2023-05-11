import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/resources/services/salas_provider.dart';
import 'package:flutter_maps_adv/resources/services/socket_service.dart';
import 'package:flutter_maps_adv/screens/detallesala_screen.dart';
import 'package:flutter_maps_adv/widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  static const String chatsalesroute = 'chatsales';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

//TickerProviderStateMixin - Es para la animacion del boton de enviar
class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

  /*
    TODO: Cominicacion con el socket - de aqui para hacer la tesis
    TODO: Paso 2 - Ir al _handleSubmit y enviar el mensaje al socket
  */
  SocketService socketService = SocketService();
  AuthBloc authService = AuthBloc();
  SalasProvider chatProvider = SalasProvider();

  @override
  void initState() {
    //TODO: Jamas ubicar el listen en true
    this.chatProvider = BlocProvider.of<SalasProvider>(context);
    this.socketService = BlocProvider.of<SocketService>(context);
    this.authService = BlocProvider.of<AuthBloc>(context);

    socketService.socket.emit('join-room', {
      'codigo': chatProvider.salaSeleccionada.uid,
    });

    socketService.socket.on('mensaje-grupal', _escucharMensaje);

    _caragrHistorial(chatProvider.salaSeleccionada.uid);

    super.initState();
  }

  void _caragrHistorial(String uid) async {
    List<dynamic> chat = await chatProvider.getChatSala(uid);
    final history = chat.map((m) => ChatMessage(
        texto: m.mensaje,
        uid: m.usuario,
        nombre: m.nombre,
        animationController: new AnimationController(
            vsync: this, duration: Duration(milliseconds: 0))
          ..forward()));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessage message = ChatMessage(
      nombre: payload['nombre'],
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 300)),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(int.parse(
                        '0xFF${chatProvider.salaSeleccionada.color.substring(0, 2)}DDBB${chatProvider.salaSeleccionada.color.substring(4)}')),
                    Color(int.parse(
                        '0xFF${chatProvider.salaSeleccionada.color}')),
                    Color.fromARGB(255, 230, 116, 226),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Text(
                  chatProvider.salaSeleccionada.nombre
                      .substring(0, 2)
                      .toUpperCase(),
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            //Separa de manera horizontal
            SizedBox(
              width: 10,
            ),
            Text(chatProvider.salaSeleccionada.nombre,
                style: TextStyle(color: Colors.black, fontSize: 18)),
          ],
        ),

        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamed(context, DetalleSalaScreen.detalleSalaroute);
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true,
            )),

            Divider(height: 1),

            // TODO: Caja de texto
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextField(
            controller: _textController,
            onSubmitted: _handleSubmit,
            onChanged: (texto) {
              setState(() {
                if (texto.trim().length > 0) {
                  _estaEscribiendo = true;
                } else {
                  _estaEscribiendo = false;
                }
              });
            },
            decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
            focusNode: _focusNode,
          )),

          // Botón de enviar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
                ? CupertinoButton(
                    child: Text('Enviar'),
                    onPressed: _estaEscribiendo
                        ? () => _handleSubmit(_textController.text.trim())
                        : null,
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      //0xFF6165FA
                      data: IconThemeData(color: Color(0xFF6165FA)),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.send),
                        onPressed: _estaEscribiendo
                            ? () => _handleSubmit(_textController.text.trim())
                            : null,
                      ),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) return;

    print(texto);
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: authService.state.usuario!.uid,
      texto: texto,
      nombre: authService.state.usuario!.nombre,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });

    this.socketService.socket.emit('mensaje-grupal', {
      'de': this.authService.state.usuario!.uid,
      //TODO: Paso 3 - Enviar el mensaje al socket con el uid de la sala seleccionada para que el socket lo envie a todos los usuarios de la sala
      'para': this.chatProvider.salaSeleccionada.uid,
      'nombre': this.authService.state.usuario!.nombre,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    //TODO: Off del socket

    for (ChatMessage message in _messages) {
      //Para evitar fugas de memoria en la animacion del boton de enviar mensaje
      //Una vwz que se cierra se limpia la animacion del boton de enviar mensaje para evitar fugas de memoria
      message.animationController.dispose();
    }

    super.dispose();
  }
}
