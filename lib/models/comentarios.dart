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
  Usuario usuario;
  String publicacion;
  String estado;
  String createdAt;
  String updatedAt;
  String uid;
  List<String>? likes;

  Comentario({
    required this.contenido,
    required this.usuario,
    required this.publicacion,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
    this.likes,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) => Comentario(
        contenido: json["contenido"],
        usuario: Usuario.fromJson(json["usuario"]),
        publicacion: json["publicacion"],
        estado: json["estado"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        uid: json["uid"],
        likes: json["likes"] == null
            ? []
            : List<String>.from(json["likes"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "contenido": contenido,
        "usuario": usuario.toJson(),
        "publicacion": publicacion,
        "estado": estado,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "uid": uid,
        "likes": likes == null ? [] : List<dynamic>.from(likes!.map((x) => x)),
      };
}

class Usuario {
  String id;
  String nombre;
  String? img;
  bool google;
  Usuario({
    required this.id,
    required this.nombre,
    this.img,
    this.google = false,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["_id"],
        nombre: json["nombre"],
        img: json["img"],
        google: json["google"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
        "img": img,
        "google": google,
      };
}
