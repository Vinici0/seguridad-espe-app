part of 'room_bloc.dart';

class RoomState extends Equatable {
  final bool isError;
  final bool isLoading;
  final List<Sala> salas;
  final Sala salaSeleccionada;

  const RoomState({
    required this.isError,
    required this.isLoading,
    required this.salas,
    required this.salaSeleccionada,
  });

  RoomState copyWith({
    bool? isError,
    bool? isLoading,
    List<Sala>? salas,
    List<Usuario>? usuariosSala,
    Sala? salaSeleccionada,
  }) {
    return RoomState(
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      salas: salas ?? this.salas,
      salaSeleccionada: salaSeleccionada ?? this.salaSeleccionada,
    );
  }

  //set and get salaseleccionada
  Sala get getSalaSeleccionada => salaSeleccionada;

  @override
  List<Object> get props => [
        salas,
        salaSeleccionada,
        isLoading,
        isError,
      ];
}
