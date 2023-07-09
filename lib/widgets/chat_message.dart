import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/resources/services/socket_service.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uid;
  final String nombre;

  final AnimationController? animationController;

  ChatMessage({
    Key? key,
    required this.texto,
    required this.uid,
    required this.nombre,
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
          child: _buildMessage(authService),
        ),
      );
    } else {
      return _buildMessage(authService);
    }
  }

  Widget _buildMessage(AuthBloc authService) {
    return Container(
      child: this.uid == authService.state.usuario!.uid
          ? _myMessage()
          : _notMyMessage(),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(right: 5, bottom: 5, left: 50),
        decoration: BoxDecoration(
          color: const Color(0xFF6165FA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          this.texto,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              this.nombre,
              style: const TextStyle(color: Colors.black87, fontSize: 10),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(left: 5, bottom: 5, right: 50),
            decoration: BoxDecoration(
              color: const Color(0xffE4E5E8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              this.texto,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
