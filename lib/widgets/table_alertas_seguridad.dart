import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/models/reporte.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TableAlertsSeguridad extends StatelessWidget {
  const TableAlertsSeguridad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: [
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "robo-a-casa.svg",
                  text: "Robo a casa",
                  color: Colors.green,
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Robo a casa",
                              icon: "robo-a-casa.svg",
                              color: "4CAF50"))
                    }),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "robo-a-persona.svg",
                  text: "Robo a persona",
                  color: Colors.pink,
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Robo a persona",
                              icon: "robo-a-persona.svg",
                              color: "E91E63"))
                    }),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "robo-de-vehiculo.svg",
                  text: "Robo de vehiculo",
                  color: Colors.purple,
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Robo de vehiculo",
                              icon: "robo-de-vehiculo.svg",
                              color: "9C27B0"))
                    }),
          ],
        ),
        TableRow(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: const PhysicalModelCircleContainer(
                icon: "accidente.svg",
                text: "Accidente",
                color: Colors.blue,
              ),
              onTap: () => {
                Navigator.pushNamed(context, 'reporte',
                    arguments: Reporte(
                        tipo: "Accidente",
                        icon: "accidente.svg",
                        color: "2196F3"))
              },
            ),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "emergencia-de-ambulancia.svg",
                  text: "Emergencia de ambulancia",
                  color: Color.fromRGBO(244, 67, 54, 1),
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Emergencia de ambulancia",
                              icon: "emergencia-de-ambulancia.svg",
                              color: "F44336"))
                    }),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "emergencia-de-bomberos.svg",
                  text: "Emergencia de bomberos",
                  color: Color(0xFFFFC107),
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Emergencia de bomberos",
                              icon: "emergencia-de-bomberos.svg",
                              color: "FFC107"))
                    }),
          ],
        ),
        TableRow(
          children: [
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "drogas.svg",
                  text: "Drogas",
                  color: Colors.orange,
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Drogas",
                              icon: "drogas.svg",
                              color: "FF9800"))
                    }),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "actividad-sospechosa.svg",
                  text: "Actividad sospechosa",
                  color: Colors.cyan,
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Actividad sospechosa",
                              icon: "actividad-sospechosa.svg",
                              color: "00BCD4"))
                    }),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "problems-de-transporte-publico.svg",
                  text: "Problemas de transporte publico",
                  color: Colors.blueAccent,
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Problemas de transporte publico",
                              icon: "problems-de-transporte-publico.svg",
                              color: "448AFF"))
                    }),
          ],
        ),
      ],
    );
  }
}

class PhysicalModelCircleContainer extends StatelessWidget {
  final String icon;
  final String text;
  final Color color;

  const PhysicalModelCircleContainer({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          PhysicalModel(
            elevation: 4,
            shape: BoxShape.circle,
            color: color,
            child: Container(
              alignment: Alignment.center,
              width: 80,
              height: 80,
              // margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/alertas/$icon",
                fit: BoxFit.cover,
                width: 50,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
