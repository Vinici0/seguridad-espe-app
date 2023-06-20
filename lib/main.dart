import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/search/search_bloc.dart';
import 'package:flutter_maps_adv/resources/services/push_notifications_service.dart';
import 'package:flutter_maps_adv/resources/services/traffic_service.dart';
import 'package:flutter_maps_adv/routes/routes.dart';
import 'package:flutter_maps_adv/screens/loading_login_screen.dart';
import 'package:flutter_maps_adv/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Lo primero que se ejecuta en la app
  await PushNotificationService.initializeApp();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => AuthBloc()),
    BlocProvider(create: (context) => GpsBloc()),
    BlocProvider(create: (context) => LocationBloc()),
    BlocProvider(create: (context) => PublicationBloc()),
    BlocProvider(create: (context) => RoomBloc()),
    BlocProvider(
        create: (context) => SearchBloc(trafficService: TrafficService())),
    BlocProvider(
        create: (context) =>
            MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context))),
  ], child: const MyApp()));
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

  @override
  void initState() {
    super.initState();
    /*
      Notificaciones
    */
    PushNotificationService.messagesStream.listen((message) {
      navigatorKey.currentState?.pushNamed('salas', arguments: message);
      final snackBar = SnackBar(content: Text(message));
      messengerKey.currentState?.showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
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
            headline6: TextStyle(
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
