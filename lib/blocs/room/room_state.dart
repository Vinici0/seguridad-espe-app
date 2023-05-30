part of 'room_bloc.dart';

class RoomState extends Equatable {
  final List<Sala> salas;
  final List<MensajesSala> mensajesSalas;
  final Sala salaSeleccionada;
  final bool isLoading;
  final bool isError;

  const RoomState({
    required this.salas,
    required this.mensajesSalas,
    required this.salaSeleccionada,
    required this.isLoading,
    required this.isError,
  });

  RoomState copyWith({
    List<Sala>? salas,
    List<MensajesSala>? mensajesSalas,
    Sala? salaSeleccionada,
    bool? isLoading,
    bool? isError,
  }) {
    return RoomState(
      salas: salas ?? this.salas,
      mensajesSalas: mensajesSalas ?? this.mensajesSalas,
      salaSeleccionada: salaSeleccionada ?? this.salaSeleccionada,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object?> get props => [
        salas,
        mensajesSalas,
        salaSeleccionada,
        isLoading,
        isError,
      ];
}
