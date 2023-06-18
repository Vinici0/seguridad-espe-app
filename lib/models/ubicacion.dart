// To parse this JSON data, do
//
//     final ubicacionResponse = ubicacionResponseFromMap(jsonString);

import 'dart:convert';

UbicacionResponse ubicacionResponseFromMap(String str) =>
    UbicacionResponse.fromMap(json.decode(str));

String ubicacionResponseToMap(UbicacionResponse data) =>
    json.encode(data.toMap());

class UbicacionResponse {
  bool ok;
  List<Ubicacion> ubicacion;

  UbicacionResponse({
    required this.ok,
    required this.ubicacion,
  });

  factory UbicacionResponse.fromMap(Map<String, dynamic> json) =>
      UbicacionResponse(
        ok: json["ok"],
        ubicacion: List<Ubicacion>.from(
            json["ubicaciones"].map((x) => Ubicacion.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "ubicaciones": List<dynamic>.from(ubicacion.map((x) => x.toMap())),
      };
}

class Ubicacion {
  double latitud;
  double longitud;
  String barrio;
  String ciudad;
  String pais;
  bool? estado;
  String? createdAt;
  String? updatedAt;
  String? uid;
  String? parroquia;
  String? referencia;

  Ubicacion({
    required this.latitud,
    required this.longitud,
    required this.barrio,
    required this.ciudad,
    required this.pais,
    this.estado,
    this.createdAt,
    this.updatedAt,
    this.uid,
    this.parroquia,
    this.referencia,
  });

  factory Ubicacion.fromMap(Map<String, dynamic> json) {
    final uid = json.containsKey("uid") ? json["uid"] : json["_id"];
    return Ubicacion(
      latitud: json["latitud"]?.toDouble(),
      longitud: json["longitud"]?.toDouble(),
      barrio: json["barrio"],
      ciudad: json["ciudad"],
      pais: json["pais"],
      estado: json["estado"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      uid: uid.toString(),
      parroquia: json["parroquia"],
      referencia: json["referencia"],
    );
  }

  Map<String, dynamic> toMap() => {
        "latitud": latitud,
        "longitud": longitud,
        "barrio": barrio,
        "ciudad": ciudad,
        "pais": pais,
        "estado": estado,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "uid": uid,
        "parroquia": parroquia,
        "referencia": referencia,
      };
}
