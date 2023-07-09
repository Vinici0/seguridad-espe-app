part of 'room_bloc.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class SalasInitEvent extends RoomEvent {}

class ChatInitEvent extends RoomEvent {}

class ChatLoadedEvent extends RoomEvent {
  final List<MensajesSala> mensajes;

  const ChatLoadedEvent(this.mensajes);

  @override
  List<Object> get props => [mensajes];
}

class SalaCreateEvent extends RoomEvent {
  final String nombre;

  const SalaCreateEvent(this.nombre);

  @override
  List<Object> get props => [nombre];
}

class SalaJoinEvent extends RoomEvent {
  final List<Sala> salas;

  const SalaJoinEvent(this.salas);

  @override
  List<Object> get props => [salas];
}

class ChatCreate extends RoomEvent {
  final MensajesSala mensaje;

  const ChatCreate(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}

class SalaSelectEvent extends RoomEvent {
  final Sala salaSeleccionada;

  const SalaSelectEvent(this.salaSeleccionada);

  @override
  List<Object> get props => [salaSeleccionada];
}

class ObtenerUsuariosSalaEvent extends RoomEvent {
  final List<Usuario> usuarioAll;

  const ObtenerUsuariosSalaEvent(this.usuarioAll);

  @override
  List<Object> get props => [usuarioAll];
}

//esta cargando
class CargandoEvent extends RoomEvent {}

class LimpiarMensajesEvent extends RoomEvent {}

class DeleteSalaEvent extends RoomEvent {
  final String uid;

  const DeleteSalaEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

class ChatGetMoreEvent extends RoomEvent {
  final List<MensajesSala> mensajes;

  const ChatGetMoreEvent(this.mensajes);

  @override
  List<Object> get props => [mensajes];
}

class GetLoadedChatMessage extends RoomEvent {
  final List<ChatMessage> messages;

  const GetLoadedChatMessage(this.messages);

  @override
  List<Object> get props => [messages];
}

//agregar un mensajeChartMessage
class AddMessageEvent extends RoomEvent {
  final ChatMessage message;

  const AddMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}
