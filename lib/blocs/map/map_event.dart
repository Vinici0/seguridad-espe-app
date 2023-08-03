part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitialzedEvent extends MapEvent {
  //Sirve para controlar el mapa y sus funciones
  final GoogleMapController controller;
  const OnMapInitialzedEvent(this.controller);
}

class OnStopFollowingUserEvent extends MapEvent {}

class OnStartFollowingUserEvent extends MapEvent {}

class UpdateUserPolylineEvent extends MapEvent {
  final List<LatLng>
      userLocations; //Todas las ubicaciones del usuario en tiempo real
  const UpdateUserPolylineEvent(this.userLocations);
}

class OpToggleUserRouteEvent extends MapEvent {}

//reiniciar polylines
class OnMapMovedEvent extends MapEvent {}

class DisplayPolylinesEvent extends MapEvent {
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;
  const DisplayPolylinesEvent(this.polylines, this.markers);
}

class ActivePolylineEvent extends MapEvent {
  const ActivePolylineEvent();

  @override
  List<Object> get props => [];
}
