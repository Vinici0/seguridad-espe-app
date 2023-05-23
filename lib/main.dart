import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';

import 'package:flutter_maps_adv/resources/services/chat_provider.dart';
import 'package:flutter_maps_adv/resources/services/publicacion.dart';
import 'package:flutter_maps_adv/resources/services/socket_service.dart';
import 'package:flutter_maps_adv/screens/alert_screen.dart';
import 'package:flutter_maps_adv/screens/alerts_screen.dart';
import 'package:flutter_maps_adv/screens/chatsales_screen.dart';
import 'package:flutter_maps_adv/screens/code_add_sreen.dart';
import 'package:flutter_maps_adv/screens/code_create_sreen.dart';
import 'package:flutter_maps_adv/screens/config_screen.dart';
import 'package:flutter_maps_adv/screens/detallesala_screen.dart';
import 'package:flutter_maps_adv/screens/home_screen.dart';
import 'package:flutter_maps_adv/screens/loading_login_screen.dart';
import 'package:flutter_maps_adv/screens/login_screen.dart';
import 'package:flutter_maps_adv/screens/group_screen.dart';
import 'package:flutter_maps_adv/screens/lugares_screen.dart';
import 'package:flutter_maps_adv/screens/news_detalle.dart';
import 'package:flutter_maps_adv/screens/news_screen.dart';
import 'package:flutter_maps_adv/screens/register_screen.dart';
import 'package:flutter_maps_adv/screens/salas_screen.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:flutter_maps_adv/widgets/modal_add_group.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    //Dependencias que van en cascada
    //PruebaBloc
    BlocProvider(create: (context) => SocketService()),
    BlocProvider(create: (context) => AuthBloc()),
    BlocProvider(create: (context) => GpsBloc()),
    BlocProvider(create: (context) => LocaltionBloc()),
    // BlocProvider(create: (context) => SalaBloc()),
    //Se le envia la instancia del bloc de localizacion
    BlocProvider(
        create: (context) =>
            MapBloc(locationBloc: BlocProvider.of<LocaltionBloc>(context))),
    BlocProvider<ChatProvider>(create: (context) => ChatProvider()),
    BlocProvider<PublicacionService>(create: (context) => PublicacionService()),
    //AuthBloc
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
            CodigoCreateGrupoScreen(),
        HomeScreen.homeroute: (_) => HomeScreen(),
        LoadingLoginScreen.loadingroute: (_) => LoadingLoginScreen(),
        LoadingMapScreen.loadingroute: (_) => LoadingMapScreen(),
        LoginScreen.loginroute: (_) => LoginScreen(),
        MapScreen.routemap: (_) => MapScreen(),
        RegisterScreen.registerroute: (_) => RegisterScreen(),
        GruposScreen.salesroute: (_) => GruposScreen(),
        ChatScreen.chatsalesroute: (_) => ChatScreen(),
        ModalBottomSheet.modalBottomSheetRoute: (_) => ModalBottomSheet(),
        CodigoAddGrupoScreen.codigoAddGruporoute: (_) => CodigoAddGrupoScreen(),
        DetalleSalaScreen.detalleSalaroute: (_) => DetalleSalaScreen(),
        SalasScreen.salasroute: (_) => SalasScreen(),
        AlartasScreen.routeName: (_) => AlartasScreen(),
        NewsScreen.newsroute: (_) => NewsScreen(),
        ConfigScreen.configroute: (_) => ConfigScreen(),
        DetalleScreen.detalleroute: (_) => DetalleScreen(),
        AlertScreen.routeName: (_) => AlertScreen(),
        LugaresScreen.salesroute: (_) => LugaresScreen(),
      },
      theme: ThemeData.light().copyWith(
        primaryColor: myPurpleColor,
        // focusColor:  myPurpleColor,
        appBarTheme: AppBarTheme(
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
