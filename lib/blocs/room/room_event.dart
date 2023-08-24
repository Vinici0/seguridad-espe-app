part of 'room_bloc.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class SalasInitEvent extends RoomEvent {
  final List<Sala> salas;

  const SalasInitEvent(this.salas);

  @override
  List<Object> get props => [salas];
}

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

class CargandoEvent extends RoomEvent {}

class CargandoEventFalse extends RoomEvent {}

class DeleteSalaEvent extends RoomEvent {
  final String uid;

  const DeleteSalaEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

class RoomLoadingEvent extends RoomEvent {}

class RoomLoadingEvent2 extends RoomEvent {}

class AbandonarSalaEvent extends RoomEvent {
  final String uid;

  const AbandonarSalaEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

class ResetTotalMensajesNoLeidosEvent extends RoomEvent {
  final String uid;
  const ResetTotalMensajesNoLeidosEvent(this.uid);
  @override
  List<Object> get props => [uid];
}
