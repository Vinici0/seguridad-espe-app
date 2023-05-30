import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/models/publication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LikesComentariosDetalle extends StatelessWidget {
  //comentario, usuario, uid, fecha,
  final Publicacion publicacion;

  const LikesComentariosDetalle({
    Key? key,
    required this.publicacion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              //nombre de usuario que publico
              children: [
                Text(
                  publicacion.usuario,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Divider(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.heart,
                  size: 16,
                ),
                SizedBox(width: 5),
                Text(
                  publicacion.likes.toString(),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 28),
                Icon(
                  FontAwesomeIcons.comment,
                  size: 16,
                ),
                SizedBox(width: 5),
                // Text(
                //     comentarios!.length.toString(),
                //   style: TextStyle(fontSize: 20),
                // ),
                Spacer(),
                //Icono de compartir
                GestureDetector(
                    child: Row(
                      children: [
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
      ),
    );
  }
}
