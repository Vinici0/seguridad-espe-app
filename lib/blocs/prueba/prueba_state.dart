part of 'prueba_bloc.dart';

class PruebaState extends Equatable {
  final bool existeUsuario;
  final Usuario2? usuario;

  PruebaState({Usuario2? user})
      : usuario = user ?? null,
        existeUsuario = (user != null) ? true : false;

  PruebaState copyWith({
    Usuario2? usuario,
  }) =>
      PruebaState(user: usuario ?? this.usuario);

  @override
  List<Object> get props => [];
}
