// To parse this JSON data, do
//
//     final comentarioResponse = comentarioResponseFromJson(jsonString);

import 'dart:convert';

ComentarioPersonResponse comentarioResponseFromJson(String str) =>
    ComentarioPersonResponse.fromJson(json.decode(str));

String comentarioResponseToJson(ComentarioPersonResponse data) =>
    json.encode(data.toJson());

class ComentarioPersonResponse {
  ComentarioPerson comentario;

  ComentarioPersonResponse({
    required this.comentario,
  });

  factory ComentarioPersonResponse.fromJson(Map<String, dynamic> json) =>
      ComentarioPersonResponse(
        comentario: ComentarioPerson.fromJson(json["comentario"]),
      );

  Map<String, dynamic> toJson() => {
        "comentario": comentario.toJson(),
      };
}

class ComentarioPerson {
  String contenido;
  String usuario;
  String publicacion;
  List<dynamic> likes;
  String estado;
  String createdAt;
  String updatedAt;
  String uid;

  ComentarioPerson({
    required this.contenido,
    required this.usuario,
    required this.publicacion,
    required this.likes,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });

  factory ComentarioPerson.fromJson(Map<String, dynamic> json) =>
      ComentarioPerson(
        contenido: json["contenido"],
        usuario: json["usuario"],
        publicacion: json["publicacion"],
        likes: List<dynamic>.from(json["likes"].map((x) => x)),
        estado: json["estado"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "contenido": contenido,
        "usuario": usuario,
        "publicacion": publicacion,
        "likes": List<dynamic>.from(likes.map((x) => x)),
        "estado": estado,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "uid": uid,
      };
}
