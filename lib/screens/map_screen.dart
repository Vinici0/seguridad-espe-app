import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/views/map_view.dart';
import 'package:flutter_maps_adv/widgets/btn_follow_user.dart';
import 'package:flutter_maps_adv/widgets/btn_report.dart';
import 'package:flutter_maps_adv/widgets/btn_toggle_user_route.dart';
import 'package:flutter_maps_adv/widgets/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  static const String routemap = 'map_screen';
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocaltionBloc localtionBloc = BlocProvider.of<LocaltionBloc>(context);

  @override
  void initState() {
    //Solo se ejcuta una vez y despues realiza una limpieza
    super.initState();
    // localtionBloc.getCurrentLocation();
    localtionBloc.startFollowingUser();
  }

  @override
  void dispose() {
    //Se ejecuta cuando se cierra la pantalla
    localtionBloc.stopFollowingUser();
    super.dispose();
  }

  /*
    TODO: Importante, ya se tiene al ultima ubicacion conocida
    //Nuevas funciones
   */
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaltionBloc, LocaltionState>(
      builder: (context, localtionState) {
        if (localtionState.lastKnownLocation == null) {
          return const Center(child: Text("No se ha encontrado la ubicación"));
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
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return MapView(
                        initialLocation: localtionState.lastKnownLocation!,
                        polylines: polylines.values.toSet(),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 80.0,
                    right: 16.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BtnFollowUser(),
                        BtnToggleUserRoute(),
                        BtnCurrentLocation(),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.05,
                    right: 16.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        onPressed: () {},
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(
                                    219, 31, 31, 1), // Rojo transparente
                                Color.fromRGBO(220, 34, 34,
                                    0.893), // Rojo más transparente
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 255, 0, 0)
                                    .withOpacity(0.5),
                                spreadRadius: 9,
                                blurRadius: 5,
                                // offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * 0.3 / 2),
                            onTap: () {},
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: MediaQuery.of(context).size.width * 0.30,
                              alignment: Alignment.center,
                              child: Text(
                                'SOS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  BtnReport(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
