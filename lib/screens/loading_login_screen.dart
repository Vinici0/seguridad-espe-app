// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/screens/home_screen.dart';
import 'package:flutter_maps_adv/screens/information_family_screen.dart';
import 'package:flutter_maps_adv/screens/information_screen.dart';
import 'package:flutter_maps_adv/screens/login_screen.dart';

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
    final authService = BlocProvider.of<AuthBloc>(context);

    await authService.init();

    await Future.delayed(const Duration(milliseconds: 100));

    final usuario = authService.state.usuario;

    if (authService.isLoggedInTrue) {
      if (usuario?.telefono == null) {
        navigateToReplacement(context, const InformationScreen());
      } else if ((usuario?.telefonos.length ?? 0) < 2) {
        navigateToReplacement(context, const InformationFamily());
      } else {
        navigateToReplacement(context, const HomeScreen());
      }
    } else {
      navigateToReplacement(context, const LoginScreen());
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
