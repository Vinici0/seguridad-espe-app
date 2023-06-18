part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final Usuario? usuario;
  final List<Ubicacion> ubicaciones;

  const AuthState({
    this.usuario,
    required this.ubicaciones,
  });

  AuthState copyWith({
    Usuario? usuario,
    List<Ubicacion>? ubicaciones,
  }) =>
      AuthState(
        usuario: usuario ?? this.usuario,
        ubicaciones: ubicaciones ?? this.ubicaciones,
      );

  @override
  List<Object?> get props => [
        usuario,
        ubicaciones,
      ];
}
