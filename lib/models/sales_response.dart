// To parse this JSON data, do
//
//     final salesResponse = salesResponseFromMap(jsonString);

import 'dart:convert';

class SalesResponse {
  SalesResponse({
    required this.ok,
    required this.salas,
    required this.totalUsuarios,
  });

  bool ok;
  List<Sala> salas;
  int totalUsuarios;

  factory SalesResponse.fromJson(String str) =>
      SalesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SalesResponse.fromMap(Map<String, dynamic> json) => SalesResponse(
        ok: json["ok"],
        salas: List<Sala>.from(json["salas"].map((x) => Sala.fromMap(x))),
        totalUsuarios: json["totalUsuarios"],
      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "salas": List<dynamic>.from(salas.map((x) => x.toMap())),
        "totalUsuarios": totalUsuarios,
      };
}

class Sala {
  Sala({
    required this.nombre,
    required this.uid,
  });

  String nombre;
  String uid;

  factory Sala.fromJson(String str) => Sala.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Sala.fromMap(Map<String, dynamic> json) => Sala(
        nombre: json["nombre"],
        uid: json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "uid": uid,
      };
}
