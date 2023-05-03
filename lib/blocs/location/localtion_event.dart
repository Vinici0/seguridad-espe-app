part of 'localtion_bloc.dart';

abstract class LocaltionEvent extends Equatable {
  const LocaltionEvent();

  @override
  List<Object> get props => [];
}

class OnNewUserLocationEvent extends LocaltionEvent {
  //Se le pasa la nueva ubicación
  final LatLng newLocation;
  const OnNewUserLocationEvent(this.newLocation);
}

//Siguiendo al usuario
class OnStartFollowingUser extends LocaltionEvent {}

//Dejar de seguir al usuario
class OnStopFollowingUser extends LocaltionEvent {}
