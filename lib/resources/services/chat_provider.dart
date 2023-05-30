import 'dart:async';
import 'dart:convert';

import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/salas_mensaje_response.dart';
import 'package:flutter_maps_adv/models/sales_response.dart';
import 'package:flutter_maps_adv/resources/services/auth_provider.dart';
import 'package:http/http.dart' as http;

class ChatProvider {
  Future<List<MensajesSala>> getChatSala(String salaID) async {
    final uri =
        Uri.parse('${Environment.apiUrl}/mensajes/get-mensaje-by-room/$salaID');
    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken() as String,
    });
    final mensajesResp = salasMensajeResponseFromMap(resp.body);
    if (mensajesResp.mensajesSala.isEmpty) return [];
    return mensajesResp.mensajesSala;
  }

  Future<List<Sala>> getSalesAll() async {
    final uri = Uri.parse('${Environment.apiUrl}/salas/obtener-salas-usuario');
    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken() as String,
    });
    final salesResp = SalesResponse.fromJson(resp.body);
    return salesResp.salas;
  }

  Future<Sala> createSala(String nombre) async {
    final uri = Uri.parse('${Environment.apiUrl}/salas');

    final resp = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() as String,
        },
        body: '{"nombre":"$nombre"}');
    final decodedData = json.decode(resp.body);
    final salaResp = Sala.fromMap(decodedData['sala']);
    return salaResp;
  }

  Future<Sala> joinSala(String codigo) async {
    final uri = Uri.parse('${Environment.apiUrl}/salas/unir-sala');

    final resp = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() as String,
        },
        body: '{"codigo":"$codigo"}');

    final decodedData = json.decode(resp.body);
    final salaResp = Sala.fromMap(decodedData['sala']);
    return salaResp;
  }
}
