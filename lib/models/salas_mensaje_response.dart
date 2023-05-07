// To parse this JSON data, do
//
//     final salasMensajeResponse = salasMensajeResponseFromMap(jsonString);

import 'dart:convert';

SalasMensajeResponse salasMensajeResponseFromMap(String str) =>
    SalasMensajeResponse.fromMap(json.decode(str));

String salasMensajeResponseToMap(SalasMensajeResponse data) =>
    json.encode(data.toMap());

class SalasMensajeResponse {
  bool ok;
  List<MensajesSala> mensajesSala;

  SalasMensajeResponse({
    required this.ok,
    required this.mensajesSala,
  });

  factory SalasMensajeResponse.fromMap(Map<String, dynamic> json) =>
      SalasMensajeResponse(
        ok: json["ok"],
        mensajesSala: List<MensajesSala>.from(
            json["mensajesSala"].map((x) => MensajesSala.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "mensajesSala": List<dynamic>.from(mensajesSala.map((x) => x.toMap())),
      };
}

class MensajesSala {
  String id;
  String mensaje;
  String usuario;
  String createdAt;
  String updatedAt;
  int v;
  String nombre;

  MensajesSala({
    required this.id,
    required this.mensaje,
    required this.usuario,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.nombre,
  });

  factory MensajesSala.fromMap(Map<String, dynamic> json) => MensajesSala(
        id: json["_id"],
        mensaje: json["mensaje"],
        usuario: json["usuario"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "mensaje": mensaje,
        "usuario": usuario,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
        "nombre": nombre,
      };
}
