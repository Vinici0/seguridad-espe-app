import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/blocs/location/localtion_bloc.dart';
import 'package:flutter_maps_adv/helpers/custom_image_marker.dart';
import 'package:flutter_maps_adv/models/route_destination.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  //Importante lo que recibe el LocationBloc
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  LatLng? mapCenter;
  StreamSubscription<LocaltionState>? locationStateSubscription;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitialzedEvent>(_onInitMap);
    on<OnStartFollowingUserEvent>(_onStartFollowingUser);
    on<OnStopFollowingUserEvent>(
        (event, emit) => emit(state.copyWith(isFollowUser: false)));
    on<UpdateUserPolylineEvent>(_onPolylineNewPoint);
    on<OpToggleUserRouteEvent>((event, emit) =>
        emit(state.copyWith(showRoutePreview: !state.showRoutePreview)));

    on<OnMapMovedEvent>(
        (event, emit) => emit(state.copyWith(polylines: {}, markers: {})));

    on<DisplayPolylinesEvent>((event, emit) => emit(
        state.copyWith(polylines: event.polylines, markers: event.markers)));

    locationStateSubscription = locationBloc.stream.listen((locationState) {
      if (locationState.lastKnownLocation != null) {
        add(UpdateUserPolylineEvent(locationState.myLocationHistory));
      }
      if (!state.isFollowUser) return;
      if (locationState.lastKnownLocation == null) return;

      moveCamera(locationState.lastKnownLocation!);
    });

    /*
      No se puede usar el on porque es un stream y no un evento 
      -> locationBloc.state.lastKnownLocation;
    */

    locationStateSubscription = locationBloc.stream.listen((locationState) {
      if (locationState != null) {
        add(UpdateUserPolylineEvent(locationState.myLocationHistory));
      }
      //Si no esta siguiendo al usuario no se mueve
      if (!state.isFollowUser) return;
      //Si no tiene ubicacion no se mueve
      if (locationState.lastKnownLocation == null) return;
      // Se mueve al usuario
      moveCamera(locationState.lastKnownLocation!);
    });
  }

  //para inicializar el mapa y ponerle el estilo de uber
  void _onInitMap(OnMapInitialzedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    // _mapController!.setMapStyle(jsonEncode(uberMapTheme));

    emit(state.copyWith(isMapInitialized: true));
  }

  //para ubicar el mapa en la posicion del usuario en el centro en tiempo real
  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  // //para seguir al usuario
  void _onStartFollowingUser(
      OnStartFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowUser: true));
    if (locationBloc.state.lastKnownLocation == null) return;
    moveCamera(locationBloc.state.lastKnownLocation!);
  }

  void _onPolylineNewPoint(
      UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    //Objeto que viene de google maps para dibujar una linea
    final myRoute = Polyline(
        polylineId: const PolylineId('myRoute'),
        color: Colors.black,
        width: 5,
        //Para que la linea tenga un borde redondeado
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        //Los puntos de la linea que se dibuja
        points: event.userLocations);

    final currentPolylines = Map<String, Polyline>.from(
        state.polylines); //Se crea una copia del estado actual
    currentPolylines['myRoute'] = myRoute; //Se agrega la nueva polilinea

    //Se emite el nuevo estado con la nueva polilinea
    emit(state.copyWith(polylines: currentPolylines));
  }

  Future drawRoutePolyline(RouteDestination destination) async {
    try {
      final myRoute = Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.black,
        width: 5,
        points: destination.points,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      );

      double kms = destination.distance / 1000;
      kms = (kms * 100).floorToDouble();
      kms /= 100;

      int tripDuration = (destination.duration / 60).floorToDouble().toInt();

      //custom marker
      final startMakerImg = await getAssetImageMarker();

      final startMarker = Marker(
          // anchor: const Offset(0.1, 1),
          markerId: const MarkerId('start'),
          position: destination.points.first,
          infoWindow: InfoWindow(
            title: 'Inicio',
            snippet: 'Kms: $kms, duration: $tripDuration',
          ));

      final endMarker = Marker(
        // anchor: const Offset(0.1, 1),
        markerId: const MarkerId('end'),
        position: destination.points.last,
        // icon: startMaker,
        // infoWindow: InfoWindow(
        //   title: destination.destinationName,
        //   snippet: 'Kms: $kms, duration: $tripDuration',
        // )
      );

      final curretPolylines = Map<String, Polyline>.from(state.polylines);
      curretPolylines['route'] = myRoute;

      final currentMarkers = Map<String, Marker>.from(state.markers);
      currentMarkers['start'] = startMarker;
      currentMarkers['end'] = endMarker;

      add(DisplayPolylinesEvent(curretPolylines, currentMarkers));

      await Future.delayed(const Duration(milliseconds: 300), () {
        _mapController?.showMarkerInfoWindow(const MarkerId('start'));
        _mapController?.showMarkerInfoWindow(const MarkerId('end'));
      });
    } catch (e) {
      // Manejar la excepción aquí
      print('Error en drawRoutePolyline: $e');
      // Puedes lanzar una excepción personalizada o tomar otra acción según tu lógica de manejo de errores.
      // Por ejemplo, lanzar una excepción personalizada:
    }
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }
}
