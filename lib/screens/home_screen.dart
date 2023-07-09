import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/navigator/navigator_bloc.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:flutter_maps_adv/widgets/custom_bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  static const String homeroute = 'home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final publicationBloc = BlocProvider.of<PublicationBloc>(context);
    final counterBlocUser = BlocProvider.of<AuthBloc>(context);
    // counterBlocUser.add(AuthInitEvent());

    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<NavigatorBloc, NavigatorStateInit>(
            builder: (context, state) {
              return IndexedStack(
                index: state.index,
                children: [
                  //if counterBloc
                  // Center(child: Text("Home")),
                  const LoadingMapScreen(),
                  NewsScreen(onNewPublication: () async {
                    await publicationBloc.getNextPublicaciones();
                  }),

                  // GruposScreen(),
                  const RoomsScreen(),
                  const PlacesScreen(),
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
    );
  }
}
