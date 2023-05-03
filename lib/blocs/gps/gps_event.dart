part of 'gps_bloc.dart';

abstract class GpsEvent extends Equatable {
  const GpsEvent();

  @override
  List<Object> get props => [];
}

class GpsPermissionGranted extends GpsEvent {
  final bool isGpsPermissionGranted;
  final bool isGpsEnabled;

  const GpsPermissionGranted({
    required this.isGpsPermissionGranted,
    required this.isGpsEnabled,
  });
}
