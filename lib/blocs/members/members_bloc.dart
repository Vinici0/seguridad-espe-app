import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_maps_adv/models/salas_mensaje_response.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:flutter_maps_adv/resources/services/chat_provider.dart';
import 'package:flutter_maps_adv/widgets/chat_message.dart';

part 'members_event.dart';
part 'members_state.dart';

class MembersBloc extends Bloc<MembersEvent, MembersState> {
  final ChatProvider _chatProvider = ChatProvider();
  final List<MensajesSala> mensajesAll = [];
  MembersBloc() : super(const MembersState()) {
    on<MembersEvent>((event, emit) {});

    on<MembersLoadingEvent>((event, emit) {
      emit(state.copyWith(isLoading: true));
    });

    on<MembersLoadedEvent>(_membersLoadedEvent);
    on<DeleteMemberEvent>(_deleteMemberEvent);
    on<LimpiarMensajesEvent>(_limpiarMensajesEvent);
    on<ChatGetMoreEvent>(_chatGetMoreEvent);
    on<ChatLoadedEvent>(_chatLoadedEvent);
    on<ChatInitEvent>(_chatInitEvent);
    on<ResetChatEvent>(_chatResetEvent);

    on<DeleteMemberByIdEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await _chatProvider.deleteUserById(event.id_sala, event.id_usuario);
      final newUsuarios = [...state.usuariosAll];
      newUsuarios.removeWhere((element) => element.uid == event.id_usuario);
      emit(state.copyWith(usuariosAll: newUsuarios, isLoading: false));
    });

    on<GetLoadedChatMessage>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final newMensajes = [...state.messages, ...event.messages];

      emit(state.copyWith(messages: newMensajes, isLoading: false));
    });
    on<AddMessageEvent>((event, emit) async {
      final newMensajes = [event.message, ...state.messages];
      emit(state.copyWith(messages: newMensajes));
    });
  }

  Future<List<Usuario>> _membersLoadedEvent(
      MembersLoadedEvent event, Emitter<MembersState> emit) async {
    emit(state.copyWith(usuariosAll: event.usuariosAll, isLoading: false));
    return event.usuariosAll;
  }

  Future<void> _deleteMemberEvent(
      DeleteMemberEvent event, Emitter<MembersState> emit) async {
    emit(state.copyWith(isLoading: true));
    await _chatProvider.deleteUsuarioSala(event.uid);
    final newUsuarios = [...state.usuariosAll];
    newUsuarios.removeWhere((element) => element.uid == event.uid);
    emit(state.copyWith(usuariosAll: newUsuarios, isLoading: false));
  }

  FutureOr<void> _limpiarMensajesEvent(
      LimpiarMensajesEvent event, Emitter<MembersState> emit) async {
    emit(state.copyWith(mensajesSalas: []));
  }

  FutureOr<void> _chatGetMoreEvent(
      ChatGetMoreEvent event, Emitter<MembersState> emit) async {
    emit(state.copyWith(mensajesSalas: event.mensajes, isLoading: false));
  }

  FutureOr<void> _chatInitEvent(
      ChatInitEvent event, Emitter<MembersState> emit) async {
    final List<MensajesSala> mensajes = [];
    emit(state.copyWith(mensajesSalas: mensajes, isLoading: false));
  }

  FutureOr<void> _chatResetEvent(
      ResetChatEvent event, Emitter<MembersState> emit) async {
    final List<MensajesSala> mensajesReset = [];
    final List<ChatMessage> mensajesReset2 = [];
    emit(state.copyWith(
        mensajesSalas: mensajesReset,
        messages: mensajesReset2,
        isLoading: false));
  }

  cargarUsuariosSala(String uid) async {
    add(MembersLoadingEvent());
    final usuariosA = await _chatProvider.getUsuariosSala(uid);
    add(MembersLoadedEvent(usuariosA));
    return usuariosA;
  }

  FutureOr<void> _chatLoadedEvent(
      ChatLoadedEvent event, Emitter<MembersState> emit) async {
    emit(state.copyWith(mensajesSalas: event.mensajes, isLoading: false));
  }

  chatGetMore(String salaID) async {
    add(MembersLoadingEvent());
    final mensajes = await _chatProvider.getChatSala(salaID: salaID);
    if (mensajes.isEmpty) {
      add(MembersLoadingEvent());
      return;
    }
    mensajesAll.insertAll(0, mensajes);
    final newMensajes = [...state.mensajesSalas, ...mensajes];
    add(ChatGetMoreEvent(newMensajes));
  }

  getNextChat(String salaID) async {
    add(MembersLoadingEvent());
    final mensajes = await _chatProvider.getChatSala(
        salaID: salaID, next: mensajesAll.length);

    if (mensajes.isEmpty) {
      add(MembersLoadingEvent());
      return;
    }

    final history = mensajes.map((m) => ChatMessage(
          texto: m.mensaje,
          uid: m.usuario,
          nombre: m.nombre,
          img: m.img,
          isGoogle: m.isGoogle,
          createdAt: m.createdAt,
        ));

    add(GetLoadedChatMessage(history.toList()));
    mensajesAll.insertAll(0, mensajes);
    final newMensajes = [...state.mensajesSalas, ...mensajes];
    add(ChatGetMoreEvent(newMensajes));
  }

  cargarMensajes(String uid) async {
    // mensajesAll.clear();
    add(MembersLoadingEvent());
    final mensajes = await _chatProvider.getChatSala(salaID: uid);
    final history = mensajes.map((m) => ChatMessage(
          texto: m.mensaje,
          uid: m.usuario,
          nombre: m.nombre,
          isGoogle: m.isGoogle,
          createdAt: m.createdAt,
          img: m.img,
        ));
    add(GetLoadedChatMessage(history.toList()));
    add(ChatLoadedEvent(mensajes));
    return mensajes;
  }

  closeList() {
    add(MembersLoadingEvent());
    add(ResetChatEvent());
    mensajesAll.clear();
  }
}
