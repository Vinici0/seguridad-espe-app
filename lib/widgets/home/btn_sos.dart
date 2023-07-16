import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/search/search_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BtnSOS extends StatelessWidget {
  const BtnSOS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lacationBloc = BlocProvider.of<LocationBloc>(context);
    final lat = lacationBloc.state.lastKnownLocation!.latitude;
    final lng = lacationBloc.state.lastKnownLocation!.longitude;
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarker
            ? state.isActiveNotification
                ? _SOSNumber(
                    authBloc: BlocProvider.of<AuthBloc>(context),
                    lat: lat,
                    lng: lng,
                  )
                : SizedBox()
            : const PositionedBtnSOS();
      },
    );
  }
}

class PositionedBtnSOS extends StatelessWidget {
  const PositionedBtnSOS({super.key});
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final lacationBloc = BlocProvider.of<LocationBloc>(context);
    final lat = lacationBloc.state.lastKnownLocation!.latitude;
    final lng = lacationBloc.state.lastKnownLocation!.longitude;
    return _SOSNotification(
      authBloc: authBloc,
      lat: lat,
      lng: lng,
    );
  }
}

class _SOSNotification extends StatelessWidget {
  const _SOSNotification({
    Key? key,
    required this.authBloc,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  final AuthBloc authBloc;
  final double lat;
  final double lng;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.09,
      right: 16.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: () {},
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(219, 31, 31, 1), // Rojo transparente
                  Color.fromRGBO(220, 34, 34, 0.893), // Rojo más transparente
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 255, 0, 0).withOpacity(0.5),
                  spreadRadius: 9,
                  blurRadius: 5,
                  // offset: Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.3 / 2),
              onTap: () async {
                Fluttertoast.showToast(
                    msg: "Se ha enviado una notificación a tus contactos",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: const Color.fromRGBO(219, 31, 31, 1),
                    textColor: Colors.white,
                    fontSize: 16.0);
                await authBloc.notificacion(lat, lng);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.width * 0.30,
                alignment: Alignment.center,
                child: Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SOSNumber extends StatelessWidget {
  const _SOSNumber({
    Key? key,
    required this.authBloc,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  final AuthBloc authBloc;
  final double lat;
  final double lng;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.09,
      right: 16.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: () {},
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 30, 29, 29), // Gris más fuerte
                  Color.fromARGB(
                      255, 67, 67, 67), // Gris más fuerte (más transparente)
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF616161)
                      .withOpacity(0.5), // Gris más fuerte (más transparente)
                  spreadRadius: 9,
                  blurRadius: 5,
                  // offset: Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.3 / 2,
              ),
              onTap: () async {
                final Uri smsLaunchUri = Uri(
                  scheme: 'tel',
                  path: '911',
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.width * 0.30,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LLAMAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '911',
                      style: TextStyle(
                        color: Colors.white,

                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        //texto en el centro del boton
                      ),
                      //texto en el centro del boton
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
