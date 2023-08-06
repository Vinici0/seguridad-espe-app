import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/notification.dart';
import 'package:flutter_maps_adv/resources/services/auth_provider.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  //localhost:3000/api/notificacion
  Future<List<Notificacione>> getNotificaciones() async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/notificacion');

      final resp = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() as String,
        },
      );

      final decodedData = json.decode(resp.body);
      final notificacionResp = NotificacionReponse.fromJson(decodedData);
      return notificacionResp.notificaciones;
    } catch (e) {
      print('Error: $e');
      return []; // Return an empty list in case of an error
    }
  }

  //router.put("/:id", validarJWT, marcarNotificacionComoLeida);
  Future<bool> marcarNotificacionComoLeida(String id) async {
    try {
      print('id: $id');
      final uri = Uri.parse('${Environment.apiUrl}/notificacion/$id');

      final resp = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() as String,
        },
      );
      return true;
    } catch (e) {
      print('Error: $e');
      return false; // Return an empty list in case of an error
    }
  }
}
