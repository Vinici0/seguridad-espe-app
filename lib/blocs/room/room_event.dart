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
  final String codigo;

  const SalaJoinEvent(this.codigo);

  @override
  List<Object> get props => [codigo];
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
  final String idSala;

  const ObtenerUsuariosSalaEvent(this.idSala);

  @override
  List<Object> get props => [idSala];
}

//esta cargando
class CargandoEvent extends RoomEvent {}

//limipiar mensajes de la sala
class LimpiarMensajesEvent extends RoomEvent {}
