import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
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
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.mapLocationDot),
              label: 'Mapa',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.newspaper),
              label: 'Noticias',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.users),
              label: 'Grupos',
            ),
            BottomNavigationBarItem(
              //R
              icon: Icon(FontAwesomeIcons.locationDot),
              label: 'Lugares',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.bars),
              label: 'Menú',
            ),
          ],
        );
      },
    );
  }
}
