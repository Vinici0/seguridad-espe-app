import 'dart:convert';

import 'package:flutter_maps_adv/models/ubicacion.dart';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  bool google;
  bool online;
  List<String> telefonos;
  List<Ubicacion> ubicacion;
  String email;
  String nombre;
  String? telefono;
  String tokenApp;
  String uid;
  String? img;
  String createdAt;
  String updatedAt;
  bool? isOpenRoom;

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
    required this.telefonos,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        online: json["online"],
        google: json["google"],
        nombre: json["nombre"],
        email: json["email"],
        telefono: json["telefono"],
        img: json["img"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        isOpenRoom: json["isOpenRoom"],
        telefonos: List<String>.from(json["telefonos"].map((x) => x)),
        tokenApp: json["tokenApp"],
        ubicacion: List<Ubicacion>.from(
            json["ubicaciones"].map((x) => Ubicacion.fromMap(x))),
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "online": online,
        "google": google,
        "nombre": nombre,
        "email": email,
        "telefono": telefono,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "isOpenRoom": isOpenRoom,
        "img": img,
        "telefonos": List<dynamic>.from(telefonos.map((x) => x)),
        "tokenApp": tokenApp,
        "ubicaciones": List<dynamic>.from(ubicacion.map((x) => x.toMap())),
        "uid": uid,
      };

  //getters y setters
  bool getOnline() {
    return online;
  }

  void setOnline(bool online) {
    this.online = online;
  }

  String getNombre() {
    return nombre;
  }

  void setNombre(String nombre) {
    this.nombre = nombre;
  }

  String getEmail() {
    return email;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setTelefono(String telefono) {
    this.telefono = telefono;
  }

  String getTokenApp() {
    return tokenApp;
  }

  void setTokenApp(String tokenApp) {
    this.tokenApp = tokenApp;
  }

  List<Ubicacion> getUbicacion() {
    return ubicacion;
  }

  void setUbicacion(List<Ubicacion> ubicacion) {
    this.ubicacion = ubicacion;
  }

  String getUid() {
    return uid;
  }

  void setUid(String uid) {
    this.uid = uid;
  }

  List<String> getTelefonos() {
    return telefonos;
  }

  void setTelefonos(List<String> telefonos) {
    this.telefonos = telefonos;
  }

  @override
  String toString() {
    return 'Usuario{online: $online, nombre: $nombre, email: $email, uid: $uid}';
  }
}
