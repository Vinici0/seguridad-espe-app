part of 'publication_bloc.dart';

class PublicationState extends Equatable {
  final List<Publicacion> publicaciones;
  final Publicacion currentPublicacion;
  final bool isLoading; // Indicador de carga
  final bool isError; // Indicador de error

  const PublicationState({
    required this.publicaciones,
    required this.currentPublicacion,
    required this.isLoading,
    required this.isError,
  });

  PublicationState copyWith({
    List<Publicacion>? publicaciones,
    Publicacion? currentPublicacion,
    bool? isLoading,
    bool? isError,
  }) {
    return PublicationState(
      publicaciones: publicaciones ?? this.publicaciones,
      currentPublicacion: currentPublicacion ?? this.currentPublicacion,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object?> get props => [
        publicaciones,
        currentPublicacion,
        isLoading,
        isError,
      ];
}
