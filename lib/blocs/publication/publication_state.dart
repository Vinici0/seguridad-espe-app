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
  final bool firstController;
  final bool showNewPostsButton;

  PublicationState({
    required this.publicaciones,
    this.currentPublicacion,
    required this.isLoading,
    required this.isError,
    this.comentarios,
    required this.publicacionesUsuario,
    this.comentariosP = const [],
    this.conuntComentarios = 0,
    this.firstController = false,
    this.showNewPostsButton = false,
  });

  PublicationState copyWith({
    List<Publicacion>? publicaciones,
    Publicacion? currentPublicacion,
    bool? isLoading,
    bool? isError,
    bool? firstController,
    bool? showNewPostsButton,
    List<Comentario>? comentarios,
    List<Publicacion>? publicacionesUsuario,
    List<CommentPublication>? comentariosP,
    int? conuntComentarios,
  }) {
    return PublicationState(
      publicaciones: publicaciones ?? this.publicaciones,
      currentPublicacion: currentPublicacion ?? this.currentPublicacion,
      isLoading: isLoading ?? this.isLoading,
      firstController: firstController ?? this.firstController,
      isError: isError ?? this.isError,
      showNewPostsButton: showNewPostsButton ?? this.showNewPostsButton,
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
        firstController,
        showNewPostsButton,
      ];
}
