import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentPublication extends StatefulWidget {
  final String uid;
  final String comentario;
  final String nombre;
  final String fotoPerfil;
  final String createdAt;
  final String likes;

  const CommentPublication({
    Key? key,
    required this.uid,
    required this.comentario,
    required this.nombre,
    required this.fotoPerfil,
    required this.createdAt,
    required this.likes,
  }) : super(key: key);

  @override
  _CommentPublicationState createState() => _CommentPublicationState();
}

class _CommentPublicationState extends State<CommentPublication> {
  bool isLiked = false;
  int likeCount = 0;
  AuthBloc socketService = AuthBloc();

  @override
  void initState() {
    super.initState();
    likeCount = int.parse(widget.likes);
    initializeLikedStatus();
    socketService = BlocProvider.of<AuthBloc>(context, listen: false);

    socketService.socketService.socket.on('toggle-like-comentario', (data) {
      if (data['comentarioUid'] == widget.uid) {
        setState(() {
          likeCount = data['likeCount'];
        });
      }
    });
  }

  @override
  void dispose() {
    //off el socket
    socketService.socketService.socket.off('toggle-like-comentario');
    super.dispose();
  }

  Future<void> initializeLikedStatus() async {
    final publicationBloc = BlocProvider.of<PublicationBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);

    final comments = publicationBloc.state.comentarios!;
    final comment = comments.firstWhere((element) => element.uid == widget.uid);
    final userLikes = comment.likes!;

    setState(() {
      isLiked = userLikes.contains(authBloc.state.usuario!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final publicationBloc = BlocProvider.of<PublicationBloc>(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF6165FA),
                  child: Text(
                    widget.nombre.substring(0, 2),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.nombre,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        timeago.format(
                          DateTime.parse(widget.createdAt),
                          locale: 'es',
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      if (isLiked) {
                        likeCount--;
                        isLiked = false;
                      } else {
                        likeCount++;
                        isLiked = true;
                      }
                    });

                    try {
                      await publicationBloc.toggleLikeComentario(widget.uid);
                      socketService.socketService.emit('toggle-like-comentario',
                          {'comentarioUid': widget.uid});
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                  child: Row(
                    children: [
                      isLiked
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(FontAwesomeIcons.heart),
                      const SizedBox(width: 5),
                      Text(
                        likeCount.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 79),
            child: Text(
              widget.comentario,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          const Divider(
            color: Colors.black12,
            height: 30,
          ),
        ],
      ),
    );
  }
}
