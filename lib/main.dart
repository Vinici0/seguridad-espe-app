import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/publication/publication_bloc.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';

import 'package:flutter_maps_adv/resources/services/socket_service.dart';
import 'package:flutter_maps_adv/screens/alert_screen.dart';
import 'package:flutter_maps_adv/screens/alerts_screen.dart';
import 'package:flutter_maps_adv/screens/chatsales_miembros.dart';
import 'package:flutter_maps_adv/screens/chatsales_screen.dart';
import 'package:flutter_maps_adv/screens/code_add_sreen.dart';
import 'package:flutter_maps_adv/screens/code_create_sreen.dart';
import 'package:flutter_maps_adv/screens/config_screen.dart';
import 'package:flutter_maps_adv/screens/chatsales_config_screen.dart';
import 'package:flutter_maps_adv/screens/home_screen.dart';
import 'package:flutter_maps_adv/screens/loading_login_screen.dart';
import 'package:flutter_maps_adv/screens/login_screen.dart';
import 'package:flutter_maps_adv/screens/lugares_screen.dart';
import 'package:flutter_maps_adv/screens/menu_screen.dart';
import 'package:flutter_maps_adv/screens/news_detalle.dart';
import 'package:flutter_maps_adv/screens/news_screen.dart';
import 'package:flutter_maps_adv/screens/register_screen.dart';
import 'package:flutter_maps_adv/screens/salas_screen.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:flutter_maps_adv/widgets/modal_add_group.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => SocketService()),
    BlocProvider(create: (context) => AuthBloc()),
    BlocProvider(create: (context) => GpsBloc()),
    BlocProvider(create: (context) => LocaltionBloc()),
    BlocProvider(create: (context) => PublicationBloc()),
    BlocProvider(create: (context) => RoomBloc()),
    BlocProvider(
        create: (context) =>
            MapBloc(locationBloc: BlocProvider.of<LocaltionBloc>(context))),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color myPurpleColor = Color(0xFF6165FA);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MapApp',
      initialRoute: LoadingLoginScreen.loadingroute,
      routes: {
        CodigoCreateGrupoScreen.codigoGruporoute: (_) =>
            const CodigoCreateGrupoScreen(),
        HomeScreen.homeroute: (_) => const HomeScreen(),
        LoadingLoginScreen.loadingroute: (_) => const LoadingLoginScreen(),
        LoadingMapScreen.loadingroute: (_) => const LoadingMapScreen(),
        LoginScreen.loginroute: (_) => const LoginScreen(),
        MapScreen.routemap: (_) => const MapScreen(),
        RegisterScreen.registerroute: (_) => const RegisterScreen(),
        // GruposScreen.salesroute: (_) => GruposScreen(),
        ChatScreen.chatsalesroute: (_) => ChatScreen(),
        ModalBottomSheet.modalBottomSheetRoute: (_) => ModalBottomSheet(),
        CodigoAddGrupoScreen.codigoAddGruporoute: (_) => CodigoAddGrupoScreen(),
        DetalleSalaScreen.detalleSalaroute: (_) => const DetalleSalaScreen(),
        SalasScreen.salasroute: (_) => const SalasScreen(),
        AlartasScreen.routeName: (_) => const AlartasScreen(),
        NewsScreen.newsroute: (_) => const NewsScreen(),
        ConfigScreen.configroute: (_) => const ConfigScreen(),
        DetalleScreen.detalleroute: (_) => const DetalleScreen(),
        AlertScreen.routeName: (_) => const AlertScreen(),
        LugaresScreen.salesroute: (_) => const LugaresScreen(),
        MenuScreen.salesroute: (_) => const MenuScreen(),
        MienbrosChatScreen.mienbrosChatroute: (_) => const MienbrosChatScreen(),
      },
      theme: ThemeData.light().copyWith(
        primaryColor: myPurpleColor,
        // focusColor:  myPurpleColor,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: myPurpleColor,
          textTheme: ButtonTextTheme.primary,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: myPurpleColor,
        ),
        indicatorColor: myPurpleColor,
        highlightColor: myPurpleColor.withOpacity(0.5),
        toggleableActiveColor: myPurpleColor,
      ),
    );
  }
}
