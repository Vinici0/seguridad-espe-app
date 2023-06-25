import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

    on<DeleteUbicacionByUserEvent>(deleteUbicacionByUserEvent);

    on<AddUbicacionByUserEvent>((event, emit) async {
      final newUbicacion = await trafficService.addUbicacionByUser(event.id);
      if (newUbicacion == null) return;
      emit(state.copyWith(ubicacion: [newUbicacion, ...state.ubicacion]));
    });
  }

  Future<RouteDestination> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final trafficResponse = await trafficService.getCoorsStartToEnd(start, end);

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
  }

  Future<List<Ubicacion>> getResultsByQueryUbicacion(String query) async {
    final results = await trafficService.getResultsByQueryUbicacion(query);
    add(OnNewUbicacionFoundEvent(results));
    return results;
  }

  Future<List<Feature>> getHistory() async {
    return _history;
  }

  void deleteUbicacionByUserEvent(
      DeleteUbicacionByUserEvent event, Emitter<SearchState> emit) async {
    emit(state.copyWith(
        ubicacion: state.ubicacion
            .where((element) => element.uid! != event.id)
            .toList()));
  }

  eliminarUbicacion(String id) async {
    final deletedUbicacion = await trafficService.deleteUbicacionByUser(id);
    if (deletedUbicacion == null) return;
    add(DeleteUbicacionByUserEvent(deletedUbicacion.uid!));
  }
}
