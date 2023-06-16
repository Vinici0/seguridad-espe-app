import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/models/publication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LikesCommentsDetails extends StatelessWidget {
  //comentario, usuario, uid, fecha,
  final Publicacion publicacion;
  final String likes;

  const LikesCommentsDetails({
    Key? key,
    required this.publicacion,
    required this.likes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Row(
            //nombre de usuario que publico
            children: [
              Text(
                publicacion.usuarioNombre != null
                    ? publicacion.usuarioNombre!
                    : authBloc.state.usuario!.nombre,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        const Divider(height: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Row(
            children: [
              const Icon(
                FontAwesomeIcons.heart,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                likes,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 28),
              const Icon(
                FontAwesomeIcons.comment,
                size: 16,
              ),
              const SizedBox(width: 5),
              // Text(
              //     comentarios!.length.toString(),
              //   style: TextStyle(fontSize: 20),
              // ),
              const Spacer(),
              //Icono de compartir
              GestureDetector(
                  child: Row(
                    children: const [
                      Icon(
                        FontAwesomeIcons.shareFromSquare,
                        size: 16,
                        color: Color(0xFF6165FA),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Compartir',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6165FA),
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    print('Compartir');
                  })
            ],
          ),
        )
      ],
    );
  }
}
