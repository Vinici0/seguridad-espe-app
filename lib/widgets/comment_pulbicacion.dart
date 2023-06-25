import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommentPublication extends StatelessWidget {
  final String uid;
  final String comentario;
  final String nombre;
  final String fotoPerfil;
  final String createdAt;
  final int likes;

  const CommentPublication({
    super.key,
    required this.uid,
    required this.comentario,
    required this.nombre,
    required this.fotoPerfil,
    required this.createdAt,
    required this.likes,
  });

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
                  //Las dos primeras letras del nombre
                  child: Text(
                    nombre.substring(0, 2),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),

                      //fecha de publicacion
                      Text(
                        createdAt,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  FontAwesomeIcons.heart,
                  size: 15,
                  color: Colors.black54,
                ),
                const SizedBox(width: 5),
                Text(
                  likes.toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 79),
            child: Text(
              comentario,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              // textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
