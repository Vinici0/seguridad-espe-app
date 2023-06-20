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

  @override
  List<Object> get props => [email, password, nombre];
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

  @override
  List<Object> get props => [email, password];
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();

  @override
  List<Object> get props => [];
}

//init event
class AuthInitEvent extends AuthEvent {
  const AuthInitEvent();
  @override
  List<Object> get props => [];
}

//conect socket
class AuthConectEvent extends AuthEvent {
  const AuthConectEvent();

  @override
  List<Object> get props => [];
}

//disconnect socket
class AuthDisconnectEvent extends AuthEvent {
  const AuthDisconnectEvent();

  @override
  List<Object> get props => [];
}

class AuthAddUbicacionEvent extends AuthEvent {
  final Ubicacion ubicacion;
  const AuthAddUbicacionEvent(this.ubicacion);
  @override
  List<Object> get props => [ubicacion];
}

// delete Ubicacion
class AuthDeleteUbicacionEvent extends AuthEvent {
  final String uid;
  const AuthDeleteUbicacionEvent(this.uid);
  @override
  List<Object> get props => [uid];
}

//add telefono
class AuthAddTelefonoEvent extends AuthEvent {
  final String telefono;
  const AuthAddTelefonoEvent(this.telefono);
  @override
  List<Object> get props => [telefono];
}

class AuthAddTelefonFamilyEvent extends AuthEvent {
  final String telefono;
  const AuthAddTelefonFamilyEvent(this.telefono);
  @override
  List<Object> get props => [telefono];
}

class AuthDeleteTeleFamilyEvent extends AuthEvent {
  final String telefono;
  const AuthDeleteTeleFamilyEvent(this.telefono);
  @override
  List<Object> get props => [telefono];
}
