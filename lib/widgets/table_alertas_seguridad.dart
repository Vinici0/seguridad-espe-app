import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TableAlertsSeguridad extends StatelessWidget {
  const TableAlertsSeguridad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      children: const [
        TableRow(
          children: [
            PhysicalModelCircleContainer(
              icon: "robo-a-casa.svg",
              text: "Robo a casa",
              color: Colors.green,
            ),
            PhysicalModelCircleContainer(
              icon: "robo-a-persona.svg",
              text: "Robo a persona",
              color: Colors.pink,
            ),
            PhysicalModelCircleContainer(
              icon: "robo-de-vehiculo.svg",
              text: "Robo de vehiculo",
              color: Colors.purple,
            ),
          ],
        ),
        TableRow(
          children: [
            PhysicalModelCircleContainer(
              icon: "accidente.svg",
              text: "Accidente",
              color: Colors.blue,
            ),
            PhysicalModelCircleContainer(
              icon: "emergencia-de-ambulancia.svg",
              text: "Emergencia de ambulancia",
              color: Colors.red,
            ),
            PhysicalModelCircleContainer(
              icon: "emergencia-de-bomberos.svg",
              text: "Emergencia de bomberos",
              color: Colors.amber,
            ),
          ],
        ),
        TableRow(
          children: [
            PhysicalModelCircleContainer(
              icon: "drogas.svg",
              text: "Drogas",
              color: Colors.orange,
            ),
            PhysicalModelCircleContainer(
              icon: "actividad-sospechosa.svg",
              text: "Actividad sospechosa",
              color: Colors.cyan,
            ),
            PhysicalModelCircleContainer(
              icon: "problems-de-transporte-publico.svg",
              text: "Problemas de transporte publico",
              color: Colors.blueAccent,
            ),
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
