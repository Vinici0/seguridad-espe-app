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
    final prefs = await SharedPreferences
        .getInstance(); // Obtener la instancia de SharedPreferences
    final token = prefs.getString('token');
    return token;
  }

  Future<bool> login(String email, String password) async {
    //Porque ek autenticado es true y despues false?
    this.autenticando = true;

    final data = {'email': email, 'password': password};

    final uri = Uri.parse('${Environment.apiUrl}/login');
    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('online', this.usuario!.online);
      await prefs.setString('email', this.usuario!.email);
      await prefs.setString('nombre', this.usuario!.nombre);
      await prefs.setString('uid', this.usuario!.uid);
      print(this.usuario);

      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    this.autenticando = true;

    final data = {'nombre': nombre, 'email': email, 'password': password};

    final uri = Uri.parse('${Environment.apiUrl}/login/new');
    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('nombre', this.usuario!.nombre);
      await prefs.setString('email', this.usuario!.email);
      await prefs.setString('uid', this.usuario!.uid);
      await prefs.setBool('online', this.usuario!.online);
      print("Cuenta crearda con exito");
      print(this.usuario);
      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await AuthService.getToken();

    print(token);
    if (token != null) {
      //Recuperar los datos del usuario de shared preferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final bool? oline = prefs.getBool('online');
      final String? email = prefs.getString('email');
      final String? nombre = prefs.getString('nombre');
      final String? uid = prefs.getString('uid');

      print(email);

      if (oline != null && email != null && nombre != null && uid != null) {
        this.usuario =
            Usuario(nombre: nombre, email: email, uid: uid, online: oline);
      }

      return true;
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        return true;
      } else {
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          return false;
        } else {
          final uri = Uri.parse('${Environment.apiUrl}/login/renew');
          final resp = await http.get(uri,
              headers: {'Content-Type': 'application/json', 'x-token': token!});
          print(resp.body);
          if (resp.statusCode == 200) {
            final loginResponse = loginResponseFromJson(resp.body);
            this.usuario = loginResponse.usuario;

            return true;
          } else {
            this.logout();
            return false;
          }
        }
      }
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
  }

  Future<void> logout() async {
    // Eliminar token de secure storage
    await _storage.delete(key: 'token');
    // Eliminar token de shared preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
