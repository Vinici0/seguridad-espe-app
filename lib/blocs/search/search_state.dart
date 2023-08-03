part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool displayManualMarker;
  final List<Ubicacion> history;
  final List<Ubicacion> ubicacion;
  final bool isActivePolyline;
  final bool updateTypeMap;
  final bool isActiveNotification;

  const SearchState(
      {this.displayManualMarker = false,
      this.updateTypeMap = false,
      this.history = const [],
      this.isActiveNotification = false,
      this.isActivePolyline = false,
      this.ubicacion = const []});

  SearchState copyWith(
          {bool? displayManualMarker,
          List<Ubicacion>? history,
          isActivePolyline,
          isActiveNotification,
          updateTypeMap,
          List<Ubicacion>? ubicacion,
          List<Ubicacion>? places}) =>
      SearchState(
          displayManualMarker: displayManualMarker ?? this.displayManualMarker,
          history: history ?? this.history,
          updateTypeMap: updateTypeMap ?? this.updateTypeMap,
          isActiveNotification:
              isActiveNotification ?? this.isActiveNotification,
          isActivePolyline: isActivePolyline ?? this.isActivePolyline,
          ubicacion: ubicacion ?? this.ubicacion);

  @override
  List<Object> get props => [
        displayManualMarker,
        history,
        ubicacion,
        isActiveNotification,
        isActivePolyline,
        updateTypeMap
      ];
}
