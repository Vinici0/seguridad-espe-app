import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/helpers/navegacion.dart';
import 'package:flutter_maps_adv/screens/config_screen.dart';
import 'package:flutter_maps_adv/screens/loading_login_screen.dart';
import 'package:flutter_maps_adv/screens/loading_map_screen.dart';
import 'package:flutter_maps_adv/screens/news_screen.dart';
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
                    NewsScreen(),

                    // GruposScreen(),
                    SalasScreen(),
                    Text("Page 4"),
                    Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [ConfigScreen()])),
                  ],
                );
              })
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}
