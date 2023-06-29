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
  List<Comentario> comentarios = [];
  PublicationBloc()
      : super(PublicationState(
            publicacionesUsuario: const [],
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

    on<PublicacionesUpdateEvent>(publicacionesUpdateEvent);

    on<ToggleLikeComentarioEvent>(_toggleLikeComentario);

    on<PublicacionesCreateEvent>(publicacionesCreateEvent);

    on<PublicacionSelectEvent>((event, emit) {
      emit(state.copyWith(currentPublicacion: event.publicacion));
    });

    on<LoadingEvent>((event, emit) {
      emit(state.copyWith(isLoading: true));
    });

    on<GetAllCommentsEvent>((event, emit) {
      emit(state.copyWith(comentarios: event.comentarios, isLoading: false));
    });

    on<PublicacionesUsuarioEvent>((event, emit) {
      emit(state.copyWith(
          publicacionesUsuario: event.publicacionesUsuario, isLoading: false));
    });

    on<CountCommentEvent>((event, emit) {
      emit(state.copyWith(
          conuntComentarios: event.conuntComentarios, isLoading: false));
    });
  }

  FutureOr<void> publicacionesInitEvent(
      PublicacionesInitEvent event, Emitter<PublicationState> emit) {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(publicaciones: event.publicaciones, isLoading: false));
  }

  FutureOr<void> publicacionesUpdateEvent(
      PublicacionesUpdateEvent event, Emitter<PublicationState> emit) async {
    await _publicacionService.likePublicacion(event.uid);
  }

  FutureOr<void> _toggleLikeComentario(
      ToggleLikeComentarioEvent event, Emitter<PublicationState> emit) {
    emit(state.copyWith(comentarios: event.comentarios));
  }

  FutureOr<void> publicacionesCreateEvent(
      PublicacionesCreateEvent event, Emitter<PublicationState> emit) {
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

  // publicacionesUpdate(String uid) async {
  //   final newPublicacion = await _publicacionService.likePublicacion(uid);
  //   final newPublicaciones = state.publicaciones.map((publicacion) {
  //     if (publicacion.uid == newPublicacion.uid) {
  //       return newPublicacion;
  //     } else {
  //       return publicacion;
  //     }
  //   }).toList();
  //   add(PublicacionesUpdate(newPublicaciones));
  // }

  getPublicacionesUsuario() async {
    add(LoadingEvent());
    final publicaciones = await _publicacionService.getPublicacionesUsuario();
    add(PublicacionesUsuarioEvent(publicaciones));
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
    final List<Comentario> comentariosL =
        await _publicacionService.getAllComments(uid);

    for (var element in comentariosL) {
      final comment = CommentPublication(
        comentario: element.contenido,
        nombre: "Vincio",
        fotoPerfil: "assets/images/usuario.png",
        createdAt: element.createdAt,
        uid: element.uid,
        likes: element.likes!.length,
      );
      comentariosP.add(comment);
    }
    add(CountCommentEvent(comentariosP.length));
    add(GetAllCommentsEvent(comentarios));
    comentarios.addAll(comentariosL);
  }
}
