import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/login_response.dart';
import 'package:flutter_maps_adv/models/usuario.dart';

class AuthService {
  Usuario? usuario;
  bool _autenticando = false;

  final _storage =
      new FlutterSecureStorage(); // Instancia de FlutterSecureStorage para almacenar el token de forma segura

  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
  }

  // Getters del token de forma estática
  static Future<String?> getToken() async {
    // Obtener la instancia de SharedPreferences
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    print('Token: $token');
    return token;
  }

  // Inicia sesión con correo electrónico y contraseña
  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    final data = {'email': email, 'password': password};

    try {
      final uri = Uri.parse('${Environment.apiUrl}/login');
      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      this.autenticando = false;

      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        this.usuario = loginResponse.usuario;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('online', this.usuario!.online);
        await prefs.setString('email', this.usuario!.email);
        await prefs.setString('nombre', this.usuario!.nombre);
        await prefs.setString('uid', this.usuario!.uid);

        await this._guardarToken(loginResponse.token);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Manejo de excepciones
      this.autenticando = false;
      print('Error durante la autenticación: $e');
      return false;
    }
  }

  Future<bool> register(String nombre, String email, String password) async {
    this.autenticando = true;

    final data = {'nombre': nombre, 'email': email, 'password': password};

    final uri = Uri.parse('${Environment.apiUrl}/login/new');
    final resp = await http.post(
      uri,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('nombre', this.usuario!.nombre);
      prefs.setString('email', this.usuario!.email);
      prefs.setString('uid', this.usuario!.uid);
      prefs.setBool('online', this.usuario!.online);

      print("Cuenta creada con éxito");
      print(this.usuario);

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

    final token = await this._storage.read(key: 'token');

    final resp = await http.get(Uri.parse('${Environment.apiUrl}/login/renew'),
        headers: {'Content-Type': 'application/json', 'x-token': token!});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      prefs.setBool('online', loginResponse.usuario.online);
      prefs.setString('email', loginResponse.usuario.email);
      prefs.setString('nombre', loginResponse.usuario.nombre);
      prefs.setString('uid', loginResponse.usuario.uid);
      //guarda el token en prefs
      prefs.setString('token', loginResponse.token);
      this.usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);
      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future<void> _guardarToken(String token) async {
    // Almacenar token en secure storage
    await _storage.write(key: 'token', value: token);

    // Almacenar datos del usuario en secure storage

    // Almacenar token en shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);

    // Almacenar datos del usuario en shared preferences
    return await _storage.write(key: 'token', value: token);
  }

  Future<void> logout() async {
    // Eliminar token de secure storage
    await _storage.delete(key: 'token');
    // Eliminar datos del usuario de secure storage
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'nombre');
    await _storage.delete(key: 'uid');

    // Eliminar token
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    // Eliminar datos del usuario
    await prefs.remove('email');
    await prefs.remove('nombre');
    await prefs.remove('uid');
  }
}
