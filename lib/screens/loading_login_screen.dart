// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/screens/home_screen.dart';
import 'package:flutter_maps_adv/screens/information_screen.dart';
import 'package:flutter_maps_adv/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingLoginScreen extends StatelessWidget {
  static const String loadingroute = 'loadingLogin';

  const LoadingLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(
            child: Text('Espere...'),
          );
        },
      ),
    );
  }

  Future<void> checkLoginState(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    // Verificar si es el primer lanzamiento almacenando un valor en SharedPreferences
    bool isFirstLaunch = sharedPreferences.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      // Si es el primer lanzamiento, enviar al usuario a la pantalla de inicio de sesión
      navigateToReplacement(context, const LoginScreen());

      // Actualizar el valor para indicar que la aplicación ya ha sido lanzada antes
      await sharedPreferences.setBool('isFirstLaunch', false);
    } else {
      // Si no es el primer lanzamiento, continuar con la lógica original
      print("LoadingLoginScreen");
      final authService = BlocProvider.of<AuthBloc>(context, listen: false);
      final roomBloc = BlocProvider.of<RoomBloc>(context, listen: false);
      final publicationBloc =
          BlocProvider.of<PublicationBloc>(context, listen: false);
      final result = await authService.init();
      print('Resultado11:');
      print('Usuario11:');
      BlocProvider.of<NavigatorBloc>(context)
          .add(const NavigatorIndexEvent(index: 0));
      if (result) {
        print("Usuario");
        if (authService.getUsuario() != null &&
            authService.getUsuario()!.telefono == null) {
          navigateToReplacement(context, const InformationScreen());
        } else {
          await roomBloc.salasInitEvent();
          await publicationBloc.getAllPublicaciones();
          navigateToReplacement(context, const HomeScreen());
        }
      } else {
        print("Usuario: false false");
        await authService.logout();
        navigateToReplacement(context, const LoginScreen());
      }
    }
  }

  void navigateToReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: const Duration(milliseconds: 0),
      ),
    );
  }
}
