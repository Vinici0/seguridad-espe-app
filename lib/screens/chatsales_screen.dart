// ignore_for_file: unnecessary_this

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/models/salas_mensaje_response.dart';
import 'package:flutter_maps_adv/screens/chatsales_config_screen.dart';
import 'package:flutter_maps_adv/widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  static const String chatsalesroute = 'chatsales';

  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final ScrollController _firstController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  bool _estaEscribiendo = false;

  AuthBloc authService = AuthBloc();
  RoomBloc chatProvider = RoomBloc();

  @override
  void initState() {
    chatProvider = BlocProvider.of<RoomBloc>(context);
    chatProvider.cargarMensajes(chatProvider.state.salaSeleccionada.uid);
    authService = BlocProvider.of<AuthBloc>(context, listen: false);

    // _caragrHistorial(chatProvider.state.salaSeleccionada.uid);
    authService.socketService.socket.emit('join-room', {
      'codigo': chatProvider.state.salaSeleccionada.uid,
    });

    authService.socketService.socket.on('mensaje-grupal', _escucharMensaje);

    _firstController.addListener(() {
      if (!_isLoading &&
          _firstController.position.pixels >=
              _firstController.position.maxScrollExtent) {
        print('llego al final');
        chatProvider.getNextChat().then((_) {
          _isLoading = false;
        });
        _isLoading = true;
      }
    });
    super.initState();
  }

  // void _caragrHistorial(String uid) async {
  //   //isLoading != true
  //   await chatProvider.cargarMensajes(uid);

  //   List<MensajesSala>? chat = chatProvider.mensajesAll;

  //   if (chat.isNotEmpty) {
  //     final history = chat.map((m) => ChatMessage(
  //         texto: m.mensaje,
  //         uid: m.usuario,
  //         nombre: m.nombre,
  //         animationController: AnimationController(
  //             vsync: this, duration: const Duration(milliseconds: 0))
  //           ..forward()));

  //     if (mounted) {
  //       setState(() {
  //         _messages.insertAll(0, history);
  //       });
  //     }
  //   }
  //   chatProvider.add(GetLoadedChatMessage(_messages));
  // }

  void _escucharMensaje(dynamic payload) {
    ChatMessage message = ChatMessage(
      nombre: payload['nombre'],
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300)),
    );
    setState(() {
      _messages.insert(0, message);
      chatProvider.add(AddMessageEvent(message));
    });
    message.animationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: false,
        title: Row(
          children: [
            Container(
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
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: CircleAvatar(
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
            //Separa de manera horizontal
            const SizedBox(
              width: 10,
            ),
            Text(chatProvider.state.salaSeleccionada.nombre,
                style: const TextStyle(color: Colors.black87, fontSize: 18)),
          ],
        ),
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.black87,
            ),
            onPressed: () async {
              // ignore: use_build_context_synchronously
              Navigator.pushNamed(context, DetalleSalaScreen.detalleSalaroute);
            },
          )
        ],
      ),
      body: BlocBuilder<RoomBloc, RoomState>(
        builder: (context, state) {
          // if (state.isLoading) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }

          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Flexible(
                    child: ListView.builder(
                  physics:
                      const BouncingScrollPhysics(), //sirve para que el scroll se vea mas real
                  itemCount: state.messages.length,
                  controller: _firstController,
                  itemBuilder: (_, i) => state.messages[i],
                  reverse: true,
                )),
                const Divider(height: 1),
                Container(
                  color: Colors.white,
                  child: _inputChat(),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _inputChat() {
    //SafeArea: Sirve para que el teclado no tape el contenido de la pantalla
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
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
            decoration:
                const InputDecoration.collapsed(hintText: 'Enviar mensaje'),
            focusNode: _focusNode,
          )),

          // Botón de enviar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
                ? CupertinoButton(
                    onPressed: _estaEscribiendo
                        ? () => _handleSubmit(_textController.text.trim())
                        : null,
                    child: const Text('Enviar'),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      //0xFF6165FA
                      data: const IconThemeData(color: Color(0xFF6165FA)),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: const Icon(Icons.send),
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

  void _handleSubmit(String texto) {
    if (texto.length == 0) return;

    print(texto);
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: authService.state.usuario!.uid,
      texto: texto,
      nombre: authService.state.usuario!.nombre,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );

    if (mounted) {
      setState(() {
        _messages.insert(0,
            newMessage); //inserta el mensaje en la primera posicion de la lista
        chatProvider.add(AddMessageEvent(newMessage));

        newMessage.animationController?.forward();
        _estaEscribiendo = false;
      });

      this.authService.socketService.socket.emit('mensaje-grupal', {
        'de': this.authService.state.usuario!.uid,
        'para': this.chatProvider.state.salaSeleccionada.uid,
        'nombre': this.authService.state.usuario!.nombre,
        'mensaje': texto,
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    for (ChatMessage message in _messages) {
      //ssss
      message.animationController?.dispose();
    }
    authService.socketService.socket.off('mensaje-grupal');
    super.dispose();
  }
}
