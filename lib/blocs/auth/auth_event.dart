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

  const AuthRegisterEvent({
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
  const AuthLogoutEvent();
}

//init event
class AuthInitEvent extends AuthEvent {
  const AuthInitEvent();
}

//conect socket
class AuthConectEvent extends AuthEvent {
  const AuthConectEvent();
}

//disconnect socket
class AuthDisconnectEvent extends AuthEvent {
  const AuthDisconnectEvent();
}
