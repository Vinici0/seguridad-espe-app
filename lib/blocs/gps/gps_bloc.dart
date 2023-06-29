import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsSubscription;

  GpsBloc()
      : super(const GpsState(
            isGpsEnabled: false, isGpsPermissionGranted: false)) {
    on<GpsPermissionGranted>((event, emit) {
      emit(state.copyWith(
          isGpsEnabled: event.isGpsEnabled,
          isGpsPermissionGranted: event.isGpsPermissionGranted));
    });

    init();
  }

  /*
    Cuando se crea el init revisa el estado y manda la rcreacion del nuevo estado
   */
  Future<void> init() async {
    final gpsInitState =
        await Future.wait([_checkGpsPermission(), _isPermissionGranted()]);

    // print("El estado del gps es: ${gpsInitState[0]}" +
    //     "y el permiso es: ${gpsInitState[1]}");
    //Dispara el evento
    add(GpsPermissionGranted(
        //El estado que este actualmente
        isGpsPermissionGranted: gpsInitState[1],
        isGpsEnabled: gpsInitState[0]));
  }

  Future<bool> _isPermissionGranted() async {
    //Sirve para saber si el permiso esta activo
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<bool> _checkGpsPermission() async {
    try {
      final isEnable = await Geolocator.isLocationServiceEnabled();
      // Aquí es cuando se activa o desactiva el gps en tiempo real
      gpsSubscription = Geolocator.getServiceStatusStream().listen((status) {
        final isGpsEnabled = (status.index == 1) ? true : false;
        add(GpsPermissionGranted(
            // El estado que este actualmente
            isGpsPermissionGranted: state.isGpsPermissionGranted,
            isGpsEnabled: isGpsEnabled));
      });
      return isEnable;
    } on LocationServiceDisabledException {
      print("Los servicios de ubicación no están habilitados.");
      return false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  //Para saber si el permiso de gps esta activo o no
  Future<void> askGpsAccess() async {
    try {
      final status = await Permission.location.request();
      switch (status) {
        //Cuando se acepta el permiso
        case PermissionStatus.granted:
          add(GpsPermissionGranted(
              isGpsPermissionGranted: true, isGpsEnabled: state.isGpsEnabled));
          break;
        //Cuando se deniega el permiso
        case PermissionStatus.denied:
        case PermissionStatus.permanentlyDenied:
        case PermissionStatus.restricted:
        case PermissionStatus.limited:
          add(GpsPermissionGranted(
              isGpsPermissionGranted: false, isGpsEnabled: state.isGpsEnabled));
          openAppSettings();
          break;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //limpiar el stream - siempre es muy buena practica
  @override
  Future<void> close() {
    gpsSubscription?.cancel();
    return super.close();
  }
}
