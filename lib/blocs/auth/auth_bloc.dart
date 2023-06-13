import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:flutter_maps_adv/resources/repository/auth_repository.dart';
import 'package:flutter_maps_adv/resources/services/socket_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiUserRepository apiAuthRepository = ApiUserRepository();
  final SocketService socketService = SocketService();

  AuthBloc() : super(const AuthState()) {
    on<AuthConectEvent>(_onAuthConnectEvent);
    on<AuthDisconnectEvent>(_onAuthDisconnectEvent);
    on<AuthInitEvent>(_onAuthInitEvent);
    on<AuthLoginEvent>(_onAuthLoginEvent);
    on<AuthLogoutEvent>(_onAuthLogoutEvent);
    on<AuthRegisterEvent>(_onAuthRegisterEvent);
  }

  void _onAuthRegisterEvent(
      AuthRegisterEvent event, Emitter<AuthState> emit) async {
    final register = await apiAuthRepository.register(
        event.nombre, event.email, event.password);
    if (register) {
      emit(state.copyWith(
          usuario: apiAuthRepository.usuario,
          autenticando: apiAuthRepository.autenticando));
    }
  }

  void _onAuthLoginEvent(AuthLoginEvent event, Emitter<AuthState> emit) async {
    final login = await apiAuthRepository.login(event.email, event.password);
    emit(state.copyWith(usuario: apiAuthRepository.usuario));
  }

  void _onAuthInitEvent(AuthInitEvent event, Emitter<AuthState> emit) {
    final Usuario usuario = apiAuthRepository.usuario;
    emit(state.copyWith(
        usuario: usuario, autenticando: apiAuthRepository.autenticando));
  }

  void _onAuthLogoutEvent(
      AuthLogoutEvent event, Emitter<AuthState> emit) async {
    await apiAuthRepository.logout();
    emit(state.copyWith(usuario: null, autenticando: false));
  }

  void _onAuthConnectEvent(
      AuthConectEvent event, Emitter<AuthState> emit) async {
    socketService.connect();
  }

  void _onAuthDisconnectEvent(
      AuthDisconnectEvent event, Emitter<AuthState> emit) async {
    socketService.disconnect();
  }
}
