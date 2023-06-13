part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthRegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String nombre;

  AuthRegisterEvent({
    required this.email,
    required this.password,
    required this.nombre,
  });
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({
    required this.email,
    required this.password,
  }) {
    print("Login event");
  }
}

class AuthLogoutEvent extends AuthEvent {
  AuthLogoutEvent();
}

//init event
class AuthInitEvent extends AuthEvent {
  AuthInitEvent();
}

//conect socket
class AuthConectEvent extends AuthEvent {
  AuthConectEvent();
}

//disconnect socket
class AuthDisconnectEvent extends AuthEvent {
  AuthDisconnectEvent();
}
