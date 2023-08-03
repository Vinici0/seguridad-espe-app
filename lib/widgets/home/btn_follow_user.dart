import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BtnFollowUser extends StatelessWidget {
  const BtnFollowUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return IconButton(
                icon:
                    Icon(FontAwesomeIcons.layerGroup, color: Colors.grey[800]),
                onPressed: () {
                  searchBloc.add(const ToggloUpdateTypeMapEvent());
                });
          },
        ),
      ),
    );
  }
}
