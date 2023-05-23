// To parse this JSON data, do
//
//     final publicacionesResponse = publicacionesResponseFromMap(jsonString);

import 'dart:convert';

PublicacionesResponse publicacionesResponseFromMap(String str) =>
    PublicacionesResponse.fromMap(json.decode(str));

String publicacionesResponseToMap(PublicacionesResponse data) =>
    json.encode(data.toMap());

class PublicacionesResponse {
  bool ok;
  Publicacion publicacion;

  PublicacionesResponse({
    required this.ok,
    required this.publicacion,
  });

  factory PublicacionesResponse.fromMap(Map<String, dynamic> json) =>
      PublicacionesResponse(
        ok: json["ok"],
        publicacion: Publicacion.fromMap(json["publicacion"]),
      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "publicacion": publicacion.toMap(),
      };
}

class Publicacion {
  bool isPublic;
  int? likes;
  List<String>? archivo;
  List<dynamic>? comentarios;
  bool isLiked;
  String titulo;
  String contenido;
  String color;
  String ciudad;
  String barrio;
  String usuario;
  String imgAlerta;
  double latitud;
  double longitud;
  String? createdAt;
  String? updatedAt;
  String? uid;

  Publicacion({
    required this.barrio,
    required this.ciudad,
    required this.color,
    required this.contenido,
    this.createdAt,
    required this.imgAlerta,
    required this.isLiked,
    required this.isPublic,
    required this.latitud,
    this.likes,
    required this.longitud,
    required this.titulo,
    this.uid,
    required this.usuario,
    this.comentarios,
    this.archivo,
    this.updatedAt,
  });

  factory Publicacion.fromMap(Map<String, dynamic> json) => Publicacion(
        isPublic: json["isPublic"],
        likes: json["likes"],
        archivo: json["imagenes"] != null
            ? List<String>.from(json["imagenes"].map((x) => x))
            : null,
        comentarios: List<dynamic>.from(json["comentarios"].map((x) => x)),
        isLiked: json["isLiked"],
        titulo: json["titulo"],
        contenido: json["contenido"],
        color: json["color"],
        ciudad: json["ciudad"],
        barrio: json["barrio"],
        usuario: json["usuario"],
        imgAlerta: json["imgAlerta"],
        latitud: json["latitud"]?.toDouble(),
        longitud: json["longitud"]?.toDouble(),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        uid: json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "isPublic": isPublic,
        "likes": likes,
        "imagenes":
            archivo != null ? List<dynamic>.from(archivo!.map((x) => x)) : null,
        "comentarios": comentarios,
        "isLiked": isLiked,
        "titulo": titulo,
        "contenido": contenido,
        "color": color,
        "ciudad": ciudad,
        "barrio": barrio,
        "usuario": usuario,
        "imgAlerta": imgAlerta,
        "latitud": latitud,
        "longitud": longitud,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "uid": uid,
      };
}
