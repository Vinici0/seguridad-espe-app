import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_maps_adv/models/salas_mensaje_response.dart';
import 'package:flutter_maps_adv/models/sales_response.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:flutter_maps_adv/resources/services/chat_provider.dart';
import 'package:flutter_maps_adv/widgets/comment_pulbicacion.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final ChatProvider _chatProvider = ChatProvider();
  final List<MensajesSala> mensajesAll = [];
  final List<Usuario> usuariosAllSala = [];

  final initSate = RoomState(
    salas: const [],
    mensajesSalas: const [],
    salaSeleccionada: Sala(
        nombre: '',
        codigo: '',
        color: '',
        idUsuario: '',
        propietario: '',
        uid: ''),
    isLoading: false,
    isError: false,
    usuariosSala: const [],
  );
  RoomBloc()
      : super(RoomState(
            salas: const [],
            mensajesSalas: const [],
            salaSeleccionada: Sala(
                nombre: '',
                codigo: '',
                color: '',
                idUsuario: '',
                propietario: '',
                uid: ''),
            isLoading: false,
            isError: false,
            usuariosSala: const [])) {
    on<SalasInitEvent>(_salasInitEvent);
    on<ChatInitEvent>(_chatInitEvent);
    on<ChatLoadedEvent>(_chatLoadedEvent);
    on<CargandoEvent>((event, emit) {
      emit(state.copyWith(isLoading: true));
    });
    on<SalaCreateEvent>(_salaCreateEvent);
    on<SalaJoinEvent>(_salaJoinEvent);
    on<SalaSelectEvent>(_salaSelectEvent);
    on<ObtenerUsuariosSalaEvent>(_obtenerUsuariosSalaEvent);
    on<LimpiarMensajesEvent>(_limpiarMensajesEvent);
  }

  FutureOr<void> _salasInitEvent(
      SalasInitEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
    final salas = await _chatProvider.getSalesAll();
    emit(state.copyWith(salas: salas, isLoading: false));
  }

  FutureOr<void> _chatInitEvent(ChatInitEvent event, Emitter<RoomState> emit) {
    final List<MensajesSala> mensajes = [];
    emit(state.copyWith(mensajesSalas: mensajes, isLoading: false));
  }

  FutureOr<void> _chatLoadedEvent(
      ChatLoadedEvent event, Emitter<RoomState> emit) {
    emit(state.copyWith(mensajesSalas: event.mensajes, isLoading: false));
  }

  FutureOr<void> _salaCreateEvent(
      SalaCreateEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
    final newSala = await _chatProvider.createSala(event.nombre);
    final newSalas = [...state.salas, newSala];
    emit(state.copyWith(salas: newSalas, isLoading: false));
  }

  FutureOr<void> _salaJoinEvent(
      SalaJoinEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
    final newSala = await _chatProvider.joinSala(event.codigo);
    final newSalas = [...state.salas, newSala];
    emit(state.copyWith(salas: newSalas, isLoading: false));
  }

  FutureOr<void> _salaSelectEvent(
      SalaSelectEvent event, Emitter<RoomState> emit) {
    emit(state.copyWith(salaSeleccionada: event.salaSeleccionada));
  }

  FutureOr<void> _obtenerUsuariosSalaEvent(
      ObtenerUsuariosSalaEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
  }

  FutureOr<void> _limpiarMensajesEvent(
      LimpiarMensajesEvent event, Emitter<RoomState> emit) {
    emit(state.copyWith(mensajesSalas: []));
  }

  // cargar mensajes
  cargarMensajes(String uid) async {
    mensajesAll.clear();
    add(CargandoEvent());
    final mensajes = await _chatProvider.getChatSala(uid);
    mensajesAll.addAll(mensajes);
    add(ChatLoadedEvent(mensajes));
    return mensajes;
  }

  cargarUsuariosSala(String uid) async {
    add(CargandoEvent());
    final usuarios = await _chatProvider.getUsuariosSala(uid);
    usuariosAllSala = usuarios;
    return usuarios;
  }
}
