import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_maps_adv/blocs/gps/gps_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'localtion_event.dart';
part 'localtion_state.dart';

class LocationBloc extends Bloc<LocaltionEvent, LocaltionState> {
  StreamSubscription? positionStream;
  final GpsBloc _gpsBloc = GpsBloc();

  LocationBloc() : super(LocaltionState()) {
    //siguiendo al usuario
    on<OnStartFollowingUser>((event, emit) {
      emit(state.copyWith(followingUser: true));
    });

    //Dejar de seguir al usuario
    on<OnStopFollowingUser>((event, emit) {
      emit(state.copyWith(followingUser: false));
    });

    on<OnNewUserLocationEvent>((event, emit) {
      emit(state.copyWith(
        lastKnownLocation: event.newLocation,
        myLocationHistory: [...state.myLocationHistory, event.newLocation],
      ));
    });
  }

  Future getCurrentLocation() async {
    if (!_gpsBloc.state.isAllGranted) {
      return;
    }

    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      // Aquí puedes mostrar un mensaje al usuario o redirigirlo a la configuración de ubicación del dispositivo para que pueda habilitar los servicios de ubicación.
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      add(OnNewUserLocationEvent(
          LatLng(position.latitude, position.longitude)));
      return position;
    } on LocationServiceDisabledException {
      print("Los servicios de ubicación no están habilitados.");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void startFollowingUser() {
    add(OnStartFollowingUser());

    positionStream = Geolocator.getPositionStream().listen((event) {
      final position = event;
      try {
        add(OnNewUserLocationEvent(
            LatLng(position.latitude, position.longitude)));
      } catch (e) {
        if (e is LocationServiceDisabledException) {
          // Manejar la excepción cuando el servicio de ubicación está desactivado
          print('Servicio de ubicación desactivado');
          // Mostrar un mensaje de error al usuario y proporcionar una opción para habilitar el servicio de ubicación
        } else {
          // Manejar otras excepciones que puedan ocurrir
          print('Ocurrió un error al obtener la ubicación del usuario: $e');
          // Mostrar un mensaje de error genérico al usuario
        }
      }
    });
  }

  void stopFollowingUser() {
    positionStream?.cancel(); //Sirve para cancelar el stream
    add(OnStopFollowingUser());
    print("Stop following user");
  }

  @override
  Future<void> close() {
    // TODO: implement close
    stopFollowingUser();
    return super.close();
  }
}
