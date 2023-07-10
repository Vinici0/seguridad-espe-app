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
  final List<MensajesSala> mensajesAll = [];

  final initSate = RoomState(
    salas: const [],
    salaSeleccionada: Sala(
        nombre: '',
        codigo: '',
        color: '',
        idUsuario: '',
        propietario: '',
        uid: ''),
    isLoading: false,
    isError: false,
  );
  RoomBloc()
      : super(RoomState(
            salas: const [],
            salaSeleccionada: Sala(
                nombre: '',
                codigo: '',
                color: '',
                idUsuario: '',
                propietario: '',
                uid: ''),
            isLoading: false,
            isError: false)) {
    on<SalasInitEvent>(_salasInitEvent);
    on<CargandoEvent>((event, emit) {
      emit(state.copyWith(isLoading: true));
    });
    on<SalaCreateEvent>(_salaCreateEvent);
    on<SalaJoinEvent>(_salaJoinEvent);
    on<SalaSelectEvent>(_salaSelectEvent);
    on<ObtenerUsuariosSalaEvent>(_obtenerUsuariosSalaEvent);
    on<DeleteSalaEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final salas = await _chatProvider.deleteSala(event.uid);

      final newSalas = [...state.salas];
      newSalas.removeWhere((element) => element.uid == event.uid);
      emit(state.copyWith(salas: newSalas, isLoading: false));
    });
  }

  FutureOr<void> _salasInitEvent(
      SalasInitEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
    final salas = await _chatProvider.getSalesAll();
    emit(state.copyWith(salas: salas, isLoading: false));
  }

  FutureOr<void> _salaCreateEvent(
      SalaCreateEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
    final newSala = await _chatProvider.createSala(event.nombre);
    if (newSala == null || newSala.uid.isEmpty) {
      emit(state.copyWith(isLoading: false));
      return;
    }
    final newSalas = [...state.salas, newSala];
    emit(state.copyWith(salas: newSalas as List<Sala>, isLoading: false));
  }

  FutureOr<void> _salaJoinEvent(
      SalaJoinEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(salas: event.salas, isLoading: false));
  }

  FutureOr<void> _salaSelectEvent(
      SalaSelectEvent event, Emitter<RoomState> emit) {
    emit(state.copyWith(salaSeleccionada: event.salaSeleccionada));
  }

  FutureOr<void> _obtenerUsuariosSalaEvent(
      ObtenerUsuariosSalaEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
  }

  FutureOr<void> _deleteSalaEvent(
      DeleteSalaEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
    final salas = await _chatProvider.deleteSala(event.uid);

    final newSalas = [...state.salas];
    newSalas.removeWhere((element) => element.uid == event.uid);
    emit(state.copyWith(salas: newSalas, isLoading: false));
  }

  joinSala(String codigo) async {
    add(CargandoEvent());
    final sala = await _chatProvider.joinSala(codigo);
    if (sala == null || sala.uid.isEmpty) {
      add(CargandoEvent());
      return false;
    }
    final newSalas = [...state.salas, sala];
    add(SalaJoinEvent(newSalas));
    return true;
  }
}
