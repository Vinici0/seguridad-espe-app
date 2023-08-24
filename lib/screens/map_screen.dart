import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/views/map_view.dart';
import 'package:flutter_maps_adv/widgets/home/btn_follow_user.dart';
import 'package:flutter_maps_adv/widgets/home/btn_report.dart';
import 'package:flutter_maps_adv/widgets/btn_toggle_user_route.dart';
import 'package:flutter_maps_adv/widgets/home/btn_sos.dart';
import 'package:flutter_maps_adv/widgets/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  static const String routemap = 'map_screen';
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc localtionBloc;
  AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    super.initState();
    // localtionBloc.getCurrentLocation();
    localtionBloc = BlocProvider.of<LocationBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    localtionBloc.startFollowingUser();
  }

  @override
  void dispose() {
    //Se ejecuta cuando se cierra la pantalla
    localtionBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocaltionState>(
        builder: (context, localtionState) {
          if (localtionState.lastKnownLocation == null) {
            return Container(
              color: Colors.white,
              child:
                  const Center(child: Text("No se ha encontrado la ubicación")),
            );
          }

          return BlocBuilder<MapBloc, MapState>(
            builder: (context, mapState) {
              Map<String, Polyline> polylines = Map.from(mapState.polylines);

              if (!mapState.showRoutePreview) {
                polylines.removeWhere((key, value) => key == 'myRoute');
              }

              return ScaffoldMessenger(
                child: Stack(
                  children: [
                    MapView(
                      initialLocation: localtionState.lastKnownLocation!,
                      polylines: polylines.values.toSet(),
                      markers: mapState.markers.values.toSet(),
                    ),
                    // const SearchBar(),
                    // const ManualMarker(),
                    Positioned(
                      bottom: 80.0,
                      right: 16.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          BtnFollowUser(),
                          //icono de cambiar diseño de mapa
                          // Container(
                          //   margin: EdgeInsets.only(bottom: 10),
                          //   child: Material(
                          //     elevation:
                          //         2, // Añadir una sombra suave al contenedor
                          //     shape: CircleBorder(),
                          //     child: Ink(
                          //       decoration: BoxDecoration(
                          //         shape: BoxShape.circle,
                          //         border: Border.all(
                          //           color: Colors.grey[800]!,
                          //           width: 2, // Ancho del borde
                          //         ),
                          //       ),
                          //       child: InkWell(
                          //         onTap: () {
                          //           // Agrega aquí la lógica para manejar el evento al hacer clic en el icono
                          //           // Por ejemplo, para cambiar el diseño de mapa, puedes utilizar:
                          //           // mapBloc.add(OpToggleUserRouteEvent());
                          //         },
                          //         borderRadius: BorderRadius.circular(
                          //             25), // Radio para la tinta
                          //         child: Padding(
                          //           padding: EdgeInsets.all(
                          //               10), // Ajusta el tamaño del icono dentro del círculo
                          //           child: Icon(
                          //             Icons.map,
                          //             color: Colors.grey[800],
                          //             size: 20, // Tamaño del icono
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          BtnToggleUserRoute(),
                          BtnCurrentLocation(),
                        ],
                      ),
                    ),

                    const BtnSOS(),
                    const BtnReport(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
