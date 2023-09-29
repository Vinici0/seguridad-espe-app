import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:flutter_maps_adv/widgets/custom_bottom_navigation.dart';

import 'package:fluttertoast/fluttertoast.dart'; // Asegúrate de importar los paquetes necesarios

class HomeScreen extends StatefulWidget {
  static const String homeroute = 'home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime currentBackPressTime = DateTime.now();

  // Método para manejar la lógica de doble presión
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Presiona nuevamente para salir");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final publicationBloc = BlocProvider.of<PublicationBloc>(context);
    final counterBlocUser = BlocProvider.of<AuthBloc>(context);

    return WillPopScope(
      onWillPop:
          onWillPop, // Llamamos al método onWillPop definido anteriormente
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<NavigatorBloc, NavigatorStateInit>(
              builder: (context, state) {
                return IndexedStack(
                  index: state.index,
                  children: [
                    // Si tu counterBloc está activo, puedes agregar aquí el widget correspondiente
                    // Center(child: Text("Home")),
                    const LoadingMapScreen(),
                    NewsScreen(onNewPublication: () async {
                      await publicationBloc.getNextPublicaciones();
                    }),

                    // GruposScreen(),
                    const RoomsScreen(),
                    const PerfilScreen(),
                    // Center(
                    //     child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [ConfigScreen()])),
                  ],
                );
              },
            )
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigation(),
      ),
    );
  }
}
