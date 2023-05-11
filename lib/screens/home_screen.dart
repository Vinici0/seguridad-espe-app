import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/helpers/navegacion.dart';
import 'package:flutter_maps_adv/screens/loading_login_screen.dart';
import 'package:flutter_maps_adv/screens/loading_map_screen.dart';
import 'package:flutter_maps_adv/screens/grupos_screen.dart';
import 'package:flutter_maps_adv/screens/salas_screen.dart';
import 'package:flutter_maps_adv/widgets/custom_bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  static const String homeroute = 'home2';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final counterBlocUser = BlocProvider.of<AuthBloc>(context);
    // counterBlocUser.add(AuthInitEvent());

    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
              stream: counterBloc.counterStream,
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return IndexedStack(
                  index: counterBloc.index,
                  children: [
                    //if counterBloc
                    // Center(child: Text("Home")),
                    const LoadingMapScreen(),

                    Center(
                        child: ElevatedButton(onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => LoadingMapScreen(),
                              transitionDuration: Duration(
                                  milliseconds: 0))); //TODO: cambiar a loading
                    }, child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        //Boton cerrar sesion de
                        return MaterialButton(
                          child: Text('Cerrar sesion ${state.usuario?.nombre}'),
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context)
                                .add(AuthLogoutEvent());
                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        LoadingLoginScreen(),
                                    transitionDuration: Duration(
                                        milliseconds:
                                            0))); //TODO: cambiar a loading
                          },
                        );
                      },
                    ))),
                    GruposScreen(),
                    // SalasScreen(),
                    Text("Page 4"),
                    Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('Perfil')])),
                  ],
                );
              })
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}
