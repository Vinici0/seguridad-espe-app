import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/resources/services/socket_service.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatMessage extends StatelessWidget {
  String imgNetwork =
      'https://lh3.googleusercontent.com/a/AAcHTtf-AUnv4YwTpe7ckIbFSDiR2e3AKue_p3yBjg2CdZL-CQ=s360-c-no';
  final String texto;
  final String uid;
  final String nombre;
  final String createdAt;

  final AnimationController? animationController;

  ChatMessage({
    Key? key,
    required this.texto,
    required this.uid,
    required this.nombre,
    required this.createdAt,
    this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = BlocProvider.of<AuthBloc>(context);
    ;

    if (animationController != null) {
      return FadeTransition(
        opacity: animationController!.drive(CurveTween(curve: Curves.easeOut)),
        child: SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: animationController!,
            curve: Curves.easeOut,
          ),
          child: _buildMessage(authService),
        ),
      );
    } else {
      return _buildMessage(authService);
    }
  }

  Widget _buildMessage(AuthBloc authService) {
    if (createdAt.isNotEmpty) {
      final messageDate = DateTime.parse(createdAt);
      final currentDate = DateTime.now();

      if (messageDate.year == currentDate.year &&
          messageDate.month == currentDate.month &&
          messageDate.day == currentDate.day) {
        // Today's date, display time only
        return _buildTimeMessage(authService);
      } else {
        // Display line with date and time
        return Column(
          children: [
            _buildDateLine(messageDate),
            _buildTimeMessage(authService),
          ],
        );
      }
    } else {
      return Container();
    }
  }

  Widget _buildDateLine(DateTime messageDate) {
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

  Widget _buildTimeMessage(AuthBloc authService) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              this.texto,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 3),
            Text(
              _getFormattedTime(),
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(left: 5, bottom: 5, right: 50),
          decoration: BoxDecoration(
            color: const Color(0xffE4E5E8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(right: 8.0),
              //   child: Container(
              //     alignment: Alignment.center,
              //     child: ClipOval(
              //       child: Image.network(
              //         imgNetwork,
              //         width: 30,
              //         height: 30,
              //         fit: BoxFit.cover,
              //         errorBuilder: (context, error, stackTrace) {
              //           return const Icon(Icons.account_circle, size: 30);
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.texto,
                      style: const TextStyle(color: Colors.black87),
                    ),
                    Text(
                      _getFormattedTime(),
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFormattedTime() {
    final messageDate = DateTime.parse(createdAt);
    final formattedTime = DateFormat('h:mm a').format(messageDate);
    return formattedTime;
  }
}
