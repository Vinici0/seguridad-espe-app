// To parse this JSON data, do
//
//     final ubicacionResponse = ubicacionResponseFromMap(jsonString);

import 'dart:convert';

UbicacionResponse ubicacionResponseFromMap(String str) =>
    UbicacionResponse.fromMap(json.decode(str));

String ubicacionResponseToMap(UbicacionResponse data) =>
    json.encode(data.toMap());

class UbicacionResponse {
  List<Ubicacion> ubicacion;

  UbicacionResponse({
    required this.ubicacion,
  });

  factory UbicacionResponse.fromMap(Map<String, dynamic> json) =>
      UbicacionResponse(
        ubicacion: List<Ubicacion>.from(
            json["ubicaciones"].map((x) => Ubicacion.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "ubicaciones": List<dynamic>.from(ubicacion.map((x) => x.toMap())),
      };
}

class Ubicacion {
  double latitud;
  double longitud;
  String barrio;
  String ciudad;
  String pais;
  bool estado;
  String createdAt;
  String updatedAt;
  String uid;
  String? referencia;
  String? parroquia;

  Ubicacion({
    required this.latitud,
    required this.longitud,
    required this.barrio,
    required this.ciudad,
    required this.pais,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
    this.referencia,
    this.parroquia,
  });

  factory Ubicacion.fromMap(Map<String, dynamic> json) => Ubicacion(
        latitud: json["latitud"]?.toDouble(),
        longitud: json["longitud"]?.toDouble(),
        barrio: json["barrio"],
        ciudad: json["ciudad"],
        pais: json["pais"],
        estado: json["estado"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        uid: json["uid"],
        referencia: json["referencia"],
        parroquia: json["parroquia"],
      );

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
        "referencia": referencia,
        "parroquia": parroquia,
      };
}
