import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_maps_adv/helpers/debouncer.dart';
import 'package:flutter_maps_adv/models/places_models.dart';
import 'package:flutter_maps_adv/models/ubicacion.dart';
import 'package:flutter_maps_adv/models/route_destination.dart';
import 'package:flutter_maps_adv/resources/services/traffic_service.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  TrafficService trafficService;
  final _history = <Feature>[];

  SearchBloc({
    SearchState? initialState,
    required this.trafficService,
  }) : super(const SearchState()) {
    on<OnActivateManualMarkerEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarker: true)));
    on<OnDeactivateManualMarkerEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarker: false)));

    on<OnNewUbicacionFoundEvent>((event, emit) {
      emit(state.copyWith(ubicacion: event.ubicacion));
    });

    on<AddToHistoryEvent>((event, emit) {
      emit(state.copyWith(history: [event.history, ...state.history]));
    });
    on<IsTogglePolylineEvent>((event, emit) {
      emit(state.copyWith(isActivePolyline: !state.isActivePolyline));
    });

    on<DeleteUbicacionByUserEvent>(deleteUbicacionByUserEvent);

    on<AddUbicacionByUserEvent>((event, emit) async {
      final newUbicacion = await trafficService.addUbicacionByUser(event.id);
      // if (newUbicacion == null) return;
      // emit(state.copyWith(ubicacion: [newUbicacion, ...state.ubicacion]));
    });

    on<IsActiveNotification>((event, emit) {
      emit(state.copyWith(isActiveNotification: event.isActive));
    });

    on<ToggloUpdateTypeMapEvent>((event, emit) {
      emit(state.copyWith(updateTypeMap: !state.updateTypeMap));
    });
  }

  Future<RouteDestination> getCoorsStartToEnd(LatLng start, LatLng end) async {
    try {
      final trafficResponse =
          await trafficService.getCoorsStartToEnd(start, end);

      final geometry = trafficResponse.routes[0].geometry;
      final distance = trafficResponse.routes[0].distance;
      final duration = trafficResponse.routes[0].duration;

      // Decodificar
      final points = decodePolyline(geometry, accuracyExponent: 6);

      final latLngList = points
          .map((coor) => LatLng(coor[0].toDouble(), coor[1].toDouble()))
          .toList();

      return RouteDestination(
          points: latLngList, duration: duration, distance: distance);
    } catch (e) {
      return RouteDestination(points: [], duration: 0, distance: 0);
    }
  }

  Future<List<Ubicacion>> getResultsByQueryUbicacion(String query) async {
    final results = await trafficService.getResultsByQueryUbicacion(query);
    if (results.isEmpty) return [];
    add(OnNewUbicacionFoundEvent(results));
    return results;
  }

  Future<List<Feature>> getHistory() async {
    return _history;
  }

  void deleteUbicacionByUserEvent(
      DeleteUbicacionByUserEvent event, Emitter<SearchState> emit) {
    // emit(state.copyWith(ubicacion: newUbicacion));
  }

  eliminarUbicacion(String id) async {
    await trafficService.deleteUbicacionByUser(id);
    // add(DeleteUbicacionByUserEvent(id));
  }

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Ubicacion>> _listUbicacionController =
      StreamController<List<Ubicacion>>.broadcast();

  Stream<List<Ubicacion>> get listUbicacionStream =>
      _listUbicacionController.stream;

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      print('Tenemos valor a buscar: $value');
      final results = await getResultsByQueryUbicacion(value);
      _listUbicacionController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
