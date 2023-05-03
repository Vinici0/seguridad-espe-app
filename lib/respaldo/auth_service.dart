import 'dart:convert';

import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/login_response.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// // class AuthService {
//   Usuario? usuario;
//   bool _autenticando = false;

//   final _storage = new FlutterSecureStorage();

//   bool get autenticando => this._autenticando;
//   set autenticando(bool valor) {
//     this._autenticando = valor;
//   }

//   // Getters del token de forma estática
//   static Future<String?> getToken() async {
//     final _storage = new FlutterSecureStorage();
//     final token = await _storage.read(key: 'token');
//     return token;
//   }

//   static Future<void> deleteToken() async {
//     final _storage = new FlutterSecureStorage();
//     await _storage.delete(key: 'token');
//   }

//   Future<bool> login(String email, String password) async {
//     //Porque ek autenticado es true y despues false?
//     this.autenticando = true;

//     final data = {'email': email, 'password': password};

//     final uri = Uri.parse('${Environment.apiUrl}/login');
//     final resp = await http.post(uri,
//         body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

//     this.autenticando = false;

//     if (resp.statusCode == 200) {
//       final loginResponse = loginResponseFromJson(resp.body);
//       this.usuario = loginResponse.usuario;
//       print(this.usuario);

//       await this._guardarToken(loginResponse.token);

//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future register(String nombre, String email, String password) async {
//     this.autenticando = true;

//     final data = {'nombre': nombre, 'email': email, 'password': password};

//     final uri = Uri.parse('${Environment.apiUrl}/login/new');
//     final resp = await http.post(uri,
//         body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

//     this.autenticando = false;

//     if (resp.statusCode == 200) {
//       final loginResponse = loginResponseFromJson(resp.body);
//       this.usuario = loginResponse.usuario;
//       print("Cuenta crearda con exito");
//       print(this.usuario);
//       await this._guardarToken(loginResponse.token);

//       return true;
//     } else {
//       final respBody = jsonDecode(resp.body);
//       return respBody['msg'];
//     }
//   }

//   Future<bool> isLoggedIn() async {
//     //Verifica si el token es valido y si lo es, renueva el token
//     final token = await this._storage.read(key: 'token') ?? '';
//     print('token: $token');

//     final uri = Uri.parse('${Environment.apiUrl}/login/renew');
//     final resp = await http.get(uri,
//         headers: {'Content-Type': 'application/json', 'x-token': token});

//     if (resp.statusCode == 200) {
//       final loginResponse = loginResponseFromJson(resp.body);
//       this.usuario = loginResponse.usuario;
//       await this._guardarToken(loginResponse.token);
//       return true;
//     } else {
//       this.logout();
//       return false;
//     }
//   }

//   Future _guardarToken(String token) async {
//     return await _storage.write(key: 'token', value: token);
//   }

//   Future logout() async {
//     await _storage.delete(key: 'token');
//   }
// }
