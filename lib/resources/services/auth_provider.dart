import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_maps_adv/models/ubicacion.dart';
import 'package:flutter_maps_adv/resources/services/push_notifications_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/login_response.dart';
import 'package:flutter_maps_adv/models/usuario.dart';

class AuthService {
  Usuario? usuario;
  List<Ubicacion>? ubicaciones;
  bool _autenticando = false;

  final _storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
  }

  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;
    final data = {
      'email': email,
      'password': password,
      'tokenApp': PushNotificationService.token
    };
    print(data);

    final uri = Uri.parse('${Environment.apiUrl}/login');

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      ubicaciones = loginResponse.usuario.ubicacion;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('online', usuario!.online);
      await prefs.setString('email', usuario!.email);
      await prefs.setString('nombre', usuario!.nombre);
      await prefs.setString('uid', usuario!.uid);

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String nombre, String email, String password) async {
    autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password,
      'tokenApp': PushNotificationService.token
    };

    final uri = Uri.parse('${Environment.apiUrl}/login/new');
    final resp = await http.post(
      uri,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      ubicaciones = loginResponse.usuario.ubicacion;

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('nombre', usuario!.nombre);
      prefs.setString('email', usuario!.email);
      prefs.setString('uid', usuario!.uid);
      prefs.setBool('online', usuario!.online);
      await _guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      throw Exception(respBody['msg']);
    }
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      if (prefs.getString('token') != null) {
        return true;
      } else {
        return false;
      }
    }

    final token = await _storage.read(key: 'token') ?? '';

    final resp = await http.get(Uri.parse('${Environment.apiUrl}/login/renew'),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      ubicaciones = loginResponse.usuario.ubicacion;
      prefs.setBool('online', loginResponse.usuario.online);
      prefs.setString('email', loginResponse.usuario.email);
      prefs.setString('nombre', loginResponse.usuario.nombre);
      prefs.setString('uid', loginResponse.usuario.uid);
      prefs.setString('token', loginResponse.token);
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future<void> _guardarToken(String token) async {
    await _storage.write(key: 'token', value: token);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    return await _storage.write(key: 'token', value: token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    const storage = FlutterSecureStorage();
    storage.delete(key: 'token');
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('nombre');
    await prefs.remove('uid');
  }

  //delete ubicacion
  Future<bool> deleteUbicacion(String id) async {
    final uri = Uri.parse('${Environment.apiUrl}/ubicacion/$id');

    final resp = await http.delete(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await getToken() as String,
    });

    if (resp.statusCode == 200) {
      final ubicacionResponse = ubicacionResponseFromMap(resp.body);
      ubicaciones = ubicacionResponse.ubicacion;
      return true;
    } else {
      return false;
    }
  }
}
