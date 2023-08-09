import 'package:flutter_maps_adv/models/ubicacion.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:flutter_maps_adv/resources/services/auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ApiUserRepository {
  final AuthService _authService = AuthService();

  Future<bool> login(String email, String password) async {
    autenticando = true;
    return await _authService.login(email, password);
  }

  Future<bool> register(String nombre, String email, String password) async {
    return await _authService.register(nombre, email, password);
  }

  Future<bool> addTelefono(String telefono) async {
    return await _authService.addTelefono(telefono);
  }

  Future<bool> addTelefonos(String telefono) async {
    return await _authService.addTelefonos(telefono);
  }

  Future<bool> deleteTelefono(String telefono) async {
    return await _authService.deleteTelefono(telefono);
  }

  Future<bool> notificacion(double lat, double lng) async {
    return await _authService.notificacion(lat, lng);
  }

  Future<bool> isLoggedIn() async {
    // final token = await AuthService.getToken();
    // if (token == null) {
    //   return false;
    // } else {
    return await _authService.isLoggedIn();
    // }
  }

  //eliminarTokenApp
  Future<bool> eliminarTokenApp() async {
    return await _authService.eliminarTokenApp();
  }

  //marcarPublicacionPendienteFalse
  Future<bool> marcarPublicacionPendienteFalse() async {
    return await _authService.marcarPublicacionPendienteFalse();
  }

  // marcarSalaPendienteFalse
  Future<bool> marcarSalaPendienteFalse() async {
    return await _authService.marcarSalaPendienteFalse();
  }

  //marcarNotificacionesPendienteFalse
  Future<bool> marcarNotificacionesPendienteFalse() async {
    return await _authService.marcarNotificacionesPendienteFalse();
  }

  //actualizarIsOpenRoom
  Future<bool?> actualizarIsOpenRoom(bool isOpenRoom) async {
    return await _authService.actualizarIsOpenRoom(isOpenRoom);
  }

  //signInWithGoogle
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    return await _authService.signInWithGoogle();
  }

  Future<Usuario?> updateUsuarioImage(String id, String imgPath) async {
    return await _authService.updateUsuarioImage(id, imgPath);
  }

  //updateUsuario
  Future<bool?> updateUsuario(String nombre, String telefono) async {
    return await _authService.updateUsuario(nombre, telefono);
  }

  get usuario => _authService.usuario;

  bool get autenticando => _authService.autenticando;

  set autenticando(bool valor) {
    _authService.autenticando = valor;
  }

  List<Ubicacion> get ubicaciones => _authService.ubicaciones ?? [];

  set ubicaciones(List<Ubicacion> ubicaciones) {
    _authService.ubicaciones = ubicaciones;
  }

  Future<void> logout() async {
    await AuthService().logout();
  }
}
