import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/screens/gps_access_screen.dart';
import 'package:flutter_maps_adv/screens/map_screen.dart';

class LoadingMapScreen extends StatelessWidget {
  static const String loadingroute = 'loading';

  const LoadingMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GpsBloc, GpsState>(
      builder: (context, state) {
        return !state.isAllGranted
            ? const GpsAccessScreen()
            //que dirija a la pantalla de mapaScren
            : const MapScreen();
      },
    );
  }
}
