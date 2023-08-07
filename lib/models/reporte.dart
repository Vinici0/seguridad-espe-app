import 'package:flutter/material.dart';

class Reporte {
  String tipo;
  String icon;
  String color;
  bool isSvg;

  Reporte(
      {required this.tipo,
      required this.icon,
      required this.color,
      this.isSvg = true});

  factory Reporte.fromJson(Map<String, dynamic> json) {
    return Reporte(
        tipo: json['tipo'],
        icon: json['icon'],
        color: json['color'],
        isSvg: true);
  }

  Map<String, dynamic> toJson() =>
      {'tipo': tipo, 'icon': icon, 'color': color, 'isSvg': isSvg};
}
