part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool isFollowUser;
  final bool showRoutePreview;
  //Polylines
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;
  /*
    'mi_ruta: {
      id: polylineID Google,
      points: [ [lat,lng], [123123,123123], [123123,123123] ]
      width: 3
      color: black87
    },
  */
  const MapState({
    this.isMapInitialized = false,
    this.isFollowUser = true,
    this.showRoutePreview = true,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  })  : polylines = polylines ?? const {},
        markers = markers ?? const {};

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowUser,
    bool? showRoutePreview,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  }) =>
      MapState(
        showRoutePreview: showRoutePreview ?? this.showRoutePreview,
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        isFollowUser: isFollowUser ?? this.isFollowUser,
        polylines: polylines ?? this.polylines,
        markers: markers ?? this.markers,
      );

  @override
  List<Object> get props =>
      [isMapInitialized, isFollowUser, polylines, showRoutePreview, markers];
}

// class MapInitial extends MapState {}
