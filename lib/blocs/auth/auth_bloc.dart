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
    on<AuthAddTelefonoEvent>(_onAuthAddTelefonoEvent);
    on<AuthDeleteTeleFamilyEvent>(_onAuthDeleteTeleFamilyEvent);
    on<AuthAddTelefonFamilyEvent>(_aonAddTelefonoFamilyEvent);
  }

  void _onAuthRegisterEvent(AuthRegisterEvent event, Emitter<AuthState> emit) {
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

  void _onAuthAddTelefonoEvent(
      AuthAddTelefonoEvent event, Emitter<AuthState> emit) async {
    final usuario = Usuario(
        online: state.usuario!.online,
        nombre: state.usuario!.nombre,
        email: state.usuario!.email,
        telefono: event.telefono,
        tokenApp: state.usuario!.tokenApp,
        ubicacion: state.usuario!.ubicacion,
        uid: state.usuario!.uid,
        telefonos: state.usuario!.telefonos);

    emit(state.copyWith(usuario: usuario));
  }

  void _aonAddTelefonoFamilyEvent(
      AuthAddTelefonFamilyEvent event, Emitter<AuthState> emit) async {
    final usuario = Usuario(
        online: state.usuario!.online,
        nombre: state.usuario!.nombre,
        email: state.usuario!.email,
        telefono: state.usuario!.telefono,
        tokenApp: state.usuario!.tokenApp,
        ubicacion: state.usuario!.ubicacion,
        uid: state.usuario!.uid,
        telefonos: [...state.usuario!.telefonos, event.telefono]);

    emit(state.copyWith(usuario: usuario));
  }

  void _onAuthDeleteTeleFamilyEvent(
      AuthDeleteTeleFamilyEvent event, Emitter<AuthState> emit) async {
    final usuario = Usuario(
        online: state.usuario!.online,
        nombre: state.usuario!.nombre,
        email: state.usuario!.email,
        telefono: state.usuario!.telefono,
        tokenApp: state.usuario!.tokenApp,
        ubicacion: state.usuario!.ubicacion,
        uid: state.usuario!.uid,
        telefonos: state.usuario!.telefonos
            .where((telefono) => telefono != event.telefono)
            .toList());

    emit(state.copyWith(usuario: usuario));
  }

  init() async {
    final isLoggedIn = await apiAuthRepository.isLoggedIn();

    add(const AuthInitEvent());
    isLoggedInTrue = isLoggedIn;
    if (isLoggedIn) {
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

  addTelefono(String telefono) async {
    await apiAuthRepository.addTelefono(telefono);
    add(AuthAddTelefonoEvent(telefono));
  }

  addTelefonoFamily(String telefono) async {
    await apiAuthRepository.addTelefonos(telefono);
    add(AuthAddTelefonFamilyEvent(telefono));
  }

  deleteTelefonoFamily(String telefono) async {
    await apiAuthRepository.deleteTelefono(telefono);
    add(AuthDeleteTeleFamilyEvent(telefono));
  }

  deleteTelefono(String telefono) async {
    await apiAuthRepository.deleteTelefono(telefono);
    add(AuthDeleteTeleFamilyEvent(telefono));
  }
}
