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
                  color: Color(0xFF58b368),
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Robo a casa",
                              icon: "robo-a-casa.svg",
                              color: "58b368"))
                    }),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "robo-a-persona.svg",
                  text: "Robo a persona",
                  color: Color(0xFF2C3E50),
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Robo a persona",
                              icon: "robo-a-persona.svg",
                              color: "2C3E50"))
                    }),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "robo-de-vehiculo.svg",
                  text: "Robo de vehiculo",
                  color: Color(0xFF9C27B0),
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
                text: "Accidente de tránsito ",
                color: Color(0xFF3498DB),
              ),
              onTap: () => {
                Navigator.pushNamed(context, 'reporte',
                    arguments: Reporte(
                        tipo: "Accidente de tránsito",
                        icon: "accidente.svg",
                        color: "3498DB"))
              },
            ),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "emergencia-de-ambulancia.svg",
                  text: "Emergencia de salud",
                  color: Color(0xFFE74C3C),
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Emergencia de salud",
                              icon: "emergencia-de-ambulancia.svg",
                              color: "E74C3C"))
                    }),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "emergencia-de-bomberos.svg",
                  text: "Emergencia de bomberos",
                  color: Color(0xFFFFBC3B),
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Emergencia de bomberos",
                              icon: "emergencia-de-bomberos.svg",
                              color: "FFBC3B"))
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
                  color: Color(0xFFE67F22),
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Drogas",
                              icon: "drogas.svg",
                              color: "E67F22"))
                    }),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "actividad-sospechosa.svg",
                  text: "Actividad sospechosa",
                  color: Color(0xFF2980B9),
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Actividad sospechosa",
                              icon: "actividad-sospechosa.svg",
                              color: "2980B9"))
                    }),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "prueba.svg",
                  text: "Prueba",
                  color: Color(0xFF6D6D6D),
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Prueba",
                              icon: "prueba.svg",
                              color: "6D6D6D"))
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
    super.key,
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
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
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
