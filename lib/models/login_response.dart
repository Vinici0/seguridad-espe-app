// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_maps_adv/models/usuario.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool ok;
  Usuario usuario;
  String token;

  LoginResponse({
    required this.ok,
    required this.usuario,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final token = json["token"] as String? ?? '';

    return LoginResponse(
      ok: json["ok"] ?? false, // Use the default value (false) if ok is null
      usuario: Usuario.fromJson(json["usuario"]),
      token: token,
    );
  }

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuario": usuario.toJson(),
        "token": token,
      };
}
