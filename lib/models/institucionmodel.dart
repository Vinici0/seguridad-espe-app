// To parse this JSON data, do
//
//     final institucionReponse = institucionReponseFromJson(jsonString);

import 'dart:convert';

InstitucionReponse institucionReponseFromJson(String str) =>
    InstitucionReponse.fromJson(json.decode(str));

String institucionReponseToJson(InstitucionReponse data) =>
    json.encode(data.toJson());

class InstitucionReponse {
  bool ok;
  String msg;
  List<Institucione> instituciones;

  InstitucionReponse({
    required this.ok,
    required this.msg,
    required this.instituciones,
  });

  factory InstitucionReponse.fromJson(Map<String, dynamic> json) =>
      InstitucionReponse(
        ok: json["ok"],
        msg: json["msg"],
        instituciones: List<Institucione>.from(
            json["instituciones"].map((x) => Institucione.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "instituciones":
            List<dynamic>.from(instituciones.map((x) => x.toJson())),
      };
}

class Institucione {
  String id;
  String nombre;
  String direccion;
  String tipo;
  String? descripcion;
  int v;

  Institucione({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.tipo,
    this.descripcion,
    required this.v,
  });

  factory Institucione.fromJson(Map<String, dynamic> json) {
    try {
      return Institucione(
        id: json["_id"],
        nombre: json["nombre"],
        direccion: json["direccion"],
        tipo: json["tipo"],
        descripcion: json["descripcion"],
        v: json["__v"],
      );
    } catch (e) {
      // Manejar errores aquí
      print("Error al analizar el JSON en Institucione.fromJson: $e");

      // Identificar el campo problemático
      if (e is FormatException) {
        final fieldWithError = e.source;
        print("Campo problemático: $fieldWithError");
      }

      return Institucione(
          id: "",
          nombre: "",
          direccion: "",
          tipo: "",
          v: 1); // Devolver un objeto vacío o null en caso de error, o lanzar una excepción si es necesario.
    }
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
        "direccion": direccion,
        "tipo": tipo,
        "descripcion": descripcion,
        "__v": v,
      };
}
