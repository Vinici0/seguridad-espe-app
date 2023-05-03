import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/prueba/prueba_bloc.dart';
import 'package:flutter_maps_adv/screens/codigo_sreen.dart';
import 'package:flutter_maps_adv/screens/home_screen.dart';
import 'package:flutter_maps_adv/screens/loading_login_screen.dart';
import 'package:flutter_maps_adv/screens/login_screen.dart';
import 'package:flutter_maps_adv/screens/prueba/prueba.dart';
import 'package:flutter_maps_adv/screens/prueba/prueba2.dart';
import 'package:flutter_maps_adv/screens/register_screen%20copy.dart';
import 'package:flutter_maps_adv/screens/salas_screen.dart';
import 'package:flutter_maps_adv/screens/screens.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    //Dependencias que van en cascada
    //PruebaBloc
    BlocProvider(create: (context) => PruebaBloc()),
    BlocProvider(create: (context) => AuthBloc()),
    BlocProvider(create: (context) => GpsBloc()),
    BlocProvider(create: (context) => LocaltionBloc()),
    //Se le envia la instancia del bloc de localizacion
    BlocProvider(
        create: (context) =>
            MapBloc(locationBloc: BlocProvider.of<LocaltionBloc>(context))),

    //AuthBloc
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MapApp',
        initialRoute: LoadingLoginScreen.loadingroute,
        routes: {
          CodigoGrupoScreen.codigoGruporoute: (_) => CodigoGrupoScreen(),
          HomeScreen.homeroute: (_) => HomeScreen(),
          LoadingLoginScreen.loadingroute: (_) => LoadingLoginScreen(),
          LoadingMapScreen.loadingroute: (_) => LoadingMapScreen(),
          LoginScreen.loginroute: (_) => LoginScreen(),
          MapScreen.routemap: (_) => MapScreen(),
          PruebaScreen.routemap: (_) => PruebaScreen(),
          PruebaScreen2.routemap: (_) => PruebaScreen2(),
          RegisterScreen.registerroute: (_) => RegisterScreen(),
          SalesScreen.salesroute: (_) => SalesScreen(),
        });
  }
}
