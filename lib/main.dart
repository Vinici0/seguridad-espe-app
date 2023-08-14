import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/notification/notification_bloc.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/models/publication.dart';
import 'package:flutter_maps_adv/resources/services/push_notifications_service.dart';
import 'package:flutter_maps_adv/resources/services/traffic_service.dart';
import 'package:flutter_maps_adv/routes/routes.dart';
import 'package:flutter_maps_adv/screens/loading_login_screen.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Solicitar permisos de notificación si es la primera vez que se abre la app
  final status = await Permission.notification.request();
  // Inicializar el servicio de notificaciones
  await PushNotificationService.initializeApp();
  if (status.isGranted) {
    print('Permisos de notificación concedidos');
  }

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => AuthBloc()),
      BlocProvider(create: (context) => GpsBloc()),
      BlocProvider(create: (context) => LocationBloc()),
      BlocProvider(create: (context) => PublicationBloc()),
      BlocProvider(create: (context) => MembersBloc()),
      BlocProvider(create: (context) => RoomBloc()),
      BlocProvider(create: (context) => NotificationBloc()),
      BlocProvider(create: (context) => NavigatorBloc()),
      BlocProvider(
          create: (context) => SearchBloc(trafficService: TrafficService())),
      BlocProvider(
          create: (context) =>
              MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context))),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isSosScreenOpen = false;

  @override
  void initState() {
    /*
      Notificaciones
    */
    PushNotificationService.messagesStream.listen((message) {
      print('MyApp: $message');
      final dataNotification = jsonDecode(message['data']);
      print(dataNotification);
      if (dataNotification['type'] == 'sos') {
        if (isSosScreenOpen) {
          return;
        }

        navigatorKey.currentState
            ?.pushNamed('sos', arguments: dataNotification);
        return;
      }

      if (dataNotification['type'] == 'publication') {
        final newPublications = Publicacion.fromMap(dataNotification);
        BlocProvider.of<PublicationBloc>(context)
            .add(PublicacionSelectEvent(newPublications));

        navigatorKey.currentState
            ?.pushNamed('publicacion_notificacion', arguments: newPublications);
        return;
      }

      // navigatorKey.currentState?.pushNamed('product', arguments: message);

      isSosScreenOpen = true;

      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Solo vertical hacia arriba
      DeviceOrientation.portraitDown, // Solo vertical hacia abajo
    ]);

    Color myPurpleColor = const Color(0xFF6165FA);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MapApp',
      initialRoute: LoadingLoginScreen.loadingroute,
      routes: Routes.routes,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messengerKey,
      theme: ThemeData.light().copyWith(
        primaryColor: myPurpleColor,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(
            titleLarge: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
