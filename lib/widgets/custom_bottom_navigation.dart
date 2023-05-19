import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/helpers/navegacion.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: counterBloc.counterStream,
        builder: (context, snapshot) {
          return BottomNavigationBar(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: Color(0xFF6165FA),
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFFF2F2F2),
            unselectedItemColor: const Color(0xFF9B9B9B),
            currentIndex: counterBloc.index,
            onTap: (int i) {
              counterBloc.cambiarIndex(i);
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
        });
  }
}
