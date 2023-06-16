import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/widgets/home/table_alertas_comunidad.dart';
import 'package:flutter_maps_adv/widgets/home/table_alertas_seguridad.dart';

class AlertsScreen extends StatelessWidget {
  static const String routeName = 'alertas';
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Reportar"),
          //color de la flcha de regreso blanco
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF111b21),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: ("SEGURIDAD"),
              ),
              Tab(
                text: ("COMUNIDAD"),
              ),
            ],
          ),
        ),
        body: Container(
          color: const Color(0xFF111b21),
          child: const TabBarView(
            //color de fondo de la pantalla

            children: [
              TableAlertsSeguridad(),
              TableAlertsCompunidad(),
            ],
          ),
        ),
      ),
    );
  }
}
