part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool isFollowUser;
  final bool showRoutePreview;
  //Polylines
  final Map<String, Polyline> polylines;
  /*
    'mi_ruta: {
      id: polylineID Google,
      points: [ [lat,lng], [123123,123123], [123123,123123] ]
      width: 3
      color: black87
    },
  */
  const MapState(
      {this.isMapInitialized = false,
      this.isFollowUser = true,
      this.showRoutePreview = true,
      Map<String, Polyline>? polylines})
      : polylines = polylines ?? const {};

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowUser,
    bool? showRoutePreview,
    Map<String, Polyline>? polylines,
  }) =>
      MapState(
        showRoutePreview: showRoutePreview ?? this.showRoutePreview,
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        isFollowUser: isFollowUser ?? this.isFollowUser,
        polylines: polylines ?? this.polylines,
      );

  @override
  List<Object> get props =>
      [isMapInitialized, isFollowUser, polylines, showRoutePreview];
}

// class MapInitial extends MapState {}
