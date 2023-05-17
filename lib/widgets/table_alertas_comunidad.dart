import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TableAlertsCompunidad extends StatelessWidget {
  const TableAlertsCompunidad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Variables de colores como cadenas
    final String greenColor = "0xFF00FF00"; // Green
    final String pinkColor = "0xFFFFC0CB"; // Pink
    final String purpleColor = "0xFF800080"; // Purple
    final String blueColor = "0xFF0000FF"; // Blue

    return Table(
      children: [
        TableRow(
          children: [
            PhysicalModelCircleContainer(
              icon: "problemas-alcantarillado.svg",
              text: "Problemas de alcantarillado",
              color: Color(int.parse(greenColor)),
            ),
            PhysicalModelCircleContainer(
              icon: "problemas-de-basura.svg",
              text: "Problemas de basura",
              color: Color(int.parse(pinkColor)),
            ),
            PhysicalModelCircleContainer(
              icon: "problemas-de-energia.svg",
              text: "Problemas de energia",
              color: Color(int.parse(purpleColor)),
            ),
          ],
        ),
        TableRow(
          children: [
            PhysicalModelCircleContainer(
              icon: "problemas-de-telecomunicaciones.svg",
              text: "Problemas de telecomunicaciones",
              color: Color(int.parse(blueColor)),
            ),
            // No quiero ubicar más columnas en esta fila
            TableCell(
              child: SizedBox(),
            ),
            TableCell(
              child: SizedBox(),
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
