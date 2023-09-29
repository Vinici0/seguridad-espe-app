import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/models/publication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LikesCommentsDetails extends StatefulWidget {
  //comentario, usuario, uid, fecha,
  final Publicacion publicacion;
  final List<String> likes;

  const LikesCommentsDetails({
    Key? key,
    required this.publicacion,
    required this.likes,
  }) : super(key: key);

  @override
  State<LikesCommentsDetails> createState() => _LikesCommentsDetailsState();
}

class _LikesCommentsDetailsState extends State<LikesCommentsDetails> {
  AuthBloc authService = AuthBloc();

  bool isLiked = false;

  @override
  void initState() {
    authService = BlocProvider.of<AuthBloc>(context, listen: false);
    final currentUserUid = authService.state.usuario!.uid;

    if (widget.likes.contains(currentUserUid)) {
      isLiked = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocBuilder<PublicationBloc, PublicationState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                //nombre de usuario que publico
                children: [
                  //icono de usuario
                  const Icon(
                    Icons.account_circle,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.publicacion.isPublic
                        ? authBloc.state.usuario!.role == 'USER_ROLE'
                            ? 'Anónimo'
                            : widget.publicacion.nombreUsuario
                        : 'Anónimo',
                  ),
                ],
              ),
            ),
            const Divider(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: state.currentPublicacion?.isPublicacionPendiente == true
                  ? Row(
                      children: const [
                        Icon(
                          //icono de una comunidad feliz
                          FontAwesomeIcons.faceSmileBeam,
                          color: Colors.green,
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            'La publicación ha sido finalizada por el usuario. ¡Gracias por tu colaboración!',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      'Si tienes información relevante, por favor, compártela comentando en esta publicación. La noticia todavía no ha sido finalizada por el usuario y cualquier novedad sería muy apreciada.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
            ),
            const Divider(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  //TODO: Cambiar el icono
                  IconButton(
                    onPressed: () {
                      _handleLike();
                    },
                    icon: isLiked
                        ? const Icon(
                            FontAwesomeIcons.solidThumbsUp,
                            color: Color(0xFF7ab466),
                          )
                        : const Icon(
                            FontAwesomeIcons.thumbsUp,
                            color: Colors.black54,
                          ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.publicacion.likes!.length.toString(),
                    style: const TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                  const SizedBox(width: 28),
                  const Icon(
                    FontAwesomeIcons.comment,
                    size: 18,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 5),
                  state.comentariosP.length > 0
                      ? Text(
                          state.comentariosP.length.toString(),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black54),
                        )
                      : const Text(
                          '0',
                          style: TextStyle(fontSize: 20, color: Colors.black54),
                        ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  _handleLike() async {
    final publicationUid = widget.publicacion.uid!;
    final currentUserUid = authService.state.usuario!.uid;

    // final newPublication = widget.publicacion.copyWith(countLikes:
    try {
      BlocProvider.of<PublicationBloc>(context)
          .add(PublicacionesUpdateEvent(publicationUid));
    } catch (e) {
      print('Error: $e');
    }
    setState(() {
      if (isLiked) {
        widget.publicacion.likes!.remove(currentUserUid);
        final newPublication = widget.publicacion
            .copyWith(countLikes: widget.publicacion.countLikes! - 1);
        BlocProvider.of<PublicationBloc>(context)
            .add(UpdatePublicationEvent(newPublication));
      } else {
        widget.publicacion.likes!.add(currentUserUid);
        final newPublication = widget.publicacion
            .copyWith(countLikes: widget.publicacion.countLikes! + 1);
        BlocProvider.of<PublicationBloc>(context)
            .add(UpdatePublicationEvent(newPublication));
      }
      isLiked = !isLiked;
    });
  }
}
