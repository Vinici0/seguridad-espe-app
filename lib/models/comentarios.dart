// To parse this JSON data, do
//
//     final comentarioResponse = comentarioResponseFromJson(jsonString);

import 'dart:convert';

ComentarioResponse comentarioResponseFromJson(String str) =>
    ComentarioResponse.fromJson(json.decode(str));

String comentarioResponseToJson(ComentarioResponse data) =>
    json.encode(data.toJson());

class ComentarioResponse {
  bool ok;
  List<Comentario> comentarios;

  ComentarioResponse({
    required this.ok,
    required this.comentarios,
  });

  factory ComentarioResponse.fromJson(Map<String, dynamic> json) =>
      ComentarioResponse(
        ok: json["ok"],
        comentarios: List<Comentario>.from(
            json["comentarios"].map((x) => Comentario.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "comentarios": List<dynamic>.from(comentarios.map((x) => x.toJson())),
      };
}

class Comentario {
  String contenido;
  String usuario;
  String publicacion;
  int likes;
  String estado;
  String createdAt;
  String updatedAt;
  String uid;

  Comentario({
    required this.contenido,
    required this.usuario,
    required this.publicacion,
    required this.likes,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) => Comentario(
        contenido: json["contenido"],
        usuario: json["usuario"],
        publicacion: json["publicacion"],
        likes: json["likes"],
        estado: json["estado"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "contenido": contenido,
        "usuario": usuario,
        "publicacion": publicacion,
        "likes": likes,
        "estado": estado,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "uid": uid,
      };
}
