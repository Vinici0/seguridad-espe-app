import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/salas_mensaje_response.dart';
import 'package:flutter_maps_adv/models/sales_response.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:flutter_maps_adv/resources/services/auth_provider.dart';
import 'package:http/http.dart' as http;

class ChatProvider extends StateStreamableSource<Object?> {
  late Usuario usuarioPara; // TODO: Importante para el chat privado
  late Sala salaSeleccionada;

  List<Sala> salas = [];

  late final StreamController<List<Sala>> _salasController =
      StreamController<List<Sala>>.broadcast(sync: true);

  Stream<List<Sala>> get salasStream => _salasController.stream;

  ChatProvider() {
    this.getSalesAll();
  }

  Future<List<MensajesSala>> getChatSala(String salaID) async {
    final uri =
        Uri.parse('${Environment.apiUrl}/mensajes/get-mensaje-by-room/$salaID');
    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken() as String,
    });
    final mensajesResp = salasMensajeResponseFromMap(resp.body);
    return mensajesResp.mensajesSala;
  }

  Future<List<Sala>> getSalesAll() async {
    final uri = Uri.parse('${Environment.apiUrl}/salas/obtener-salas-usuario');
    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken() as String,
    });
    final salesResp = SalesResponse.fromJson(resp.body);

    this.salas.addAll(salesResp.salas);
    _salasController.add(salesResp.salas);
    return salesResp.salas;
  }

  //localhost:3000/api/salas
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
    this.salas.add(salaResp);
    _salasController.add(this.salas);
    return salaResp;
  }

  //Unir a sala
  Future<Sala> unirSala(String codigo) async {
    final uri = Uri.parse('${Environment.apiUrl}/salas/unir-sala');

    final resp = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() as String,
        },
        body: '{"codigo":"$codigo"}');

    final decodedData = json.decode(resp.body);
    final salaResp = Sala.fromMap(decodedData['sala']);
    this.salas.add(salaResp);
    _salasController.add(this.salas);
    return salaResp;
  }

  @override
  FutureOr<void> close() {
    _salasController.close();
  }

  @override
  bool get isClosed => _salasController.isClosed;

  @override
  Object? get state => null;

  @override
  Stream<Object?> get stream => _salasController.stream;
}
