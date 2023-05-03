import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/ui/custom_snackbar.dart';

class BtnCurrentLocation extends StatelessWidget {
  const BtnCurrentLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Se accede a los dos blocs
    final locationBloc = BlocProvider.of<LocaltionBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
            icon: const Icon(Icons.my_location_outlined, color: Colors.black),
            onPressed: () {
              //ultima ubicacion conocida del usuario
              final userLocation = locationBloc.state.lastKnownLocation;

              if (userLocation == null) {
                final snack = CustomSnackbar(message: 'No hay ubicación');
                ScaffoldMessenger.of(context).showSnackBar(snack);
                return;
              }

              mapBloc.moveCamera(userLocation);
            }),
      ),
    );
  }
}
