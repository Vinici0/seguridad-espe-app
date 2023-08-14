import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class CommentPublication extends StatefulWidget {
  final String uidUsuario;
  final String uid;
  final String comentario;
  final String nombre;
  final String? fotoPerfil;
  final String createdAt;
  final bool isGoogle;
  List<String> likes = [];
  bool isLiked;

  CommentPublication({
    super.key,
    required this.uidUsuario,
    required this.comentario,
    required this.nombre,
    this.fotoPerfil,
    required this.createdAt,
    required this.isGoogle,
    required this.isLiked,
    required this.uid,
    List<String>? likes,
  }) : likes = likes ?? [];

  @override
  _CommentPublicationState createState() => _CommentPublicationState();
}

class _CommentPublicationState extends State<CommentPublication> {
  String userLikes = '';
  int likeCount = 0;
  AuthBloc authBloc = AuthBloc();
  PublicationBloc publicationBloc = PublicationBloc();

  @override
  void initState() {
    publicationBloc = BlocProvider.of<PublicationBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context, listen: false);
    // Actualizar el estado de widget.isLiked en función de widget.likes
    widget.isLiked = widget.likes.contains(authBloc.state.usuario!.uid);
    super.initState();
  }

  @override
  void dispose() {
    widget.isLiked = false;
    super.dispose();
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
                widget.isGoogle == true
                    ? CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(widget.fotoPerfil!))
                    : widget.fotoPerfil == null
                        ? const CircleAvatar(
                            radius: 15,
                            backgroundImage: AssetImage('assets/no-image.png'),
                          )
                        : CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(
                                '${Environment.apiUrl}/uploads/usuario/usuarios/${widget.uidUsuario}'),
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
                  onTap: () {
                    print('Eliminar comentario');
                    print(widget.uid);
                    final isLikedNow = !widget.isLiked;
                    setState(() {
                      widget.isLiked = isLikedNow;
                    });

                    try {
                      if (isLikedNow) {
                        if (!widget.likes
                            .contains(authBloc.state.usuario!.uid)) {
                          print('Agregando like');
                          print(authBloc.state.usuario!.uid);
                          print('Usuario');
                          print(widget.likes);
                          widget.likes.add(authBloc.state.usuario!.uid);
                          print(widget.likes);
                        }

                        publicationBloc.toggleLikeComentario(widget.uid);
                      } else {
                        widget.likes.remove(authBloc.state.usuario!.uid);
                        publicationBloc.toggleLikeComentario(widget.uid);
                      }
                    } catch (e) {
                      // ignore: avoid_print
                      print('Error: $e');
                    }
                  },
                  child: Row(
                    children: [
                      widget.likes.contains(authBloc.state.usuario!.uid)
                          ? const Icon(FontAwesomeIcons.solidThumbsUp,
                              color: Color(0xFF6165FA), size: 20)
                          : const Icon(FontAwesomeIcons.thumbsUp,
                              color: Colors.black54, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        widget.likes.length.toString(),
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
