import 'dart:async';
import 'dart:convert';

import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/salas_mensaje_response.dart';
import 'package:flutter_maps_adv/models/sales_response.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:flutter_maps_adv/models/usuarios_response.dart';
import 'package:flutter_maps_adv/resources/services/auth_provider.dart';
import 'package:http/http.dart' as http;

class ChatProvider {
  Future<List<MensajesSala>> getChatSala(
      {required String salaID, int next = 0}) async {
    try {
      final uri = Uri.parse(
          '${Environment.apiUrl}/mensajes/get-mensaje-by-room/$salaID?desde=$next');
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() as String,
      });
      final mensajesResp = salasMensajeResponseFromMap(resp.body);
      if (mensajesResp.mensajesSala.isEmpty) return [];
      return mensajesResp.mensajesSala;
    } catch (e) {
      print('Error en getChatSala: $e');
      return [];
    }
  }

  Future<List<Sala>> getSalesAll() async {
    try {
      final uri = Uri.parse(
          '${Environment.apiUrl}/salas/obtener-salas-mensajes-usuario');
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() as String,
      });
      final salesResp = SalesResponse.fromJson(resp.body);
      return salesResp.salas;
    } catch (e) {
      print('Error en getSalesAll: $e');
      return [];
    }
  }

  Future<List<Usuario>> getUsuariosSala(String salaID) async {
    try {
      final uri = Uri.parse(
          '${Environment.apiUrl}/salas/obtener-usuarios-sala/$salaID');
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() as String,
      });
      final decodedData = json.decode(resp.body);
      final usuarios = UsuariosResponse.fromJson(decodedData);
      return usuarios.usuarios;
    } catch (e) {
      print('Error en getUsuariosSala: $e');
      return [];
    }
  }

  Future<Sala?> createSala(String nombre) async {
    try {
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
    } catch (e) {
      print('Error en createSala: $e');
      return null;
    }
  }

  Future<Sala?> joinSala(String codigo) async {
    try {
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
    } catch (e) {
      print('Error en joinSala: $e');
      return null;
    }
  }

  Future<bool> deleteSala(String salaID) async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/salas/$salaID');
      final resp = await http.delete(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() as String,
      });

      final decodedData = json.decode(resp.body);
      final salaResp = Sala.fromMap(decodedData['sala']);
      return salaResp.uid == salaID;
    } catch (e) {
      print('Error en deleteSala: $e');
      return false;
    }
  }

  Future<bool> deleteUsuarioSala(String uid) async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/salas/eliminar-usuario');
      final resp = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken() as String,
          },
          body: '{"uid":"$uid"}');
      final decodedData = json.decode(resp.body);
      final salaResp = Sala.fromMap(decodedData['sala']);
      return salaResp.uid == uid;
    } catch (e) {
      print('Error en deleteUsuarioSala: $e');
      return false;
    }
  }

  Future<bool> deleteUserById(String salaID, String usuarioID) async {
    try {
      final uri = Uri.parse(
          '${Environment.apiUrl}/salas/delete-user/$salaID/$usuarioID');
      final resp = await http.delete(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() as String,
      });
      final decodedData = json.decode(resp.body);
      final salaResp = Sala.fromMap(decodedData['sala']);
      return salaResp.uid == salaID;
    } catch (e) {
      print('Error en deleteUserById: $e');
      return false;
    }
  }

  Future<bool> abandonarSala(String salaID) async {
    try {
      final uri =
          Uri.parse('${Environment.apiUrl}/salas/abandonar-sala/$salaID');
      final resp = await http.delete(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() as String,
      });

      final decodedData = json.decode(resp.body);
      final salaResp = Sala.fromMap(decodedData['sala']);
      return salaResp.uid == salaID;
    } catch (e) {
      print('Error en abandonarSala: $e');
      return false;
    }
  }

  Future<bool> cambiarEstadoSala(String salaID, bool estado) async {
    try {
      final body = json.encode({
        'isRoomOpen': estado,
      });

      final uri =
          Uri.parse('${Environment.apiUrl}/salas/cambiar-estado-sala/$salaID');
      final resp = await http.put(uri,
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken() as String,
          },
          body: body);
      return resp.statusCode == 200;
    } catch (e) {
      print('Error en cambiarEstadoSala: $e');
      return false;
    }
  }
}
