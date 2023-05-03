part of 'localtion_bloc.dart';

class LocaltionState extends Equatable {
  final bool followingUser; //Siguiendo al usuario
  final LatLng? lastKnownLocation;
  final List<LatLng> myLocationHistory;

  LocaltionState({
    this.followingUser = true,
    this.lastKnownLocation,
    myLocationHistory,
  }) : myLocationHistory = myLocationHistory ?? [];

  LocaltionState copyWith({
    bool? followingUser,
    LatLng? lastKnownLocation,
    List<LatLng>? myLocationHistory,
  }) {
    return LocaltionState(
      followingUser: followingUser ?? this.followingUser,
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      myLocationHistory: myLocationHistory ?? this.myLocationHistory,
    );
  }

  @override
  List<Object?> get props =>
      [followingUser, lastKnownLocation, myLocationHistory];
}
