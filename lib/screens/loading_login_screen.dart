// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/notification/notification_bloc.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/screens/auth_screen.dart';
import 'package:flutter_maps_adv/screens/home_screen.dart';
import 'package:flutter_maps_adv/screens/information_family_screen.dart';
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
    final authService = BlocProvider.of<AuthBloc>(context, listen: false);

    // Verificar si es el primer lanzamiento almacenando un valor en SharedPreferences
    bool isFirstLaunch = sharedPreferences.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      await authService.obtenerTodasLasInstituciones();
      // Si es el primer lanzamiento, enviar al usuario a la pantalla de inicio de sesión
      navigateToReplacement(context, const AuthScreen());

      // Actualizar el valor para indicar que la aplicación ya ha sido lanzada antes
      await sharedPreferences.setBool('isFirstLaunch', false);
    } else {
      // Si no es el primer lanzamiento, continuar con la lógica original
      print("LoadingLoginScreen");

      final roomBloc = BlocProvider.of<RoomBloc>(context, listen: false);
      final publicationBloc =
          BlocProvider.of<PublicationBloc>(context, listen: false);

      final notificationBloc =
          BlocProvider.of<NotificationBloc>(context, listen: false);
      final result = await authService.init();
      BlocProvider.of<NavigatorBloc>(context)
          .add(const NavigatorIndexEvent(index: 0));
      if (result) {
        if (authService.getUsuario()?.telefono == null ||
            authService.getUsuario()?.telefonos == null) {
          await roomBloc.salasInitEvent();
          await publicationBloc.getAllPublicaciones();
          await notificationBloc.loadNotification();

          if (authService.getUsuario()?.telefono == null) {
            navigateToReplacement(context, const InformationScreen());
          } else if (authService.getUsuario()?.telefonos == null) {
            navigateToReplacement(context, const InformationFamily());
          } else {
            navigateToReplacement(context, const HomeScreen());
          }

          // await roomBloc.salasInitEvent();
          // await publicationBloc.getAllPublicaciones();
          // await notificationBloc.loadNotification();
          // navigateToReplacement(context, const InformationScreen());
        } else {
          await roomBloc.salasInitEvent();
          await publicationBloc.getAllPublicaciones();
          await notificationBloc.loadNotification();

          navigateToReplacement(context, const HomeScreen());
        }
      } else {
        await authService.obtenerTodasLasInstituciones();
        await authService.logout();
        navigateToReplacement(context, const AuthScreen());
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
