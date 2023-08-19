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
              isPublicacionPendiente: false,
              nombreUsuario: '',
            ),
            isLoading: false,
            isError: false)) {
    on<PublicacionesInitEvent>(_publicacionesInitEvent);

    on<PublicacionesUpdateEvent>(_publicacionesUpdateEvent);

    on<ToggleLikeComentarioEvent>(_toggleLikeComentario);

    on<PublicacionesCreateEvent>(_publicacionesCreateEvent);

    on<UpdateLikesPublicationEvent>(_updateLikesPublicationEvent);

    on<GoToStartListEvent>((event, emit) async {
      emit(state.copyWith(firstController: event.firstController));
      //despues de 1 se cambia a false
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(firstController: false));
    });

    on<LoadingEventFalse>((event, emit) {
      emit(state.copyWith(isLoading: false));
    });

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

    on<PublicationGetMoreEvent>((event, emit) {
      //agrega las nuevas publicaciones a la lista
      final newPublicaciones = [...state.publicaciones, ...event.publicaciones];
      emit(state.copyWith(publicaciones: newPublicaciones, isLoading: false));
    });

    on<ShowNewPostsButtonEvent>((event, emit) {
      emit(state.copyWith(showNewPostsButton: event.showNewPostsButton));
    });

    on<AddCommentPublicationEvent>((event, emit) {
      try {
        final List<CommentPublication> newComentarios = [
          event.commentPublication,
          ...state.comentariosP,
        ];
        emit(state.copyWith(comentariosP: newComentarios, isLoading: false));
      } catch (e) {
        print('Error al agregar comentario: $e');
      }
    });

    on<UpdatePublicationEvent>((event, emit) {
      final newPublicaciones = state.publicaciones.map((publicacion) {
        if (publicacion.uid == event.publicacion.uid) {
          return event.publicacion;
        } else {
          return publicacion;
        }
      }).toList();
      emit(state.copyWith(publicaciones: newPublicaciones, isLoading: false));
    });

    on<ResetCommentPublicationEvent>((event, emit) {
      emit(state.copyWith(comentariosP: [], isLoading: false));
    });

    on<MarcarPublicacionPendienteTrueEvent>((event, emit) async {
      final newPublicaciones = state.publicaciones.map((publicacion) {
        if (publicacion.uid == event.uid) {
          publicacion.isPublicacionPendiente = true;
          return publicacion;
        } else {
          return publicacion;
        }
      }).toList();

      //cambiar el currentPublicacion
      final newCurrentPublicacion =
          state.currentPublicacion!.copyWith(isPublicacionPendiente: true);

      emit(state.copyWith(
          publicaciones: newPublicaciones,
          isLoading: false,
          currentPublicacion: newCurrentPublicacion));

      await _publicacionService.marcarPublicacionPendienteTrue(event.uid);
    });

    on<DeletePublicacionEvent>((event, emit) async {
      final newPublicaciones = state.publicaciones
          .where((publicacion) => publicacion.uid != event.uid)
          .toList();
      emit(state.copyWith(publicaciones: newPublicaciones, isLoading: false));
      await _publicacionService.deletePublicacion(event.uid);
    });

    on<UpdatePublicationDescriptionEvent>((event, emit) async {
      final newPublicaciones = state.publicaciones.map((publicacion) {
        if (publicacion.uid == event.uid) {
          publicacion.contenido = event.description;
          return publicacion;
        } else {
          return publicacion;
        }
      }).toList();

      //cambiar el currentPublicacion
      final newCurrentPublicacion =
          state.currentPublicacion!.copyWith(contenido: event.description);

      emit(state.copyWith(
          publicaciones: newPublicaciones,
          isLoading: false,
          currentPublicacion: newCurrentPublicacion));

      await _publicacionService.updatePublicacion(event.uid, event.description);
    });
  }

  FutureOr<void> _publicacionesInitEvent(
      PublicacionesInitEvent event, Emitter<PublicationState> emit) {
    emit(state.copyWith(publicaciones: event.publicaciones, isLoading: false));
  }

  FutureOr<void> _publicacionesUpdateEvent(
      PublicacionesUpdateEvent event, Emitter<PublicationState> emit) async {
    await _publicacionService.likePublicacion(event.uid);
  }

  FutureOr<void> _toggleLikeComentario(
      ToggleLikeComentarioEvent event, Emitter<PublicationState> emit) {
    emit(state.copyWith(comentarios: event.comentarios));
  }

  FutureOr<void> _publicacionesCreateEvent(
      PublicacionesCreateEvent event, Emitter<PublicationState> emit) {
    emit(state.copyWith(publicaciones: event.publicacion, isLoading: false));
  }

  FutureOr<void> _updateLikesPublicationEvent(
      UpdateLikesPublicationEvent event, Emitter<PublicationState> emit) {
    final newPublicaciones = state.publicaciones.map((publicacion) {
      if (publicacion.uid == event.publicacion.uid) {
        return event.publicacion;
      } else {
        return publicacion;
      }
    }).toList();
    emit(state.copyWith(publicaciones: newPublicaciones, isLoading: false));
  }

  reportPublicationEvent(String uid, String motivo) async {
    final result = await _publicacionService.guardarDenuncia(uid, motivo);
    return result;
  }

  getAllPublicaciones() async {
    add(LoadingEvent());
    final publicaciones = await _publicacionService.getPublicacionesAll();
    add(PublicacionesInitEvent(publicaciones));
  }

  getNextPublicaciones() async {
    add(LoadingEvent());
    final publicaciones = await _publicacionService.getPublicacionesAll(
        publicationNext: state.publicaciones.length);
    if (publicaciones.isEmpty) {
      add(LoadingEventFalse());
      return;
    }
    add(PublicationGetMoreEvent(publicaciones));
  }

  Future<void> createPublication(
    String tipo,
    String descripcion,
    String color,
    String icon,
    bool isPublic,
    bool visible,
    String uid,
    String nombreUsuario,
    List<String>? path,
  ) async {
    add(LoadingEvent());
    try {
      final newPublicacion = await _publicacionService.createPublicacion(
        tipo,
        descripcion,
        color,
        icon,
        isPublic,
        visible,
        uid,
        nombreUsuario,
        path,
      );
      if (newPublicacion.uid != '' && newPublicacion.uid != null) {
        final newPublicaciones = [newPublicacion, ...state.publicaciones];
        add(PublicacionesCreateEvent(newPublicaciones));
      }
    } catch (e) {}
  }

  cargarComentarios(String uid) async {
    await _publicacionService.getAllComments(uid);
  }

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
    add(const ResetCommentPublicationEvent());
    add(LoadingEvent());
    final List<Comentario> comentariosL =
        await _publicacionService.getAllComments(uid);
    for (var element in comentariosL) {
      final comment = CommentPublication(
          comentario: element.contenido,
          nombre: element.usuario.nombre,
          fotoPerfil:
              element.usuario.google ? element.usuario.img : element.usuario.id,
          createdAt: element.createdAt,
          uidUsuario: element.usuario.id,
          likes: element.likes!,
          uid: element.uid,
          isGoogle: element.usuario.google,
          isLiked: false);

      add(AddCommentPublicationEvent(comment));
    }
    add(CountCommentEvent(state.comentariosP.length));
    add(GetAllCommentsEvent(comentariosL));
  }

  get currentPublicacion => state.currentPublicacion;

  createComentarioService(String contenido, String publicacionId) async {
    final newComentario =
        await _publicacionService.createComentario(contenido, publicacionId);
    return newComentario;
  }
}
