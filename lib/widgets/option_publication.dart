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
  }) : super(key: key);

  final List<Publicacion> publicaciones;
  final PublicationState state;
  final AuthBloc usuarioBloc;
  final int i;

  @override
  _OptionNewsState createState() => _OptionNewsState();
}

class _OptionNewsState extends State<OptionNews> {
  bool isLiked = false;
  PublicationBloc publicationBloc = PublicationBloc();

  @override
  void initState() {
    super.initState();
    // Verificar si el usuario actual ya ha dado like en la publicación
    final currentUserUid = widget.usuarioBloc.state.usuario!.uid;
    publicationBloc = BlocProvider.of<PublicationBloc>(context);
    isLiked =
        widget.publicaciones[widget.i].likes?.contains(currentUserUid) ?? false;
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
      if (isLiked) {
        widget.publicaciones[widget.i].likes?.remove(currentUserUid);
      } else {
        widget.publicaciones[widget.i].likes?.add(currentUserUid);
      }
      isLiked = !isLiked;
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
                    child: isLiked
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 22.5,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: Colors.grey,
                            size: 22.5,
                          ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.publicaciones[widget.i].likes == null
                        ? '0'
                        : widget.publicaciones[widget.i].likes!.length
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
                    //TODO: solicionar el problema de los comentarios
                    child: const Icon(
                      FontAwesomeIcons.comment,
                      color: Colors.grey,
                      size: 19.5,
                    ),
                  ),
                  Text(
                    widget.state.publicaciones[widget.i].comentarios == null
                        ? '0'
                        : widget
                            .state.publicaciones[widget.i].comentarios!.length
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
            Navigator.pushNamed(context, DetalleScreen.detalleroute,
                arguments: {
                  'publicacion': widget.publicaciones[widget.i],
                  'likes':
                      widget.publicaciones[widget.i].likes!.length.toString(),
                });
          },
        ),
      ],
    );
  }
}
