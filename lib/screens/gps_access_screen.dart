import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GpsAccessScreen extends StatelessWidget {
  static const String routegps = 'gps_access_screen';
  const GpsAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<GpsBloc, GpsState>(
          builder: (context, state) {
            // print(state);
            return !state.isGpsEnabled
                ? const _EnableGpsMessage()
                : const _AccessButton();
          },
        ),
      ),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Es necesario el acceso a GPS'),
        MaterialButton(
            color: Colors.black,
            shape: const StadiumBorder(),
            elevation: 0,
            splashColor: Colors.transparent,
            onPressed: () {
              final gpsBloc = BlocProvider.of<GpsBloc>(context);
              gpsBloc.askGpsAccess();
            },
            child: const Text('Solicitar Acceso',
                style: TextStyle(color: Colors.white)))
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //cargar imagen svg
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: MediaQuery.of(context).size.width * 0.5,
          child: SvgPicture.asset(
            'assets/info/lugares1.svg',
          ),
        ),
        const Text(
          'Debe de habilitar el GPS',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
