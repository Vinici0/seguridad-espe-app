part of 'publication_bloc.dart';

abstract class PublicationEvent extends Equatable {
  const PublicationEvent();

  @override
  List<Object> get props => [];
}

class PublicacionesInitEvent extends PublicationEvent {}

class PublicacionesCreateEvent extends PublicationEvent {
  final String tipo;
  final String descripcion;
  final String color;
  final String icon;
  final bool activo;
  final bool visible;
  final String uid;
  final List<String>? path;

  const PublicacionesCreateEvent(
    this.tipo,
    this.descripcion,
    this.color,
    this.icon,
    this.activo,
    this.visible,
    this.uid,
    this.path,
  );

  @override
  List<Object> get props => [
        tipo,
        descripcion,
        color,
        icon,
        activo,
        visible,
        uid,
      ];
}

class PublicacionesUpdate extends PublicationEvent {
  final String uid;

  const PublicacionesUpdate(this.uid);

  @override
  List<Object> get props => [uid];
}

class PublicacionesDelete extends PublicationEvent {
  final Publicacion publicacion;

  const PublicacionesDelete(this.publicacion);

  @override
  List<Object> get props => [publicacion];
}
