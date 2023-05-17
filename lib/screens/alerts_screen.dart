import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/models/reporte.dart';
import 'package:flutter_maps_adv/widgets/page_title.dart';
import 'package:flutter_maps_adv/widgets/table_alertas_comunidad.dart';
import 'package:flutter_maps_adv/widgets/table_alertas_seguridad.dart';

class AlartasScreen extends StatelessWidget {
  static const String routeName = 'alertas';
  const AlartasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          centerTitle: false,
          title: new Text("Reportar"),
          //color de la flcha de regreso blanco
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromARGB(255, 0, 73, 128),
          bottom: TabBar(
            tabs: [
              Tab(
                text: ("SEGURIDAD"),
              ),
              Tab(
                text: ("CIUDAD"),
              ),
            ],
          ),
        ),
        body: Container(
          color: Color.fromARGB(255, 0, 73, 128),
          child: TabBarView(
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
