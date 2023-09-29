import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/models/publication.dart';
import 'package:flutter_maps_adv/screens/news_detalle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OptionNews extends StatefulWidget {
  const OptionNews({
    Key? key,
    required this.publicaciones,
    required this.state,
    required this.usuarioBloc,
    required this.i,
    required this.likes,
  }) : super(key: key);

  final List<Publicacion> publicaciones;
  final PublicationState state;
  final AuthBloc usuarioBloc;
  final int i;
  final List<String> likes;

  @override
  _OptionNewsState createState() => _OptionNewsState();
}

class _OptionNewsState extends State<OptionNews> {
  PublicationBloc publicationBloc = PublicationBloc();
  AuthBloc usuarioBloc = AuthBloc();

  @override
  void initState() {
    super.initState();
    // Verificar si el usuario actual ya ha dado like en la publicación
    final currentUserUid = widget.usuarioBloc.state.usuario!.uid;
    publicationBloc = BlocProvider.of<PublicationBloc>(context);
    usuarioBloc = BlocProvider.of<AuthBloc>(context);
  }

  Future<void> _handleLike() async {
    final publicationUid = widget.publicaciones[widget.i].uid!;
    final currentUserUid = widget.usuarioBloc.state.usuario!.uid;

    try {
      publicationBloc.add(PublicacionesUpdateEvent(publicationUid));
    } catch (e) {
      print('Error: $e');
    }

    setState(() {
      if (widget.likes.contains(currentUserUid)) {
        final newPublication = widget.publicaciones[widget.i].copyWith(
          countLikes: widget.likes.length - 1,
        );
        widget.likes.remove(currentUserUid);
      } else {
        final newPublication = widget.publicaciones[widget.i].copyWith(
          countLikes: widget.likes.length + 1,
        );
        widget.likes.add(currentUserUid);
        BlocProvider.of<PublicationBloc>(context)
            .add(UpdatePublicationEvent(newPublication));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _handleLike, // Llamar al método de manejo del like
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 30.0,
                    height: 35.0,
                    margin: const EdgeInsets.only(left: 28),
                    child: widget.likes.contains(usuarioBloc.state.usuario!.uid)
                        //Icono del dedo pulgar hacia arriba Icons.thumb_up
                        ? const Icon(
                            FontAwesomeIcons.solidThumbsUp,
                            color: Color(0xFF7ab466),
                            size: 19.5,
                          )
                        : const Icon(
                            FontAwesomeIcons.thumbsUp,
                            color: Colors.grey,
                            size: 19.5,
                          ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.state.publicaciones[widget.i].likes!.length
                        .toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.zero,
                    width: 30.0,
                    height: 35.0,
                    // TODO: solucionar el problema de los comentarios
                    child: const Icon(
                      FontAwesomeIcons.comment,
                      color: Colors.grey,
                      size: 19.5,
                    ),
                  ),
                  Text(
                    widget.state.publicaciones[widget.i].comentarios == null
                        ? '0'
                        : widget.state.publicaciones[widget.i].countComentarios
                            .toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            publicationBloc
                .add(PublicacionSelectEvent(widget.publicaciones[widget.i]));
            Navigator.of(context)
                .push(_createRoute(widget.publicaciones[widget.i]));
          },
        ),
      ],
    );
  }
}

Route _createRoute(Publicacion publicacion) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const DetalleScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
