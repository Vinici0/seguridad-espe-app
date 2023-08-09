// To parse this JSON data, do
//
//     final notificacionReponse = notificacionReponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_maps_adv/models/publication.dart';

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
  UsuarioRemitente usuarioRemitente;
  Publicacion? publicacion;
  String mensaje;
  DateTime createdAt;
  DateTime updatedAt;
  String uid;
  double latitud;
  double longitud;
  String usuario;
  bool isLeida;

  Notificacione({
    required this.tipo,
    required this.usuarioRemitente,
    this.publicacion,
    required this.usuario,
    required this.mensaje,
    required this.latitud,
    required this.longitud,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
    required this.isLeida,
  });

  factory Notificacione.fromJson(Map<String, dynamic> json) {
    try {
      return Notificacione(
        tipo: json["tipo"],
        usuario: json["usuario"],
        usuarioRemitente: UsuarioRemitente.fromJson(json["usuarioRemitente"]),
        publicacion: json["publicacion"] == null
            ? null
            : Publicacion.fromMap(json["publicacion"]),
        mensaje: json["mensaje"],
        createdAt: DateTime.parse(json["createdAt"]),
        latitud: json["latitud"]?.toDouble(),
        longitud: json["longitud"]?.toDouble(),
        updatedAt: DateTime.parse(json["updatedAt"]),
        isLeida: json["isLeida"],
        uid: json["uid"],
      );
    } catch (e) {
      print("Error en la decodificación de Notificacione: $e");
      rethrow; // Relanza la excepción para que se propague más arriba
    }
  }

  Map<String, dynamic> toJson() => {
        "tipo": tipo,
        "usuarioRemitente": usuarioRemitente.toJson(),
        "publicacion": publicacion?.toMap(),
        "mensaje": mensaje,
        "usuario": usuario,
        "latitud": latitud,
        "longitud": longitud,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "isLeida": isLeida,
        "uid": uid,
      };

  copyWith({
    String? tipo,
    UsuarioRemitente? usuarioRemitente,
    Publicacion? publicacion,
    String? mensaje,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? uid,
    double? latitud,
    double? longitud,
    String? usuario,
    bool? isLeida,
  }) {
    return Notificacione(
      tipo: tipo ?? this.tipo,
      usuarioRemitente: usuarioRemitente ?? this.usuarioRemitente,
      publicacion: publicacion ?? this.publicacion,
      mensaje: mensaje ?? this.mensaje,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      uid: uid ?? this.uid,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      usuario: usuario ?? this.usuario,
      isLeida: isLeida ?? this.isLeida,
    );
  }
}

class UsuarioRemitente {
  String id;
  String nombre;
  String email;
  String telefono;
  String? img;
  bool google;

  UsuarioRemitente({
    required this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.google,
    this.img,
  });

  factory UsuarioRemitente.fromJson(Map<String, dynamic> json) {
    try {
      return UsuarioRemitente(
        id: json["_id"],
        nombre: json["nombre"],
        email: json["email"],
        google: json["google"],
        telefono: json["telefono"],
        img: json["img"],
      );
    } catch (e) {
      print("Error en la decodificación de UsuarioRemitente: $e");
      rethrow; // Relanza la excepción para que se propague más arriba
    }
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
        "email": email,
        "google": google,
        "telefono": telefono,
        "img": img,
      };
}
