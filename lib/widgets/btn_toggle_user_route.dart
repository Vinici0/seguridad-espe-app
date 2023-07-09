import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BtnToggleUserRoute extends StatelessWidget {
  const BtnToggleUserRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        elevation: 0,
        shape: const CircleBorder(),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 25,
          child: IconButton(
              icon: Icon(FontAwesomeIcons.route, color: Colors.grey[800]),
              onPressed: () {
                mapBloc.add(OpToggleUserRouteEvent());
              }),
        ),
      ),
    );
  }
}
