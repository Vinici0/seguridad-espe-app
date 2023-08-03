import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/search/search_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  final LatLng initialLocation;
  final Set<Polyline> polylines;
  final Set<Marker> markers;

  const MapView(
      {Key? key,
      required this.initialLocation,
      required this.polylines,
      required this.markers})
      : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late final mapBloc = BlocProvider.of<MapBloc>(context);
  late final GoogleMapController mapController;

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CameraPosition initialCameraPosition =
        CameraPosition(target: widget.initialLocation, zoom: 15);
    final size = MediaQuery.of(context).size;
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return SizedBox(
          width: size.width,
          height: size.height,
          child: Listener(
            onPointerMove: (pointerMoveEvent) =>
                mapBloc.add(OnStopFollowingUserEvent()),
            child: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              compassEnabled: false,
              mapType: state.updateTypeMap ? MapType.satellite : MapType.normal,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              /* 
                   on<OpToggleUserRouteEvent>((event, emit) => emit(state.copyWith(
                  showRoutePreview: !state.showRoutePreview,
                  activePolylineUser: !state.activePolylineUser)));
              */
              polylines: state.displayManualMarker
                  ? widget.polylines.map((polyline) {
                      return polyline.copyWith(
                          colorParam: const Color.fromARGB(255, 64, 70, 250));
                    }).toSet()
                  : state.isActivePolyline
                      ? widget.polylines
                      : {},
              markers: state.displayManualMarker ? widget.markers : {},
              onCameraMove: (position) => mapBloc.mapCenter = position.target,
              onMapCreated: (controller) {
                mapController = controller;

                searchBloc.add(const IsTogglePolylineEvent());
                mapBloc.add(OnMapInitialzedEvent(controller));
              },
            ),
          ),
        );
      },
    );
  }
}
