import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/screens/alerts_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BtnReport extends StatelessWidget {
  const BtnReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarker
            ? const SizedBox()
            : FadeInUp(
                duration: const Duration(milliseconds: 300),
                child: const _BtnReport());
      },
    );
  }
}

class _BtnReport extends StatelessWidget {
  const _BtnReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
            width: width * 0.95,
            height: 40,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                //largor del boton

                backgroundColor: const Color(0xFF7ab466),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                // padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              ),
              onPressed: () {
                // AlertasScreen.routeName
                // Navigator.pushNamed(context, "publicacion_notificacion");
                Navigator.pushNamed(context, AlertsScreen.routeName);
              },
              //icono de aleta de emergencia
              icon: Image.asset(
                'assets/alertaIcon.png',
                width: 23,
                height: 23,
              ),
              label: const Text("REPORTAR",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _BtnCancelar extends StatelessWidget {
  const _BtnCancelar();

  @override
  Widget build(BuildContext context) {
    MapBloc mapBloc = BlocProvider.of<MapBloc>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
            width: 150,
            height: 40,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                //largor del boton

                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                // padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              ),
              onPressed: () {
                mapBloc.add(OnMapMovedEvent());
                BlocProvider.of<SearchBloc>(context)
                    .add(OnDeactivateManualMarkerEvent());
              },
              //icono de una campana de aleerta
              // ignore: deprecated_member_use
              icon: const Icon(FontAwesomeIcons.times,
                  size: 16, color: Colors.white),
              label: const Text("CANCELAR",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
