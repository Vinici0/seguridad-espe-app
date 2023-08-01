import 'dart:convert';

import 'package:flutter_maps_adv/models/ubicacion.dart';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  bool google;
  bool isActivo;
  bool isPublicacionPendiente;
  bool online;
  bool? isOpenRoom;
  List<String> telefonos;
  List<Ubicacion> ubicacion;
  List<Salas>? salas;
  String createdAt;
  String email;
  String nombre;
  String tokenApp;
  String uid;
  String updatedAt;
  String? img;
  String? telefono;

  Usuario({
    required this.online,
    required this.nombre,
    required this.email,
    this.telefono,
    required this.tokenApp,
    required this.ubicacion,
    required this.uid,
    required this.google,
    this.img,
    this.isOpenRoom,
    this.salas,
    required this.isActivo,
    required this.telefonos,
    required this.createdAt,
    required this.updatedAt,
    required this.isPublicacionPendiente,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        online: json["online"],
        google: json["google"],
        nombre: json["nombre"],
        email: json["email"],
        telefono: json["telefono"],
        img: json["img"],
        createdAt: json["createdAt"],
        isActivo: json["isActivo"],
        updatedAt: json["updatedAt"],
        salas: json["salas"] == null
            ? []
            : List<Salas>.from(json["salas"]!.map((x) => Salas.fromMap(x))),
        isOpenRoom:
            json["isOpenRoom"] != null ? json["isOpenRoom"] as bool : false,
        isPublicacionPendiente: json["isPublicacionPendiente"],
        telefonos: List<String>.from(json["telefonos"].map((x) => x)),
        tokenApp: json["tokenApp"],
        ubicacion: List<Ubicacion>.from(
            json["ubicaciones"].map((x) => Ubicacion.fromMap(x))),
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "online": online ?? false,
        "google": google ?? false,
        "nombre": nombre,
        "email": email,
        "telefono": telefono,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "isOpenRoom": isOpenRoom ?? false,
        "salas": salas == null
            ? []
            : List<dynamic>.from(salas!.map((x) => x.toMap())),
        "isPublicacionPendiente": isPublicacionPendiente ?? false,
        "img": img,
        "isActivo": isActivo ?? false,
        "telefonos": List<dynamic>.from(telefonos.map((x) => x)),
        "tokenApp": tokenApp,
        "ubicaciones": List<dynamic>.from(ubicacion.map((x) => x.toMap())),
        "uid": uid,
      };
}

class Salas {
  String salaId;
  int mensajesNoLeidos;
  dynamic ultimaVezActivo;
  bool isRoomOpen;
  String id;

  Salas({
    required this.salaId,
    required this.mensajesNoLeidos,
    this.ultimaVezActivo,
    required this.isRoomOpen,
    required this.id,
  });

  factory Salas.fromMap(Map<String, dynamic> json) => Salas(
        salaId: json["salaId"],
        mensajesNoLeidos: json["mensajesNoLeidos"],
        ultimaVezActivo: json["ultimaVezActivo"],
        isRoomOpen: json["isRoomOpen"],
        id: json["_id"],
      );

  Map<String, dynamic> toMap() => {
        "salaId": salaId,
        "mensajesNoLeidos": mensajesNoLeidos,
        "ultimaVezActivo": ultimaVezActivo,
        "isRoomOpen": isRoomOpen,
        "_id": id,
      };
}
