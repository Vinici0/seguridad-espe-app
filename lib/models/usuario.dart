import 'dart:convert';

import 'package:flutter_maps_adv/models/ubicacion.dart';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  bool google;
  bool isActivo;
  bool isPublicacionPendiente;
  bool isSalasPendiente;
  bool online;
  bool? isOpenRoom;
  List<String> telefonos;
  List<Ubicacion> ubicacion;
  List<Salas>? salas;
  String createdAt;
  String email;
  String nombre;
  String? tokenApp;
  String uid;
  String updatedAt;
  String? img;
  String? telefono;
  bool isNotificacionesPendiente;

  Usuario({
    required this.online,
    required this.nombre,
    required this.email,
    this.telefono,
    this.tokenApp,
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
    required this.isSalasPendiente,
    required this.isNotificacionesPendiente,
  });
  factory Usuario.fromJson(Map<String, dynamic> json) {
    try {
      return Usuario(
        online: json["online"],
        google: json["google"],
        nombre: json["nombre"],
        email: json["email"],
        telefono: json["telefono"],
        img: json["img"],
        createdAt: json["createdAt"],
        isActivo: json["isActivo"],
        updatedAt: json["updatedAt"],
        isNotificacionesPendiente: json["isNotificacionesPendiente"],
        isSalasPendiente: json["isSalasPendiente"],
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
    } catch (e) {
      print("Error al convertir JSON a Usuario: $e");

      return Usuario(
        online: false,
        google: false,
        nombre: '',
        email: '',
        telefono: '',
        img: '',
        createdAt: '',
        isActivo: false,
        updatedAt: '',
        isNotificacionesPendiente: false,
        isSalasPendiente: false,
        salas: [],
        isOpenRoom: false,
        isPublicacionPendiente: false,
        telefonos: [],
        tokenApp: '',
        ubicacion: [],
        uid: '',
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "online": online,
        "google": google,
        "nombre": nombre,
        "email": email,
        "telefono": telefono,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "isOpenRoom": isOpenRoom ?? false,
        "isNotificacionesPendiente": isNotificacionesPendiente,
        "salas": salas == null
            ? []
            : List<dynamic>.from(salas!.map((x) => x.toMap())),
        "isPublicacionPendiente": isPublicacionPendiente,
        "img": img,
        "isActivo": isActivo,
        "telefonos": List<dynamic>.from(telefonos.map((x) => x)),
        "tokenApp": tokenApp,
        "ubicaciones": List<dynamic>.from(ubicacion.map((x) => x.toMap())),
        "uid": uid,
        "isSalasPendiente": isSalasPendiente,
      };

  Usuario copyWith({
    bool? online,
    bool? google,
    String? nombre,
    String? email,
    String? telefono,
    String? img,
    String? createdAt,
    bool? isActivo,
    String? updatedAt,
    bool? isNotificacionesPendiente,
    bool? isSalasPendiente,
    List<Salas>? salas,
    bool? isOpenRoom,
    bool? isPublicacionPendiente,
    List<String>? telefonos,
    String? tokenApp,
    List<Ubicacion>? ubicacion,
    String? uid,
  }) {
    return Usuario(
      online: online ?? this.online,
      google: google ?? this.google,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      img: img ?? this.img,
      createdAt: createdAt ?? this.createdAt,
      isActivo: isActivo ?? this.isActivo,
      updatedAt: updatedAt ?? this.updatedAt,
      isNotificacionesPendiente:
          isNotificacionesPendiente ?? this.isNotificacionesPendiente,
      isSalasPendiente: isSalasPendiente ?? this.isSalasPendiente,
      salas: salas ?? this.salas,
      isOpenRoom: isOpenRoom ?? this.isOpenRoom,
      isPublicacionPendiente:
          isPublicacionPendiente ?? this.isPublicacionPendiente,
      telefonos: telefonos ?? this.telefonos,
      tokenApp: tokenApp ?? this.tokenApp,
      ubicacion: ubicacion ?? this.ubicacion,
      uid: uid ?? this.uid,
    );
  }
}

class Salas {
  String salaId;
  int mensajesNoLeidos;
  DateTime? ultimaVezActivo;
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
        ultimaVezActivo: json["ultimaVezActivo"] == null
            ? null
            : DateTime.parse(json["ultimaVezActivo"]),
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
