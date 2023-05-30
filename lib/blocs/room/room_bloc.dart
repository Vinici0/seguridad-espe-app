import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_maps_adv/models/salas_mensaje_response.dart';
import 'package:flutter_maps_adv/models/sales_response.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:flutter_maps_adv/resources/services/chat_provider.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final ChatProvider _chatProvider = ChatProvider();
  RoomBloc()
      : super(RoomState(
            salas: [],
            mensajesSalas: [],
            salaSeleccionada: Sala(
                nombre: '', codigo: '', color: '', uid: '', propietario: ''),
            isLoading: false,
            isError: false,
            usuariosSala: [])) {
    on<SalasInitEvent>(salasInitEvent);
    on<ChatInitEvent>(chatInitEvent);
    on<SalaCreateEvent>(salaCreateEvent);
    on<SalaJoinEvent>(salaJoinEvent);
    on<SalaSelectEvent>(salaSelectEvent);
    on<ObtenerUsuariosSalaEvent>(obtenerUsuariosSalaEvent);
  }

  FutureOr<void> salasInitEvent(
      SalasInitEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
    final salas = await _chatProvider.getSalesAll();
    emit(state.copyWith(salas: salas, isLoading: false));
  }

  FutureOr<void> chatInitEvent(
      ChatInitEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
    final mensajesSalas = await _chatProvider.getChatSala(event.uid);
    emit(state.copyWith(mensajesSalas: mensajesSalas, isLoading: false));
  }

  FutureOr<void> salaCreateEvent(
      SalaCreateEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
    final newSala = await _chatProvider.createSala(event.nombre);
    final newSalas = [...state.salas, newSala];
    emit(state.copyWith(salas: newSalas, isLoading: false));
  }

  FutureOr<void> salaJoinEvent(
      SalaJoinEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
    final newSala = await _chatProvider.joinSala(event.codigo);
    final newSalas = [...state.salas, newSala];
    emit(state.copyWith(salas: newSalas, isLoading: false));
  }

  FutureOr<void> salaSelectEvent(
      SalaSelectEvent event, Emitter<RoomState> emit) {
    emit(state.copyWith(salaSeleccionada: event.salaSeleccionada));
  }

  FutureOr<void> obtenerUsuariosSalaEvent(
      ObtenerUsuariosSalaEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
    final usuariosSala = await _chatProvider.getUsuariosSala(event.idSala);
    emit(state.copyWith(usuariosSala: usuariosSala, isLoading: false));
  }
}
