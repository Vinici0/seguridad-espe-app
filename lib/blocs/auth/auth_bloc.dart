import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_maps_adv/models/ubicacion.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:flutter_maps_adv/resources/repository/auth_repository.dart';
import 'package:flutter_maps_adv/resources/services/socket_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiUserRepository apiAuthRepository = ApiUserRepository();
  final SocketService socketService = SocketService();

  bool isLoggedInTrue = false;

  AuthBloc() : super(const AuthState(ubicaciones: [])) {
    on<AuthConectEvent>(_onAuthConnectEvent);
    on<AuthDisconnectEvent>(_onAuthDisconnectEvent);
    on<AuthInitEvent>(_onAuthInitEvent);
    on<AuthLoginEvent>(_onAuthLoginEvent);
    on<AuthLogoutEvent>(_onAuthLogoutEvent);
    on<AuthRegisterEvent>(_onAuthRegisterEvent);
    on<AuthAddUbicacionEvent>(_onAuthAddUbicacionEvent);
    on<AuthDeleteUbicacionEvent>(_onAuthDeleteUbicacionEvent);
  }

  void _onAuthRegisterEvent(
      AuthRegisterEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(
      usuario: apiAuthRepository.usuario,
    ));
  }

  void _onAuthLoginEvent(AuthLoginEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(usuario: apiAuthRepository.usuario));
  }

  void _onAuthInitEvent(AuthInitEvent event, Emitter<AuthState> emit) {
    final Usuario usuario = apiAuthRepository.usuario;
    final List<Ubicacion> ubicaciones = apiAuthRepository.ubicaciones;
    try {
      emit(state.copyWith(usuario: usuario, ubicaciones: ubicaciones));
    } catch (e) {
      print(e);
    }
  }

  void _onAuthLogoutEvent(
      AuthLogoutEvent event, Emitter<AuthState> emit) async {
    await apiAuthRepository.logout();
    emit(state.copyWith(usuario: null));
  }

  void _onAuthConnectEvent(
      AuthConectEvent event, Emitter<AuthState> emit) async {
    socketService.connect();
  }

  void _onAuthDisconnectEvent(
      AuthDisconnectEvent event, Emitter<AuthState> emit) async {
    socketService.disconnect();
  }

  void _onAuthAddUbicacionEvent(
      AuthAddUbicacionEvent event, Emitter<AuthState> emit) async {
    if (state.ubicaciones
        .any((ubicacion) => ubicacion.uid == event.ubicacion.uid)) return;

    emit(state.copyWith(ubicaciones: [event.ubicacion, ...state.ubicaciones]));
  }

  void _onAuthDeleteUbicacionEvent(
      AuthDeleteUbicacionEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(
        ubicaciones: state.ubicaciones
            .where((ubicacion) => ubicacion.uid != event.uid)
            .toList()));
  }

  init() async {
    final isLoggedIn = await apiAuthRepository.isLoggedIn();
    isLoggedInTrue = isLoggedIn;
    if (isLoggedIn) {
      add(const AuthInitEvent());
      add(const AuthConectEvent());
    }
  }

  login(String email, String password) async {
    final login = await apiAuthRepository.login(email, password);
    isLoggedInTrue = login;
    add(AuthLoginEvent(email: email, password: password));
    add(const AuthConectEvent());
  }

  register(String nombre, String email, String password) async {
    final register = await apiAuthRepository.register(nombre, email, password);
    isLoggedInTrue = register;
    add(AuthRegisterEvent(nombre: nombre, email: email, password: password));
    add(const AuthConectEvent());
  }

  logout() async {
    isLoggedInTrue = false;
    add(const AuthLogoutEvent());
    add(const AuthDisconnectEvent());
  }
}
