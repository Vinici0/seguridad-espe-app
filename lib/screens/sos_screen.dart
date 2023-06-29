import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/search/search_bloc.dart';
import 'package:flutter_maps_adv/helpers/navegacion.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SosScreen extends StatelessWidget {
  static const String sosroute = 'sos';
  const SosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //recupera el argumentos
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print(args);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    LatLng? end;
    // const String number = '911';

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black87),
          centerTitle: false,
          title: const Text('SOS',
              style: TextStyle(color: Colors.black, fontSize: 20)),
          elevation: 0.5,
        ),
        body: Column(
          //spacebetween
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: const [],
            ),
            Center(
              child: SvgPicture.asset(
                "assets/info/advertencia.svg",
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.30,
                color: const Color(0xFF6165FA),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              '${args['nombre']} necesitas ayuda',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final start = locationBloc.state.lastKnownLocation;
                      if (start == null) return;
                      end = LatLng(args['latitud'], args['longitud']);
                      if (end == null) return;
                      final destination =
                          await searchBloc.getCoorsStartToEnd(start, end!);
                      await mapBloc.drawRoutePolyline(destination);
                      Navigator.pop(context);
                      counterBloc.cambiarIndex(0);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF6165FA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.mapLocation,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Ver mapa',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //boton de llamar
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      // The `tel:` scheme is used to launch a phone call.
                      final Uri _url = Uri.parse('tel:+1-555-010-999');

                      // Check if the phone app is installed.
                      if (await canLaunchUrl(_url)) {
                        // Launch the phone app.
                        await launchUrl(_url);
                      } else {
                        // Show an error message.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Phone app not installed'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.call,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Llamar al 911',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}
