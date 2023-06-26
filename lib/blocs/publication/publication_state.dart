part of 'publication_bloc.dart';

// ignore: must_be_immutable
class PublicationState extends Equatable {
  final List<Publicacion> publicaciones;
  List<Comentario>? comentarios;
  Publicacion? currentPublicacion; //
  final bool isLoading; // Indicador de carga
  final bool isError; // Indicador de error

  PublicationState({
    required this.publicaciones,
    this.currentPublicacion,
    required this.isLoading,
    required this.isError,
    this.comentarios,
  });

  PublicationState copyWith({
    List<Publicacion>? publicaciones,
    Publicacion? currentPublicacion,
    bool? isLoading,
    bool? isError,
    List<Comentario>? comentarios,
  }) {
    return PublicationState(
      publicaciones: publicaciones ?? this.publicaciones,
      currentPublicacion: currentPublicacion ?? this.currentPublicacion,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      comentarios: comentarios ?? this.comentarios,
    );
  }

  @override
  List<Object?> get props => [
        publicaciones,
        currentPublicacion,
        isLoading,
        isError,
        comentarios,
      ];
}
