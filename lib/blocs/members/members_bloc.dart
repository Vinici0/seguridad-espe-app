import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:flutter_maps_adv/resources/services/chat_provider.dart';
import 'package:flutter_maps_adv/widgets/chat_message.dart';

part 'members_event.dart';
part 'members_state.dart';

class MembersBloc extends Bloc<MembersEvent, MembersState> {
  final ChatProvider _chatProvider = ChatProvider();
  MembersBloc() : super(MembersState()) {
    on<MembersEvent>((event, emit) {});

    on<MembersLoadingEvent>((event, emit) {
      emit(state.copyWith(isLoading: true));
    });

    on<MembersLoadedEvent>(_membersLoadedEvent);
    on<DeleteMemberEvent>(_deleteMemberEvent);
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

  cargarUsuariosSala(String uid) async {
    add(MembersLoadingEvent());
    final usuariosA = await _chatProvider.getUsuariosSala(uid);
    add(MembersLoadedEvent(usuariosA));
    return usuariosA;
  }
}
