// To parse this JSON data, do
//
//     final publicacionResponse = publicacionResponseFromMap(jsonString);

import 'dart:convert';

PublicacionResponse publicacionResponseFromMap(String str) =>
    PublicacionResponse.fromMap(json.decode(str));

String publicacionResponseToMap(PublicacionResponse data) =>
    json.encode(data.toMap());

class PublicacionResponse {
  bool ok;
  List<Publicacion> publicacion;

  PublicacionResponse({
    required this.ok,
    required this.publicacion,
  });

  factory PublicacionResponse.fromMap(Map<String, dynamic> json) =>
      PublicacionResponse(
        ok: json["ok"],
        publicacion: List<Publicacion>.from(
            json["publicaciones"].map((x) => Publicacion.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "publicaciones": List<dynamic>.from(publicacion.map((x) => x.toMap())),
      };
}

class Publicacion {
  String titulo;
  String contenido;
  String color;
  String ciudad;
  String barrio;
  bool isPublic;
  String usuario;
  List<String>? likes;
  List<String>? imagenes;
  double latitud;
  double longitud;
  List<String>? comentarios;
  String imgAlerta;
  bool isLiked;
  String? createdAt;
  String? updatedAt;
  String? uid;
  String nombreUsuario;
  bool isPublicacionPendiente;
  int? countComentarios;
  int? countLikes;
  String? unidadEducativa;

  Publicacion({
    required this.titulo,
    required this.contenido,
    required this.color,
    required this.ciudad,
    required this.barrio,
    required this.isPublic,
    required this.usuario,
    this.likes,
    this.imagenes,
    required this.latitud,
    required this.longitud,
    this.comentarios,
    required this.imgAlerta,
    required this.isLiked,
    this.createdAt,
    this.updatedAt,
    this.uid,
    this.countComentarios,
    this.countLikes,
    required this.isPublicacionPendiente,
    required this.nombreUsuario,
    this.unidadEducativa,
  });

  factory Publicacion.fromMap(Map<String, dynamic> json) => Publicacion(
        titulo: json["titulo"],
        contenido: json["contenido"],
        color: json["color"],
        ciudad: json["ciudad"],
        isPublicacionPendiente: json["isPublicacionPendiente"],
        barrio: json["barrio"],
        isPublic: json["isPublic"],
        usuario: json["usuario"],
        likes: json["likes"] == null
            ? []
            : List<String>.from(json["likes"]!.map((x) => x)),
        imagenes: json["imagenes"] == null
            ? []
            : List<String>.from(json["imagenes"]!.map((x) => x)),
        latitud: json["latitud"]?.toDouble(),
        longitud: json["longitud"]?.toDouble(),
        comentarios: json["comentarios"] == null
            ? []
            : List<String>.from(json["comentarios"]!.map((x) => x)),
        imgAlerta: json["imgAlerta"],
        isLiked: json["isLiked"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        countComentarios:
            json["comentarios"] != null ? json["comentarios"].length : 0,
        countLikes: json["likes"] != null ? json["likes"].length : 0,
        // json.containsKey("uid") ? json["uid"] : json["_id"],
        uid: json.containsKey("uid") ? json["uid"] : json["_id"],
        nombreUsuario: json["nombreUsuario"],
        unidadEducativa: json["unidadEducativa"],
      );

  Map<String, dynamic> toMap() => {
        "titulo": titulo,
        "contenido": contenido,
        "color": color,
        "ciudad": ciudad,
        "barrio": barrio,
        "isPublic": isPublic,
        "usuario": usuario,
        "likes": likes == null ? [] : List<dynamic>.from(likes!.map((x) => x)),
        "imagenes":
            imagenes == null ? [] : List<dynamic>.from(imagenes!.map((x) => x)),
        "latitud": latitud,
        "longitud": longitud,
        "comentarios": comentarios == null
            ? []
            : List<dynamic>.from(comentarios!.map((x) => x)),
        "imgAlerta": imgAlerta,
        "isLiked": isLiked,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "isPublicacionPendiente": isPublicacionPendiente,
        "uid": uid,
        "nombreUsuario": nombreUsuario,
        "unidadEducativa": unidadEducativa,
      };

  Publicacion copyWith({
    String? uid,
    String? titulo,
    String? contenido,
    String? color,
    String? ciudad,
    String? barrio,
    bool? isPublic,
    String? usuario,
    List<String>? likes,
    List<String>? imagenes,
    double? latitud,
    double? longitud,
    List<String>? comentarios,
    String? imgAlerta,
    bool? isLiked,
    String? createdAt,
    bool? isPublicacionPendiente,
    String? updatedAt,
    int? countLikes,
    int? countComentarios,
    String? usuarioNombre,
    String? unidadEducativa,
  }) {
    return Publicacion(
      uid: uid ?? this.uid,
      titulo: titulo ?? this.titulo,
      contenido: contenido ?? this.contenido,
      color: color ?? this.color,
      ciudad: ciudad ?? this.ciudad,
      barrio: barrio ?? this.barrio,
      isPublic: isPublic ?? this.isPublic,
      usuario: usuario ?? this.usuario,
      likes: likes ?? this.likes,
      imagenes: imagenes ?? this.imagenes,
      latitud: latitud ?? this.latitud,
      isPublicacionPendiente:
          isPublicacionPendiente ?? this.isPublicacionPendiente,
      longitud: longitud ?? this.longitud,
      comentarios: comentarios ?? this.comentarios,
      imgAlerta: imgAlerta ?? this.imgAlerta,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      countComentarios: countComentarios ?? this.countComentarios,
      countLikes: countLikes ?? this.countLikes,
      unidadEducativa: unidadEducativa ?? this.unidadEducativa,
      updatedAt: updatedAt ?? this.updatedAt,
      nombreUsuario: usuarioNombre ?? this.nombreUsuario,
    );
  }
}
