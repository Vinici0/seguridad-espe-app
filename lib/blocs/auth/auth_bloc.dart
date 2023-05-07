import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:flutter_maps_adv/resources/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiUserRepository apiAuthRepository = ApiUserRepository();

  AuthBloc() : super(const AuthState()) {
    on<AuthRegisterEvent>((event, emit) async {
      final register = await apiAuthRepository.register(
          event.nombre, event.email, event.password);
      if (register) {
        emit(state.copyWith(
            usuario: apiAuthRepository.usuario,
            autenticando: apiAuthRepository.autenticando));
      }
    });

    on<AuthLoginEvent>((event, emit) async {
      // add(AuthInitEvent());
      final login = await apiAuthRepository.login(event.email, event.password);
      print('login: $login');
      if (login) {
        emit(state.copyWith(usuario: apiAuthRepository.usuario));
      } else {
        print('No se pudo loguear');
      }
      // add(AuthInitEvent());
    });

    on<AuthInitEvent>((event, emit) {
      // add(AuthLoginEvent());
      final Usuario usuario = apiAuthRepository.usuario;
      if (usuario != null) {
        emit(state.copyWith(
            usuario: usuario, autenticando: apiAuthRepository.autenticando));
      } else {
        print('No hay usuario');
      }
    });

    on<AuthLogoutEvent>((event, emit) async {
      await apiAuthRepository.logout();
      emit(state.copyWith(usuario: null, autenticando: false));
    });

    // init();
  }

  // void init() {
  //   add(AuthInitEvent());
  // }
}
