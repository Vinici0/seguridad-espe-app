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

class PublicacionesUpdateEvent extends PublicationEvent {
  final String uid;

  const PublicacionesUpdateEvent(this.uid);

  @override
  List<Object> get props => [uid];
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

class GetAllCommentsIDEvent extends PublicationEvent {
  final String id;

  const GetAllCommentsIDEvent(this.id);

  @override
  List<Object> get props => [id];
}

class CountCommentEvent extends PublicationEvent {
  final int conuntComentarios;

  const CountCommentEvent(this.conuntComentarios);

  @override
  List<Object> get props => [conuntComentarios];
}

//esta cargando evento
class LoadingEvent extends PublicationEvent {}

class LoadingEventFalse extends PublicationEvent {}

class ToggleLikeComentarioEvent extends PublicationEvent {
  final List<Comentario> comentarios;

  const ToggleLikeComentarioEvent(this.comentarios);

  @override
  List<Object> get props => [comentarios];
}

//cargar publicaciones de un usuario
class PublicacionesUsuarioEvent extends PublicationEvent {
  final List<Publicacion> publicacionesUsuario;

  const PublicacionesUsuarioEvent(this.publicacionesUsuario);

  @override
  List<Object> get props => [publicacionesUsuario];
}

class PublicationGetMoreEvent extends PublicationEvent {
  final List<Publicacion> publicaciones;

  const PublicationGetMoreEvent(this.publicaciones);

  @override
  List<Object> get props => [publicaciones];
}

class UpdateArryComentsByPublication extends PublicationEvent {
  final List<Comentario> comentarios;

  const UpdateArryComentsByPublication(this.comentarios);

  @override
  List<Object> get props => [comentarios];
}

class UpdatePublicationEvent extends PublicationEvent {
  final Publicacion publicacion;

  const UpdatePublicationEvent(this.publicacion);

  @override
  List<Object> get props => [publicacion];
}

class AddCommentPublicationEvent extends PublicationEvent {
  final CommentPublication commentPublication;

  const AddCommentPublicationEvent(this.commentPublication);

  @override
  List<Object> get props => [commentPublication];
}

class ResetCommentPublicationEvent extends PublicationEvent {
  const ResetCommentPublicationEvent();

  @override
  List<Object> get props => [];
}

class ReportPublicationEvent extends PublicationEvent {
  const ReportPublicationEvent();

  @override
  List<Object> get props => [];
}

//marcar-publicacion-pendiente-false
class MarcarPublicacionPendienteTrueEvent extends PublicationEvent {
  final String uid;
  const MarcarPublicacionPendienteTrueEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

class UpdateLikesPublicationEvent extends PublicationEvent {
  final Publicacion publicacion;

  const UpdateLikesPublicationEvent(this.publicacion);

  @override
  List<Object> get props => [publicacion];
}

//Ir al inicio de la lista ScrollController
class GoToStartListEvent extends PublicationEvent {
  final bool firstController;
  const GoToStartListEvent(this.firstController);

  @override
  List<Object> get props => [firstController];
}

//showNewPostsButton
class ShowNewPostsButtonEvent extends PublicationEvent {
  final bool showNewPostsButton;
  const ShowNewPostsButtonEvent(this.showNewPostsButton);

  @override
  List<Object> get props => [showNewPostsButton];
}

//update publication
class UpdatePublicationDescriptionEvent extends PublicationEvent {
  final String uid;
  final String description;
  List<String>? imagePaths = [];
  List<String>? imagePathsDelete = [];
  UpdatePublicationDescriptionEvent(
      {required this.description,
      this.imagePaths,
      required this.uid,
      this.imagePathsDelete});

  @override
  List<Object> get props => [description];
}

//deletePublicacion
class DeletePublicacionEvent extends PublicationEvent {
  final String uid;
  const DeletePublicacionEvent(this.uid);

  @override
  List<Object> get props => [uid];
}
