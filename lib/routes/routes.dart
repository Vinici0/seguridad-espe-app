import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/screens/perfil/edit_nombre.dart';
import 'package:flutter_maps_adv/screens/perfil/edit_telefono.dart';
import 'package:flutter_maps_adv/screens/screens.dart';

class Routes {
  static final Map<String, Widget Function(BuildContext)> routes = {
    AlertScreen.routeName: (_) => const AlertScreen(),
    AlertsScreen.routeName: (_) => const AlertsScreen(),
    ChatScreen.chatsalesroute: (_) => const ChatScreen(),
    CodigoAddGrupoScreen.codigoAddGruporoute: (_) => CodigoAddGrupoScreen(),
    CodigoCreateGrupoScreen.codigoGruporoute: (_) =>
        const CodigoCreateGrupoScreen(),
    ConfigScreen.configroute: (_) => const ConfigScreen(),
    DetalleSalaScreen.detalleSalaroute: (_) => const DetalleSalaScreen(),
    DetalleScreen.detalleroute: (_) => const DetalleScreen(),
    HomeScreen.homeroute: (_) => const HomeScreen(),
    InformationFamily.informationFamily: (_) => const InformationFamily(),
    InformationScreen.information: (_) => const InformationScreen(),
    LoadingLoginScreen.loadingroute: (_) => const LoadingLoginScreen(),
    LoadingMapScreen.loadingroute: (_) => const LoadingMapScreen(),
    LoginScreen.loginroute: (_) => const LoginScreen(),
    MapScreen.routemap: (_) => const MapScreen(),
    MienbrosChatScreen.mienbrosChatroute: (_) => MienbrosChatScreen(),
    ModalBottomSheet.modalBottomSheetRoute: (_) => const ModalBottomSheet(),
    PerfilScreen.salesroute: (_) => const PerfilScreen(),
    PlaceDetailScreen.place: (_) => const PlaceDetailScreen(),
    PlacesScreen.salesroute: (_) => const PlacesScreen(),
    RegisterScreen.registerroute: (_) => const RegisterScreen(),
    RoomsScreen.salasroute: (_) => const RoomsScreen(),
    SosScreen.sosroute: (_) => const SosScreen(),
    PerfilDetalleScreen.perfilDetalleroute: (_) => const PerfilDetalleScreen(),
    EditPerfilScreen.editPerfilroute: (_) => const EditPerfilScreen(),
    EditNombreScreen.editNombreroute: (_) => const EditNombreScreen(),
    EditTelefonoScreen.editTelefonoeroute: (_) => const EditTelefonoScreen(),
  };
}
