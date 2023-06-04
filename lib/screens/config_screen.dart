import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/screens/loading_login_screen.dart';
import 'package:flutter_maps_adv/screens/screens.dart';

class ConfigScreen extends StatelessWidget {
  static const String configroute = 'config';
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(onPressed: () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => LoadingMapScreen(),
                transitionDuration:
                    Duration(milliseconds: 0))); //TODO: cambiar a loading
      }, child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          //Boton cerrar sesion de
          return MaterialButton(
            child: Text('Cerrar sesion ${state.usuario?.nombre}'),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(AuthLogoutEvent());
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => LoadingLoginScreen(),
                      transitionDuration:
                          Duration(milliseconds: 0))); //TODO: cambiar a loading
            },
          );
        },
      )),
    );
  }
}