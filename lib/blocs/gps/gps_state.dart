part of 'gps_bloc.dart';

//por usar equatable, no es necesario sobreescribir el metodo == y hashCode
class GpsState extends Equatable {
  final bool isGpsEnabled;
  final bool isGpsPermissionGranted;

  //Va a ser true cuando el gps este activo y el permiso tambien
  bool get isAllGranted => isGpsEnabled && isGpsPermissionGranted;

  const GpsState({
    required this.isGpsEnabled,
    required this.isGpsPermissionGranted,
  });

  GpsState copyWith({
    bool? isGpsEnabled,
    bool? isGpsPermissionGranted,
  }) =>
      GpsState(
        isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
        isGpsPermissionGranted:
            isGpsPermissionGranted ?? this.isGpsPermissionGranted,
      );

  @override
  List<Object> get props => [
        isGpsEnabled,
        isGpsPermissionGranted,
      ];
}
