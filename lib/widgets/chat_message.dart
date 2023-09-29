import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/resources/services/socket_service.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uid;
  final String nombre;
  final String createdAt;
  final String? img;
  final bool isGoogle;

  final AnimationController? animationController;

  const ChatMessage({
    Key? key,
    required this.texto,
    required this.uid,
    required this.nombre,
    required this.createdAt,
    required this.isGoogle,
    this.img,
    this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = BlocProvider.of<AuthBloc>(context);

    if (animationController != null) {
      return FadeTransition(
        opacity: animationController!.drive(CurveTween(curve: Curves.easeOut)),
        child: SizeTransition(
          sizeFactor: CurvedAnimation(
              parent: animationController!, curve: Curves.easeOut),
          child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _buildMessage(authService)),
        ),
      );
    } else {
      return _buildMessage(authService);
    }
  }

  Widget _buildMessage(AuthBloc authService) {
    return Container(
      child: uid == authService.state.usuario!.uid
          ? _myMessage()
          : _notMyMessage(),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(right: 5, bottom: 5, left: 50),
            decoration: BoxDecoration(
              color: const Color(0xFF7ab466),
              borderRadius: BorderRadius.circular(20),
            ),
            //separador

            child: Text(
              this.texto,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          //la hora
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              _getFormattedTime(),
              style: const TextStyle(color: Colors.black87, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //imagen, y si no hay un icono de persona
            img == null
                ? const CircleAvatar(
                    radius: 15,
                    child: Icon(
                      Icons.person,
                      size: 15,
                    ),
                  )
                : isGoogle == true
                    ? const CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage('assets/no-image.png'),
                        // NetworkImage(img!),
                      )
                    : const CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage('assets/no-image.png'),
                        // NetworkImage(img!),
                      ),
            // CircleAvatar(
            //     radius: 15,
            //     backgroundImage: NetworkImage(
            //         '${Environment.apiUrl}/uploads/usuario/usuarios/$uid'),
            //   ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      // nombre,
                      'Anónimo',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    margin:
                        const EdgeInsets.only(left: 5, bottom: 5, right: 50),
                    decoration: BoxDecoration(
                      color: const Color(0xffE4E5E8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    //separador

                    child: Text(
                      this.texto,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      _getFormattedTime(),
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFormattedTime() {
    //fecha type es
    final date = DateTime.parse(createdAt);
    final formattedDate = DateFormat('kk:mm').format(date);

    //fecha timeago
    final timeAgo = timeago.format(date, locale: 'es');

    //si es hoy
    final today = DateTime.now();
    final difference = today.difference(date);

    if (difference.inDays == 0) {
      return timeAgo;
    } else {
      return formattedDate;
    }
  }
}
