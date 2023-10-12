import 'dart:convert';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_maps_adv/models/institucionmodel.dart';
import 'package:flutter_maps_adv/models/ubicacion.dart';
import 'package:flutter_maps_adv/models/usuarios_response.dart';
import 'package:flutter_maps_adv/resources/services/push_notifications_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    try {
      autenticando = true;
      final data = {
        'email': email,
        'password': password,
        'tokenApp': PushNotificationService.token
      };
      final uri = Uri.parse('${Environment.apiUrl}/login');
      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
      autenticando = false;
      // print(resp.body);
      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        ubicaciones = loginResponse.usuario.ubicacion;
        await _guardarToken(loginResponse.token);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      // Aquí puedes manejar el error de la forma que desees
      print('Error durante el inicio de sesiónn: $error');
      return false;
    }
  }

// router.put("/actualizar-is-open-room", validarJWT, actualizarIsOpenRoom);
  Future<bool> actualizarIsOpenRoom(bool isOpenRoom) async {
    try {
      final data = {
        'isOpenRoom': isOpenRoom,
      };
      final uri =
          Uri.parse('${Environment.apiUrl}/usuarios/actualizar-is-open-room');

      final resp = await http.put(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await getToken() as String,
      });

      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      // Aquí puedes manejar el error de la forma que desees
      print('Error durante el inicio de sesiónn: $error');
      return false;
    }
  }

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      //en caso de que no se seleccione una cuenta
      if (account == null) return null;

      final googleKey = await account.authentication;

      final uri = Uri.parse('${Environment.apiUrl}/login/google');

      final data = {
        'token': googleKey.idToken,
        'tokenApp': PushNotificationService.token
      };

      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);

        usuario = loginResponse.usuario;
        ubicaciones = loginResponse.usuario.ubicacion;
        await _guardarToken(loginResponse.token);

        return account;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      print('ok login error');
      return null;
    }
  }

  Future<bool> register(String nombre, String email, String password,
      String unidadEducativa) async {
    autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password,
      'unidadEducativa': unidadEducativa,
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
      return false;
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
      print('token: ${loginResponse.token}');
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future<void> _guardarToken(String token) async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('token', token);
    return await _storage.write(key: 'token', value: token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    const storage = FlutterSecureStorage();
    storage.delete(key: 'token');
    await _googleSignIn.signOut();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('nombre');
    await prefs.remove('uid');
  }

  //TODO: Eliminar el token del dispositivo

  //delete ubicacion
  Future<bool> deleteUbicacion(String id) async {
    final uri = Uri.parse('${Environment.apiUrl}/ubicacion/$id');

    final resp = await http.delete(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await getToken() as String,
    });

    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //agregar telefono
  Future<bool> addTelefono(String telefono) async {
    final data = {
      'telefono': telefono,
    };

    final uri = Uri.parse('${Environment.apiUrl}/usuarios/add-telefono');

    final resp = await http.put(uri, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
      'x-token': await getToken() as String,
    });

    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addTelefonos(String telefonos) async {
    final data = {
      'telefono': telefonos,
    };

    final uri = Uri.parse('${Environment.apiUrl}/usuarios/add-telefonos');

    final resp = await http.put(uri, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
      'x-token': await getToken() as String,
    });

    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //delete telefono
  Future<bool> deleteTelefono(String telefono) async {
    final data = {
      'telefono': telefono,
    };

    final uri = Uri.parse('${Environment.apiUrl}/usuarios/delete-telefono');

    final resp = await http.delete(uri, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
      'x-token': await getToken() as String,
    });

    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //usuarios/notificacion
  Future<bool> notificacion(double lat, double lng) async {
    final data = {
      'lat': lat,
      'lng': lng,
    };
    final uri = Uri.parse('${Environment.apiUrl}/usuarios/notificacion');

    final resp = await http.post(uri, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
      'x-token': await getToken() as String,
    });

    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<Usuario?> updateUsuarioImage(String id, String imgPath) async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/uploads/usuarios/$id');
      final request = http.MultipartRequest('PUT', uri);

      // Agregar el encabezado 'x-token'
      final token = await AuthService.getToken();
      request.headers['x-token'] = token as String;

      // Agregar el campo 'archivo' con el archivo de imagen
      final file = await http.MultipartFile.fromPath('archivo', imgPath);
      request.files.add(file);

      // Enviar la solicitud y obtener la respuesta
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final decodedData = json.decode(responseBody);
      final usuarioResp = Usuario.fromJson(decodedData);
      return usuarioResp;
    } catch (e) {
      print('Error en updateUsuarioImage: $e');
      return null;
    }
  }

  //update usuario
  Future<bool?> updateUsuario(String nombre, String telefono) async {
    final data = {
      'nombre': nombre,
      'telefono': telefono,
    };

    final uri = Uri.parse('${Environment.apiUrl}/usuarios/add-telefono-nombre');

    final resp = await http.put(uri, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
      'x-token': await getToken() as String,
    });

    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //router.put("/marcar-publicacion-pendiente-false", validarJWT, marcarPublicacionPendienteFalse );
  Future<bool> marcarPublicacionPendienteFalse() async {
    try {
      final uri = Uri.parse(
          '${Environment.apiUrl}/usuarios/marcar-publicacion-pendiente-false');
      final resp = await http.put(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await getToken() as String,
      });

      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en marcarPublicacionPendienteFalse: $e');
      return false;
    }
  }

  //router.put("/marcar-sala-pendiente-false", validarJWT, marcarSalaPendienteFalse );
  Future<bool> marcarSalaPendienteFalse() async {
    try {
      final uri = Uri.parse(
          '${Environment.apiUrl}/usuarios/marcar-sala-pendiente-false');
      final resp = await http.put(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await getToken() as String,
      });

      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en marcarSalaPendienteFalse: $e');
      return false;
    }
  }

  //marcar-notificaciones-pendiente-false
  Future<bool> marcarNotificacionesPendienteFalse() async {
    try {
      final uri = Uri.parse(
          '${Environment.apiUrl}/usuarios/marcar-notificaciones-pendiente-false');
      final resp = await http.put(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await getToken() as String,
      });

      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en marcarNotificacionesPendienteFalse: $e');
      return false;
    }
  }

  Future<bool> eliminarTokenApp() async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/usuarios/delete-token-app');
      final resp = await http.delete(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await getToken() as String,
      });

      print('resp.statusCode: ${resp.statusCode}');

      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en eliminarTokenApp: $e');
      return false;
    }
  }

  // router.put("/cambiar-contrasena", validarJWT, cambiarContrasena);
  Future<bool> cambiarContrasena(
      String email, String contrasenaActual, String nuevaContrasena) async {
    try {
      final data = {
        'email': email,
        'contrasenaActual': contrasenaActual,
        'nuevaContrasena': nuevaContrasena,
      };
      final uri =
          Uri.parse('${Environment.apiUrl}/usuarios/cambiar-contrasena');
      final resp = await http.put(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await getToken() as String,
      });

      print('resp.statusCode: ${resp.statusCode}');

      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en cambiarContrasena: $e');
      return false;
    }
  }

  Future<List<Institucione>> obtenerTodasLasInstituciones() async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/instituciones');
      final resp =
          await http.get(uri, headers: {'Content-Type': 'application/json'});
      final decodedData = json.decode(resp.body);
      print('decodedData: $decodedData');
      final institucionResp = InstitucionReponse.fromJson(decodedData);

      return institucionResp.instituciones;
    } catch (e) {
      print('Error en obtenerTodasLasInstituciones: $e');
      return [];
    }
  }

  Future<bool> recoverPassword(String email) async {
    try {
      final data = {
        'email': email,
      };
      final uri = Uri.parse('${Environment.apiUrl}/email/recover-password');
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });

      print('resp.statusCode: ${resp.statusCode}');

      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en recoverPassword: $e');
      return false;
    }
  }
}
