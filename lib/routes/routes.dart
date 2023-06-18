import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/screens/screens.dart';

class Routes {
  static final Map<String, Widget Function(BuildContext)> routes = {
    AlertsScreen.routeName: (_) => const AlertsScreen(),
    AlertScreen.routeName: (_) => const AlertScreen(),
    ChatScreen.chatsalesroute: (_) => const ChatScreen(),
    CodigoAddGrupoScreen.codigoAddGruporoute: (_) => CodigoAddGrupoScreen(),
    CodigoCreateGrupoScreen.codigoGruporoute: (_) =>
        const CodigoCreateGrupoScreen(),
    ConfigScreen.configroute: (_) => const ConfigScreen(),
    DetalleSalaScreen.detalleSalaroute: (_) => const DetalleSalaScreen(),
    DetalleScreen.detalleroute: (_) => const DetalleScreen(),
    HomeScreen.homeroute: (_) => const HomeScreen(),
    LoadingLoginScreen.loadingroute: (_) => const LoadingLoginScreen(),
    LoadingMapScreen.loadingroute: (_) => const LoadingMapScreen(),
    LoginScreen.loginroute: (_) => const LoginScreen(),
    PlacesScreen.salesroute: (_) => const PlacesScreen(),
    MapScreen.routemap: (_) => const MapScreen(),
    MenuScreen.salesroute: (_) => const MenuScreen(),
    MienbrosChatScreen.mienbrosChatroute: (_) => const MienbrosChatScreen(),
    ModalBottomSheet.modalBottomSheetRoute: (_) => const ModalBottomSheet(),
    NewsScreen.newsroute: (_) => const NewsScreen(),
    RegisterScreen.registerroute: (_) => const RegisterScreen(),
    RoomsScreen.salasroute: (_) => const RoomsScreen(),
    PlaceAddScreen.placeddd: (_) => const PlaceAddScreen(),
    PlaceDetailScreen.place: (_) => const PlaceDetailScreen(),
  };
}
