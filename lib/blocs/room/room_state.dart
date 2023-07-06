part of 'room_bloc.dart';

class RoomState extends Equatable {
  final bool isError;
  final bool isLoading;
  final List<MensajesSala> mensajesSalas;
  final List<Sala> salas;
  final List<Usuario> usuariosSala;

  final Sala salaSeleccionada;

  const RoomState({
    required this.isError,
    required this.isLoading,
    required this.mensajesSalas,
    required this.salas,
    required this.usuariosSala,
    required this.salaSeleccionada,
  });

  RoomState copyWith({
    bool? isError,
    bool? isLoading,
    List<MensajesSala>? mensajesSalas,
    List<Sala>? salas,
    List<Usuario>? usuariosSala,
    Sala? salaSeleccionada,
  }) {
    return RoomState(
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      mensajesSalas: mensajesSalas ?? this.mensajesSalas,
      salas: salas ?? this.salas,
      usuariosSala: usuariosSala ?? this.usuariosSala,
      salaSeleccionada: salaSeleccionada ?? this.salaSeleccionada,
    );
  }

  //set and get salaseleccionada
  Sala get getSalaSeleccionada => salaSeleccionada;

  @override
  List<Object> get props => [
        salas,
        mensajesSalas,
        salaSeleccionada,
        isLoading,
        isError,
        usuariosSala,
      ];
}
