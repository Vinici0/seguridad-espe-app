// ignore_for_file: unnecessary_this

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/screens/chatsales_config_screen.dart';
import 'package:flutter_maps_adv/widgets/chat_message.dart';
import 'package:intl/intl.dart';
import 'package:flutter_maps_adv/helpers/page_route.dart';

// ignore: constant_identifier_names
enum ServerStatus { Online, Offline, Connecting }

class ChatScreen extends StatefulWidget {
  static const String chatsalesroute = 'chatsales';

  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  AuthBloc authService = AuthBloc();
  MembersBloc chatProvider = MembersBloc();
  RoomBloc roomBloc = RoomBloc();

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final ScrollController _firstController = ScrollController();

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _estaEscribiendo = false;
  bool _isStateLoaded = false;

  @override
  void initState() {
    chatProvider = BlocProvider.of<MembersBloc>(context);
    roomBloc = BlocProvider.of<RoomBloc>(context);

    authService = BlocProvider.of<AuthBloc>(context, listen: false);
    authService.socketService.socket.emit('join-room', {
      'codigo': roomBloc.state.salaSeleccionada.uid,
    });

    _carregarMensajes();

    authService.socketService.socket.on('mensaje-grupal', _escucharMensaje);

    _firstController.addListener(() {
      if (!_isLoading &&
          _firstController.position.pixels >=
              _firstController.position.maxScrollExtent) {
        chatProvider.getNextChat(roomBloc.state.salaSeleccionada.uid).then((_) {
          _isLoading = false;
        });
        _isLoading = true;
      }
    });
    super.initState();
  }

  _carregarMensajes() async {
    await chatProvider.cargarMensajes(
        roomBloc.state.salaSeleccionada.uid); //carga los mensajes

    await roomBloc.cambiarEstadoSala(true);

    //Si el socket esta desconectado, lo conecta
    if (authService.socketService.serverStatus == ServerStatus.Offline) {
      authService.socketService.connect();
    }
  }

  void _escucharMensaje(dynamic payload) {
    print(payload);
    ChatMessage message = ChatMessage(
      nombre: payload['nombre'],
      texto: payload['mensaje'],
      uid: payload['de'],
      img: payload['isGoogle'] == true ? payload['img'] : payload['de'],
      isGoogle: payload['isGoogle'],
      createdAt: DateTime.now().toString(),
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
                        '0xFF${roomBloc.state.salaSeleccionada.color.substring(0, 2)}DDBB${roomBloc.state.salaSeleccionada.color.substring(4)}')),
                    Color(int.parse(
                        '0xFF${roomBloc.state.salaSeleccionada.color}')),
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
                  roomBloc.state.salaSeleccionada.nombre
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
            Text(roomBloc.state.salaSeleccionada.nombre,
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
              Navigator.of(context)
                  .push(CreateRoute.createRoute(const DetalleSalaScreen()));
            },
          )
        ],
      ),
      body: BlocBuilder<MembersBloc, MembersState>(
        builder: (context, state) {
          //si esta cargando los mensajes muestra un indicador de carga, pero solo la primera vez

          if (state.isLoading && !_isStateLoaded) {
            _isStateLoaded = true;
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF7ab466)),
              ),
            );
          }

          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(0.5),
                    itemCount: state.messages.length,
                    controller: _firstController,
                    itemBuilder: (_, i) {
                      final currentMessage = state.messages[i];
                      final previousMessage =
                          i > 0 ? state.messages[i - 1] : null;

                      // Verificar si se debe mostrar la línea de fecha
                      final showDateLine = previousMessage == null ||
                          !isSameDay(
                            DateTime.parse(previousMessage.createdAt),
                            DateTime.parse(currentMessage.createdAt),
                          );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showDateLine)
                            _buildDateLine(context, currentMessage.createdAt),
                          currentMessage,
                        ],
                      );
                    },
                    reverse: true,
                  ),
                ),
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
            textCapitalization: TextCapitalization.sentences,
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
                      //0xFF7ab466
                      data: const IconThemeData(color: Color(0xFF7ab466)),
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
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: authService.state.usuario!.uid,
      texto: texto,
      nombre: authService.state.usuario!.nombre,
      createdAt: DateTime.now().toString(),
      img: authService.state.usuario!.img,
      isGoogle: authService.state.usuario!.google,
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
        'para': this.roomBloc.state.salaSeleccionada.uid,
        'nombre': this.authService.state.usuario!.nombre,
        'isGoogle': this.authService.state.usuario!.google,
        'mensaje': texto,
        'img': this.authService.state.usuario!.img,
      });
    }
  }

  Widget _buildDateLine(BuildContext context, String createdAt) {
    final messageDate = DateTime.parse(createdAt);
    final currentDate = DateTime.now();

    if (isSameDay(messageDate, currentDate)) {
      return Container();
    } else {
      final formattedDate = DateFormat('MMMM dd, yyyy').format(messageDate);

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formattedDate,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    for (ChatMessage message in _messages) {
      message.animationController?.dispose();
    }
    roomBloc.add(
        ResetTotalMensajesNoLeidosEvent(roomBloc.state.salaSeleccionada.uid));
    authService.add(const IsSalasPendiente(false));
    chatProvider.closeList();
    authService.socketService.socket.off('mensaje-grupal');
    _executeAsyncProcessOnExit();

    super.dispose();
  }

  Future<void> _executeAsyncProcessOnExit() async {
    await roomBloc.cambiarEstadoSala(false);
    await roomBloc.salasInitEvent();
  }
}
