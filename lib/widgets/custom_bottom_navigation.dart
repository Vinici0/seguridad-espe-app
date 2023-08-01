import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final authService = BlocProvider.of<AuthBloc>(context);
    return BlocBuilder<NavigatorBloc, NavigatorStateInit>(
      builder: (context, state) {
        return BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: const Color(0xFF6165FA),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0.5,
          unselectedItemColor: Colors.grey[800],
          currentIndex: state.index,
          onTap: (int i) {
            BlocProvider.of<NavigatorBloc>(context)
                .add(NavigatorIndexEvent(index: i));

            mapBloc.add(OnMapMovedEvent());
            BlocProvider.of<SearchBloc>(context)
                .add(OnDeactivateManualMarkerEvent());

            if (i == 1) {
              authService.add(const MarcarPublicacionPendienteFalse());
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.mapLocationDot),
              label: 'Mapa',
            ),
            BottomNavigationBarItem(
              icon: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, states) {
                  return Stack(
                    children: [
                      const Icon(FontAwesomeIcons.newspaper),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: states.usuario!.isPublicacionPendiente == true
                            ? Container(
                                padding: const EdgeInsets.only(
                                  left:
                                      5, // Ajusta estos valores para mover el punto
                                  right: 5, // en la dirección deseada
                                  top: 2,
                                  bottom: 2,
                                ),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors
                                      .red, // Puedes cambiar el color del punto aquí
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 9,
                                  minHeight: 9,
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  );
                },
              ),
              label: 'Noticias',
            ),
            const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.users),
              label: 'Grupos',
            ),
            const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.locationDot),
              label: 'Lugares',
            ),
            const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.bars),
              label: 'Menú',
            ),
          ],
        );
      },
    );
  }
}
/*
   mapBloc.add(OnMapMovedEvent());
                BlocProvider.of<SearchBloc>(context)
                    .add(OnDeactivateManualMarkerEvent());
 */