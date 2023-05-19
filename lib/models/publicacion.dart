import 'package:flutter_maps_adv/models/comentarios.dart';

class Publicacion {
  String titulo;
  String contenido;
  String usuario;
  int likes;
  String fecha;
  List<String>? img;
  List<Comentarios>? comentarios;
  String ciudad;
  String sector;
  //log , lat
  double longitud;
  double latitud;

  Publicacion({
    required this.titulo,
    required this.contenido,
    required this.usuario,
    this.likes = 0,
    this.img,
    this.comentarios,
    required this.ciudad,
    required this.sector,
    required this.fecha,
    required this.longitud,
    required this.latitud,
  });
}
