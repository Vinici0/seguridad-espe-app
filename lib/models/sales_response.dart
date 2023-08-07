// To parse this JSON data, do
//
//     final salesResponse = salesResponseFromMap(jsonString);

import 'dart:convert';

import 'package:flutter_maps_adv/models/mensajes_response.dart';

class SalesResponse {
  SalesResponse({
    required this.ok,
    required this.salas,
  });

  bool ok;
  List<Sala> salas;

  factory SalesResponse.fromJson(String str) =>
      SalesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SalesResponse.fromMap(Map<String, dynamic> json) => SalesResponse(
        ok: json["ok"],
        salas: List<Sala>.from(json["salas"].map((x) => Sala.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "salas": List<dynamic>.from(salas.map((x) => x.toMap())),
      };
}

Sala salaFromMap(String str) => Sala.fromMap(json.decode(str));

String salaToMap(Sala data) => json.encode(data.toMap());

class Sala {
  int totalUsuarios;
  int? mensajesNoLeidos;
  List<Mensaje>? mensajes;
  List<String>? usuarios;
  String codigo;
  String color;
  String nombre;
  String propietario;
  String uid;
  String? idUsuario;

  Sala({
    required this.nombre,
    required this.codigo,
    required this.color,
    required this.uid,
    this.idUsuario,
    required this.propietario,
    this.mensajesNoLeidos,
    this.usuarios,
    this.mensajes,
    required this.totalUsuarios,
  });

  factory Sala.fromMap(Map<String, dynamic> json) {
    try {
      return Sala(
        nombre: json["nombre"],
        uid: json.containsKey("uid") ? json["uid"] : json["_id"],
        codigo: json["codigo"],
        totalUsuarios: json["totalUsuarios"],
        color: json["color"],
        idUsuario: json["idUsuario"],
        mensajes: json["mensajes"] == null
            ? []
            : List<Mensaje>.from(json["mensajes"]!.map((x) => x)),
        usuarios: json["usuarios"] == null
            ? []
            : List<String>.from(json["usuarios"].map((x) => x)),
        propietario: json["propietario"],
        mensajesNoLeidos: json["mensajesNoLeidos"],
      );
    } catch (e) {
      // Manejo de excepciones aquí, si es necesario
      print("Error al convertir el JSON a Sala: $e");
      return Sala(
        nombre: '',
        codigo: '',
        color: '',
        uid: '',
        propietario: '',
        totalUsuarios: 0,
      );
    }
  }

  Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "codigo": codigo,
        "_id": uid,
        "color": color,
        "idUsuario": idUsuario,
        "mensajes":
            mensajes == null ? [] : List<Mensaje>.from(mensajes!.map((x) => x)),
        "usuarios":
            usuarios == null ? [] : List<dynamic>.from(usuarios!.map((x) => x)),
        "propietario": propietario,
        "mensajesNoLeidos": mensajesNoLeidos,
        "totalUsuarios": totalUsuarios,
      };
}
