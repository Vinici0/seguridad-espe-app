part of 'publication_bloc.dart';

// ignore: must_be_immutable
class PublicationState extends Equatable {
  final List<Publicacion> publicaciones;
  final List<Publicacion> publicacionesUsuario;
  List<Comentario>? comentarios;
  Publicacion? currentPublicacion;
  final List<CommentPublication> comentariosP;
  final bool isLoading;
  final bool isError;
  final int conuntComentarios;

  PublicationState({
    required this.publicaciones,
    this.currentPublicacion,
    required this.isLoading,
    required this.isError,
    this.comentarios,
    required this.publicacionesUsuario,
    this.comentariosP = const [],
    this.conuntComentarios = 0,
  });

  PublicationState copyWith({
    List<Publicacion>? publicaciones,
    Publicacion? currentPublicacion,
    bool? isLoading,
    bool? isError,
    List<Comentario>? comentarios,
    List<Publicacion>? publicacionesUsuario,
    List<CommentPublication>? comentariosP,
    int? conuntComentarios,
  }) {
    return PublicationState(
      publicaciones: publicaciones ?? this.publicaciones,
      currentPublicacion: currentPublicacion ?? this.currentPublicacion,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      comentarios: comentarios ?? this.comentarios,
      comentariosP: comentariosP ?? this.comentariosP,
      publicacionesUsuario: publicacionesUsuario ?? this.publicacionesUsuario,
      conuntComentarios: conuntComentarios ?? this.conuntComentarios,
    );
  }

  @override
  List<Object?> get props => [
        publicaciones,
        currentPublicacion,
        isLoading,
        isError,
        comentarios,
        publicacionesUsuario,
        conuntComentarios,
        comentariosP,
      ];
}
