part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final Usuario? usuario;
  final bool existeUsuario;

  const AuthState({
    usuario,
    autenticando,
  })  : usuario = usuario ?? null,
        existeUsuario = (usuario != null) ? true : false;

  AuthState copyWith({
    Usuario? usuario,
    bool? autenticando,
  }) =>
      AuthState(
        usuario: usuario ?? this.usuario,
        autenticando: autenticando ?? this.existeUsuario,
      );

  @override
  List<Object?> get props => [
        usuario ?? null,
        existeUsuario,
      ];
}
