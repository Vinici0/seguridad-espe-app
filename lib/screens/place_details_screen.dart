import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/blocs/search/search_bloc.dart';
import 'package:flutter_maps_adv/models/ubicacion.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDetailScreen extends StatefulWidget {
  static const String place = 'place_details';

  const PlaceDetailScreen({Key? key}) : super(key: key);

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  late CameraPosition _kGooglePlex;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    _kGooglePlex = const CameraPosition(
      target: LatLng(0, 0),
      zoom: 14.4746,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.future.then((controller) => controller
        .dispose()); //Sirve para liberar la memoria del controlador del mapa cuando se cierra la pantalla de detalles de ubicacion
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mapData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final ubicacion = mapData['ubicacion'] as Ubicacion;
    final isDelete = mapData['isDelete'] as bool;
    _kGooglePlex = CameraPosition(
      target: LatLng(ubicacion.latitud, ubicacion.longitud),
      zoom: 14.4746,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final ubicacion = mapData['ubicacion'] as Ubicacion;
    final isDelete = mapData['isDelete'] as bool;
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: false,
        title: const Text(
          'Place Details',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.place, color: Color(0xFF6165FA)),
            title: Text(ubicacion.barrio),
            subtitle: Text(
              '${ubicacion.ciudad}, ${ubicacion.referencia ?? ''} ${ubicacion.pais}',
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  compassEnabled: false,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                  mapType: MapType.hybrid,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId('marker_1'),
                      position: LatLng(ubicacion.latitud, ubicacion.longitud),
                      icon: BitmapDescriptor.defaultMarker,
                    ),
                  },
                  circles: {
                    Circle(
                      circleId: CircleId("circle_1"),
                      center: LatLng(ubicacion.latitud, ubicacion.longitud),
                      radius: 2000, // Radio de 2 kilómetros
                      fillColor: Colors.blue.withOpacity(0.3),
                      strokeColor: Colors.blue,
                      strokeWidth: 2,
                    ),
                  },
                ),
                // const ManualMarker(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        margin: const EdgeInsets.all(16.0),
                        child: isDelete
                            ? ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () async {
                                  await searchBloc
                                      .eliminarUbicacion(ubicacion.uid!);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    'lugares', //Es la ruta a la que se va a redirigir
                                    ModalRoute.withName(
                                        'place_details'), //Es la ruta actual de la que se va a redirigir y se va a eliminar
                                  );
                                },
                                //icono de ubicacion
                                icon: const Icon(FontAwesomeIcons.trashAlt,
                                    size: 16, color: Colors.white),
                                label: const Text("Eliminar dirección",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              )
                            : ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6165FA),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {
                                  //Si ya existe la ubicacion con el mismo id no la agrega
                                  if (authBloc.state.ubicaciones.any(
                                      (element) =>
                                          element.uid == ubicacion.uid)) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      'lugares', //Es la ruta a la que se va a redirigir
                                      ModalRoute.withName(
                                          'place_details'), //Es la ruta actual de la que se va a redirigir y se va a eliminar
                                    );
                                    return;
                                  }
                                  searchBloc.add(
                                      AddUbicacionByUserEvent(ubicacion.uid!));

                                  authBloc
                                      .add(AuthAddUbicacionEvent(ubicacion));
                                  Navigator.pop(context);
                                },
                                //icono de ubicacion
                                icon: const Icon(FontAwesomeIcons.mapMarkerAlt,
                                    size: 16, color: Colors.white),
                                label: const Text("Agregar a mis direcciones",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
