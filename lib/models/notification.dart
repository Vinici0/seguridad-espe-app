// To parse this JSON data, do
//
//     final notificacionReponse = notificacionReponseFromJson(jsonString);

import 'dart:convert';

NotificacionReponse notificacionReponseFromJson(String str) =>
    NotificacionReponse.fromJson(json.decode(str));

String notificacionReponseToJson(NotificacionReponse data) =>
    json.encode(data.toJson());

class NotificacionReponse {
  bool ok;
  List<Notificacione> notificaciones;

  NotificacionReponse({
    required this.ok,
    required this.notificaciones,
  });

  factory NotificacionReponse.fromJson(Map<String, dynamic> json) =>
      NotificacionReponse(
        ok: json["ok"],
        notificaciones: List<Notificacione>.from(
            json["notificaciones"].map((x) => Notificacione.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "notificaciones":
            List<dynamic>.from(notificaciones.map((x) => x.toJson())),
      };
}

class Notificacione {
  String tipo;
  Usuario usuario;
  Publicacion? publicacion;
  String mensaje;
  List<LeidaPorUsuario> leidaPorUsuario;
  DateTime createdAt;
  DateTime updatedAt;
  String uid;

  Notificacione({
    required this.tipo,
    required this.usuario,
    this.publicacion,
    required this.mensaje,
    required this.leidaPorUsuario,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });

  factory Notificacione.fromJson(Map<String, dynamic> json) => Notificacione(
        tipo: json["tipo"],
        usuario: Usuario.fromJson(json["usuario"]),
        publicacion: json["publicacion"] == null
            ? null
            : Publicacion.fromJson(json["publicacion"]),
        mensaje: json["mensaje"],
        leidaPorUsuario: List<LeidaPorUsuario>.from(
            json["leidaPorUsuario"].map((x) => LeidaPorUsuario.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "tipo": tipo,
        "usuario": usuario.toJson(),
        "publicacion": publicacion?.toJson(),
        "mensaje": mensaje,
        "leidaPorUsuario":
            List<dynamic>.from(leidaPorUsuario.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "uid": uid,
      };
}

class LeidaPorUsuario {
  String usuario;
  bool leida;
  String id;

  LeidaPorUsuario({
    required this.usuario,
    required this.leida,
    required this.id,
  });

  factory LeidaPorUsuario.fromJson(Map<String, dynamic> json) =>
      LeidaPorUsuario(
        usuario: json["usuario"],
        leida: json["leida"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "usuario": usuario,
        "leida": leida,
        "_id": id,
      };
}

class Publicacion {
  String id;
  String titulo;
  String contenido;
  String color;
  String ciudad;
  String barrio;
  bool isPublic;
  String usuario;
  String nombreUsuario;
  List<dynamic> imagenes;
  double latitud;
  double longitud;
  String imgAlerta;

  Publicacion({
    required this.id,
    required this.titulo,
    required this.contenido,
    required this.color,
    required this.ciudad,
    required this.barrio,
    required this.isPublic,
    required this.usuario,
    required this.nombreUsuario,
    required this.imagenes,
    required this.latitud,
    required this.longitud,
    required this.imgAlerta,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) => Publicacion(
        id: json["_id"],
        titulo: json["titulo"],
        contenido: json["contenido"],
        color: json["color"],
        ciudad: json["ciudad"],
        barrio: json["barrio"],
        isPublic: json["isPublic"],
        usuario: json["usuario"],
        nombreUsuario: json["nombreUsuario"],
        imagenes: List<dynamic>.from(json["imagenes"].map((x) => x)),
        latitud: json["latitud"]?.toDouble(),
        longitud: json["longitud"]?.toDouble(),
        imgAlerta: json["imgAlerta"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "titulo": titulo,
        "contenido": contenido,
        "color": color,
        "ciudad": ciudad,
        "barrio": barrio,
        "isPublic": isPublic,
        "usuario": usuario,
        "nombreUsuario": nombreUsuario,
        "imagenes": List<dynamic>.from(imagenes.map((x) => x)),
        "latitud": latitud,
        "longitud": longitud,
        "imgAlerta": imgAlerta,
      };
}

class Usuario {
  String id;
  String nombre;
  String email;
  String telefono;
  String? img;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
    this.img,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["_id"],
        nombre: json["nombre"],
        email: json["email"],
        telefono: json["telefono"],
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
        "email": email,
        "telefono": telefono,
        "img": img,
      };
}
