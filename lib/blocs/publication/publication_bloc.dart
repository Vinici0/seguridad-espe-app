import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_maps_adv/models/publication.dart';
import 'package:flutter_maps_adv/resources/services/publicacion.dart';

part 'publication_event.dart';
part 'publication_state.dart';

class PublicationBloc extends Bloc<PublicationEvent, PublicationState> {
  final PublicacionService _publicacionService = PublicacionService();
  PublicationBloc()
      : super(PublicationState(
            publicaciones: [],
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

    on<PublicacionesCreateEvent>(publicacionesCreateEvent);
  }

  FutureOr<void> publicacionesInitEvent(
      PublicacionesInitEvent event, Emitter<PublicationState> emit) async {
    emit(state.copyWith(isLoading: true));
    final publicaciones = await _publicacionService.getPublicacionesAll();
    emit(state.copyWith(publicaciones: publicaciones, isLoading: false));
  }

  FutureOr<void> publicacionesUpdateEvent(
      PublicacionesUpdate event, Emitter<PublicationState> emit) async {
    emit(state.copyWith(isLoading: true));
    final newSalaUpadate = await _publicacionService.likePublicacion(event.uid);

    final newPublicaciones = state.publicaciones.map((publicacion) {
      if (publicacion.uid == newSalaUpadate.uid) {
        return newSalaUpadate;
      } else {
        return publicacion;
      }
    }).toList();
    emit(state.copyWith(publicaciones: newPublicaciones, isLoading: false));
  }

  FutureOr<void> publicacionesCreateEvent(
      PublicacionesCreateEvent event, Emitter<PublicationState> emit) async {
    emit(state.copyWith(isLoading: true));
    final newPublicacion = await _publicacionService.createPublicacion(
      event.tipo,
      event.descripcion,
      event.color,
      event.icon,
      event.activo,
      event.visible,
      event.uid,
      event.path,
    );
    final newPublicaciones = [newPublicacion, ...state.publicaciones];
    emit(state.copyWith(publicaciones: newPublicaciones, isLoading: false));
  }
}
