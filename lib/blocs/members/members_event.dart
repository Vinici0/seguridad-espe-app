part of 'members_bloc.dart';

abstract class MembersEvent extends Equatable {
  const MembersEvent();

  @override
  List<Object> get props => [];
}

class MembersInitEvent extends MembersEvent {}

//loader
class MembersLoadingEvent extends MembersEvent {}

class MembersLoadedEvent extends MembersEvent {
  final List<Usuario> usuariosAll;

  const MembersLoadedEvent(this.usuariosAll);

  @override
  List<Object> get props => [usuariosAll];
}

//deleteMember
class DeleteMemberEvent extends MembersEvent {
  final String uid;

  const DeleteMemberEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

class ChatInitEvent extends MembersEvent {}

class ChatLoadedEvent extends MembersEvent {
  final List<MensajesSala> mensajes;

  const ChatLoadedEvent(this.mensajes);

  @override
  List<Object> get props => [mensajes];
}

class GetLoadedChatMessage extends MembersEvent {
  final List<ChatMessage> messages;

  const GetLoadedChatMessage(this.messages);

  @override
  List<Object> get props => [messages];
}

class ResetChatEvent extends MembersEvent {}

class AddMessageEvent extends MembersEvent {
  final ChatMessage message;

  const AddMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}

class LimpiarMensajesEvent extends MembersEvent {
  const LimpiarMensajesEvent();

  @override
  List<Object> get props => [];
}

class ChatGetMoreEvent extends MembersEvent {
  final List<MensajesSala> mensajes;

  const ChatGetMoreEvent(this.mensajes);

  @override
  List<Object> get props => [mensajes];
}
