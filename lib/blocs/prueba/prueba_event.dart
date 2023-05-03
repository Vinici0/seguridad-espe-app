part of 'prueba_bloc.dart';

abstract class PruebaEvent extends Equatable {
  const PruebaEvent();

  @override
  List<Object> get props => [];
}

class ActivarUsuario extends PruebaEvent {
  final Usuario2 usuario;

  ActivarUsuario(this.usuario);
}

class CambiarEdadUsuario extends PruebaEvent {
  final int edad;

  CambiarEdadUsuario(this.edad);
}

class AgregarProfesionUsuario extends PruebaEvent {
  final String profesion;

  AgregarProfesionUsuario(this.profesion);
}
