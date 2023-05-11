import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/salas_mensaje_response.dart';
import 'package:flutter_maps_adv/models/sales_response.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:flutter_maps_adv/resources/services/auth_provider.dart';
import 'package:http/http.dart' as http;

class SalasProvider extends StateStreamableSource<Object?> with ChangeNotifier {
  late Usuario usuarioPara; // TODO: Importante para el chat privado
  late Sala salaSeleccionada;

  final List<Sala> salas = [];

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
    final salaResp = Sala.fromJson(resp.body);
    this.salas.add(salaResp);
    notifyListeners();
    return salaResp;
  }

  @override
  FutureOr<void> close() {
    // TODO: implement close
  }

  @override
  bool get isClosed => false;

  @override
  Object? get state => null;

  @override
  Stream<Object?> get stream => Stream.empty();
}
