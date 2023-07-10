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
  int likes;

  CommentPublication({
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
  bool _isLiked = false;
  String userLikes = '';
  int likeCount = 0;
  AuthBloc authBloc = AuthBloc();
  PublicationBloc publicationBloc = PublicationBloc();
  @override
  void initState() {
    publicationBloc = BlocProvider.of<PublicationBloc>(context);
    likeCount = 0;
    authBloc = BlocProvider.of<AuthBloc>(context, listen: false);
    initializeLikedStatus();
    // socketService.socketService.socket.on('toggle-like-comentario', (data) {
    //   if (data['comentarioUid'] == widget.uid) {
    //     setState(() {
    super.initState();
    //       likeCount = data['likeCount'];
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    _isLiked = false;
    super.dispose();
  }

  Future<void> initializeLikedStatus() async {
    final comments = publicationBloc.state.comentarios;
    // Si no hay comentarios no se hace nada
    if (comments == null || comments.isEmpty) return;

    try {
      final comment =
          comments.firstWhere((element) => element.uid == widget.uid);
      final userLikes = comment.likes;

      setState(() {
        _isLiked = userLikes!.contains(authBloc.state.usuario!.uid);
      });
    } catch (e) {
      print('Error al inicializar el estado de "Me gusta": $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    final isLikedNow = !_isLiked;

                    setState(() {
                      _isLiked = isLikedNow;
                    });

                    try {
                      if (isLikedNow) {
                        widget.likes++;
                      } else {
                        widget.likes--;
                      }

                      await publicationBloc.toggleLikeComentario(widget.uid);
                      // socketService.socketService.emit('toggle-like-comentario',
                      //     {'comentarioUid': widget.uid});
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                  child: Row(
                    children: [
                      _isLiked
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(FontAwesomeIcons.heart),
                      const SizedBox(width: 5),
                      Text(
                        widget.likes.toString() == null ||
                                widget.likes.toString() == 'null'
                            ? '0'
                            : widget.likes.toString(),
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
