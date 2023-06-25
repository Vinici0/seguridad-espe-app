part of 'publication_bloc.dart';

abstract class PublicationEvent extends Equatable {
  const PublicationEvent();

  @override
  List<Object> get props => [];
}

class PublicacionesInitEvent extends PublicationEvent {
  List<Publicacion> publicaciones;

  PublicacionesInitEvent(this.publicaciones);

  @override
  List<Object> get props => [publicaciones];
}

class PublicacionesCreateEvent extends PublicationEvent {
  final List<Publicacion> publicacion;

  const PublicacionesCreateEvent(
    this.publicacion,
  );

  @override
  List<Object> get props => [
        publicacion,
      ];
}

class PublicacionesUpdate extends PublicationEvent {
  final List<Publicacion> publicacion;

  const PublicacionesUpdate(this.publicacion);

  @override
  List<Object> get props => [publicacion];
}

class PublicacionesDelete extends PublicationEvent {
  final Publicacion publicacion;

  const PublicacionesDelete(this.publicacion);

  @override
  List<Object> get props => [publicacion];
}

class PublicacionSelectEvent extends PublicationEvent {
  final Publicacion publicacion;

  const PublicacionSelectEvent(this.publicacion);

  @override
  List<Object> get props => [publicacion];
}

class GetAllCommentsEvent extends PublicationEvent {
  final List<Comentario> comentarios;

  const GetAllCommentsEvent(this.comentarios);

  @override
  List<Object> get props => [comentarios];
}

//esta cargando evento
class LoadingEvent extends PublicationEvent {}
