import 'dart:convert';

import 'package:flutter_maps_adv/models/ubicacion.dart';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  bool online;
  String nombre;
  String email;
  String tokenApp;
  List<Ubicacion> ubicacion;
  String uid;
  String? telefono;

  Usuario({
    required this.online,
    required this.nombre,
    required this.email,
    required this.tokenApp,
    required this.ubicacion,
    required this.uid,
    this.telefono,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        online: json["online"],
        nombre: json["nombre"],
        email: json["email"],
        telefono: json["telefono"],
        tokenApp: json["tokenApp"],
        ubicacion: List<Ubicacion>.from(
            json["ubicaciones"].map((x) => Ubicacion.fromMap(x))),
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "online": online,
        "nombre": nombre,
        "email": email,
        "telefono": telefono,
        "tokenApp": tokenApp,
        "ubicaciones": List<dynamic>.from(ubicacion.map((x) => x.toMap())),
        "uid": uid,
      };

  //getters y setters
  get getNombre => nombre;

  void setNombre(String? nombre) {
    this.nombre = nombre!;
  }

  get getEmail => email;

  void setEmail(String? email) {
    this.email = email!;
  }

  get getUid => uid;

  void setUid(String? uid) {
    this.uid = uid!;
  }

  get getOnline => online;

  void setOnline(bool? online) {
    this.online = online!;
  }

  @override
  String toString() {
    return 'Usuario{online: $online, nombre: $nombre, email: $email, uid: $uid}';
  }
}
