import 'package:flutter_maps_adv/resources/services/auth_provider.dart';

class ApiUserRepository {
  final AuthService _authService = AuthService();

  Future<bool> login(String email, String password) async {
    autenticando = true;
    return await _authService.login(email, password);
  }

  Future register(String nombre, String email, String password) async {
    return await _authService.register(nombre, email, password);
  }

  Future<bool> isLoggedIn() async {
    final token = await AuthService.getToken();
    if (token == null) {
      return false;
    } else {
      return await _authService.isLoggedIn();
    }
  }

  get usuario => _authService.usuario;

  bool get autenticando => _authService.autenticando;

  set autenticando(bool valor) {
    _authService.autenticando = valor;
  }

  Future<void> logout() async {
    await AuthService().logout();
  }
}
