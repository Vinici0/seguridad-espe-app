// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/screens/home_screen.dart';
import 'package:flutter_maps_adv/screens/login_screen.dart';

class LoadingLoginScreen extends StatelessWidget {
  static const String loadingroute = 'loadingLogin';
  const LoadingLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('LoadingLoginScreen');
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

  Future checkLoginState(BuildContext context) async {
    final authService = BlocProvider.of<AuthBloc>(context, listen: false);

    final isLoggedIn = await authService.apiAuthRepository.isLoggedIn();

    print('isLoggedIn: $isLoggedIn');
    if (isLoggedIn) {
      authService.add(AuthInitEvent());
      authService.add(AuthConectEvent());

      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => const HomeScreen(),
              transitionDuration: const Duration(milliseconds: 0)));
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => const LoginScreen(),
              transitionDuration: const Duration(milliseconds: 0)));
    }
  }
}
