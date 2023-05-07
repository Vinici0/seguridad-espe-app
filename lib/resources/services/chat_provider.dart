import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/mensajes_response.dart';
import 'package:flutter_maps_adv/models/salas_mensaje_response.dart';
import 'package:flutter_maps_adv/models/sales_response.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:flutter_maps_adv/resources/services/auth_provider.dart';
import 'package:http/http.dart' as http;

class ChatProvider extends StateStreamableSource<Object?> with ChangeNotifier {
  late Usuario usuarioPara; // TODO: Importante para el chat privado
  late Sala salaSeleccionada;

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
    return salesResp.salas;
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
