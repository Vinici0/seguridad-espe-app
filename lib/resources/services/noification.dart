import 'dart:async';
import 'dart:convert';

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
}
