import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_maps_adv/models/comentarios.dart';
import 'package:flutter_maps_adv/models/publication.dart';
import 'package:flutter_maps_adv/resources/services/publicacion.dart';
import 'package:flutter_maps_adv/widgets/comment_pulbicacion.dart';

part 'publication_event.dart';
part 'publication_state.dart';

class PublicationBloc extends Bloc<PublicationEvent, PublicationState> {
  final PublicacionService _publicacionService = PublicacionService();
  final List<CommentPublication> comentariosP = [];
  PublicationBloc()
      : super(PublicationState(
            publicaciones: const [],
            currentPublicacion: Publicacion(
              barrio: '',
              ciudad: '',
              color: '',
              contenido: '',
              imgAlerta: '',
              isLiked: false,
              isPublic: false,
              latitud: 0,
              longitud: 0,
              titulo: '',
              usuario: '',
            ),
            isLoading: false,
            isError: false)) {
    on<PublicacionesInitEvent>(publicacionesInitEvent);

    on<PublicacionesUpdate>(publicacionesUpdateEvent);

    on<ToggleLikeComentarioEvent>(_toggleLikeComentario);

    on<PublicacionesCreateEvent>(publicacionesCreateEvent);

    on<PublicacionSelectEvent>((event, emit) {
      emit(state.copyWith(currentPublicacion: event.publicacion));
    });

    on<LoadingEvent>((event, emit) {
      emit(state.copyWith(isLoading: true));
    });

    on<GetAllCommentsEvent>((event, emit) async {
      emit(state.copyWith(comentarios: event.comentarios, isLoading: false));
    });
  }

  FutureOr<void> publicacionesInitEvent(
      PublicacionesInitEvent event, Emitter<PublicationState> emit) async {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(publicaciones: event.publicaciones, isLoading: false));
  }

  FutureOr<void> publicacionesUpdateEvent(
      PublicacionesUpdate event, Emitter<PublicationState> emit) async {
    emit(state.copyWith(publicaciones: event.publicacion));
  }

  FutureOr<void> _toggleLikeComentario(
      ToggleLikeComentarioEvent event, Emitter<PublicationState> emit) async {
    emit(state.copyWith(comentarios: event.comentarios));
  }

  FutureOr<void> publicacionesCreateEvent(
      PublicacionesCreateEvent event, Emitter<PublicationState> emit) async {
    emit(state.copyWith(isLoading: true));

    emit(state.copyWith(publicaciones: event.publicacion, isLoading: false));
  }

  getAllPublicaciones() async {
    final publicaciones = await _publicacionService.getPublicacionesAll();
    add(PublicacionesInitEvent(publicaciones));
  }

  createpublication(String tipo, String descripcion, String color, String icon,
      bool activo, bool visible, String uid, List<String>? path) async {
    final newPublicacion = await _publicacionService.createPublicacion(
        tipo, descripcion, color, icon, activo, visible, uid, path);
    final newPublicaciones = [newPublicacion, ...state.publicaciones];
    add(PublicacionesCreateEvent(newPublicaciones));
  }

  cargarComentarios(String uid) async {
    final publicaciones = await _publicacionService.getAllComments(uid);
  }

  publicacionesUpdate(String uid) async {
    final newPublicacion = await _publicacionService.likePublicacion(uid);
    final newPublicaciones = state.publicaciones.map((publicacion) {
      if (publicacion.uid == newPublicacion.uid) {
        return newPublicacion;
      } else {
        return publicacion;
      }
    }).toList();
    add(PublicacionesUpdate(newPublicaciones));
  }

  //toggleLikeComentario
  toggleLikeComentario(String uid) async {
    final newComentario = await _publicacionService.toggleLikeComentario(uid);
    final newComentarios = state.comentarios!.map((comentario) {
      if (comentario.uid == newComentario.uid) {
        return newComentario;
      } else {
        return comentario;
      }
    }).toList();
    add(ToggleLikeComentarioEvent(newComentarios));
  }

  getAllComments(String uid) async {
    add(LoadingEvent());
    final List<Comentario> comentarios =
        await _publicacionService.getAllComments(uid);

    for (var element in comentarios) {
      final comment = CommentPublication(
        comentario: element.contenido,
        nombre: "Vincio",
        fotoPerfil: "assets/images/usuario.png",
        createdAt: element.createdAt,
        uid: element.uid,
        likes: element.likes!.length.toString(),
      );
      comentariosP.add(comment);
    }
    add(GetAllCommentsEvent(comentarios));
  }
}
