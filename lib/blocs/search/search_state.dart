part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool displayManualMarker;
  final List<Ubicacion> history;
  final List<Ubicacion> ubicacion;

  const SearchState(
      {this.displayManualMarker = false,
      this.history = const [],
      this.ubicacion = const []});

  SearchState copyWith(
          {bool? displayManualMarker,
          List<Ubicacion>? history,
          List<Ubicacion>? ubicacion,
          List<Ubicacion>? places}) =>
      SearchState(
          displayManualMarker: displayManualMarker ?? this.displayManualMarker,
          history: history ?? this.history,
          ubicacion: ubicacion ?? this.ubicacion);

  @override
  List<Object> get props => [displayManualMarker, history, ubicacion];
}
