import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/screens/auth_screen.dart';
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
                pageBuilder: (_, __, ___) => const LoadingMapScreen(),
                transitionDuration: const Duration(milliseconds: 0)));
      }, child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          //Boton cerrar sesion de
          return MaterialButton(
            child: Text('Cerrar sesion ${state.usuario?.nombre}'),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(const AuthLogoutEvent());
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const AuthScreen(),
                      transitionDuration: const Duration(milliseconds: 0)));
            },
          );
        },
      )),
    );
  }
}
