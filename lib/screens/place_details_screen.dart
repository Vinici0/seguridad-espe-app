import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/blocs/search/search_bloc.dart';
import 'package:flutter_maps_adv/models/ubicacion.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const String place = 'place_details';

  const PlaceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final ubicacion = mapData['ubicacion'] as Ubicacion;
    final isDelete = mapData['isDelete'] as bool;
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    final circleMarkers = <CircleMarker>[
      CircleMarker(
          point: LatLng(ubicacion.latitud, ubicacion.longitud),
          color: const Color(0xFF7ab466).withOpacity(0.3),
          borderStrokeWidth: 2,
          borderColor: const Color(0xFF7ab466),
          useRadiusInMeter: true,
          radius: 2000 // 2000 meters | 2 km
          ),
    ];
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
            leading: const Icon(Icons.place, color: Color(0xFF7ab466)),
            title: Text(ubicacion.barrio),
            subtitle: Text(
              '${ubicacion.ciudad}, ${ubicacion.referencia ?? ''} ${ubicacion.pais}',
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    center: LatLng(ubicacion.latitud, ubicacion.longitud),
                    zoom: 14.0,
                    maxZoom: 21,
                  ),
                  nonRotatedChildren: [
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () => launchUrl(
                              Uri.parse('https://openstreetmap.org/copyright')),
                        ),
                      ],
                    ),
                  ],
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                      maxZoom: 22,
                    ),
                    CircleLayer(
                      circles: circleMarkers,
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(ubicacion.latitud, ubicacion.longitud),
                          width: 80,
                          height: 80,
                          //agregar el icono de la ubicacion
                          builder: (context) => const Icon(
                            Icons.location_on,
                            size: 40,
                            color: Color(0xFF7ab466),
                          ),
                        ),
                      ],
                    ),
                    //puntero de la ubicacion
                  ],
                ),
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
                                  authBloc.add(
                                      AuthDeleteUbicacionEvent(ubicacion.uid!));
                                  Navigator.pop(context);
                                },
                                icon: const Icon(FontAwesomeIcons.trashAlt,
                                    size: 16, color: Colors.white),
                                label: const Text("Eliminar dirección",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              )
                            : ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7ab466),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {
                                  if (authBloc.state.ubicaciones.any(
                                      (element) =>
                                          element.uid == ubicacion.uid)) {
                                    Navigator.pop(context);
                                    return;
                                  }
                                  searchBloc.add(
                                      AddUbicacionByUserEvent(ubicacion.uid!));
                                  authBloc
                                      .add(AuthAddUbicacionEvent(ubicacion));
                                  Navigator.pop(context);
                                },
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
