import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/models/reporte.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TableAlertsCompunidad extends StatelessWidget {
  const TableAlertsCompunidad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Variables de colores como cadenas
    const String greenColor = "0xFF8EB582"; // Green
    const String pinkColor = "0xFFff2e74"; // Pink
    const String purpleColor = "0xFF7f66ff"; // Purple
    const String blueColor = "0xFF43abcd"; // Blue

    return Table(
      children: [
        TableRow(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => {
                Navigator.pushNamed(context, 'reporte',
                    arguments: Reporte(
                        tipo: "Problemas de agua",
                        icon: "problemas-alcantarillado.svg",
                        color: "8EB582"))
              },
              child: PhysicalModelCircleContainer(
                icon: "problemas-alcantarillado.svg",
                text: "Problemas de alcantarillado",
                color: Color(int.parse(greenColor)),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => {
                Navigator.pushNamed(context, 'reporte',
                    arguments: Reporte(
                        tipo: "Problemas de basura",
                        icon: "problemas-de-basura.svg",
                        color: "ff2e74"))
              },
              child: PhysicalModelCircleContainer(
                icon: "problemas-de-basura.svg",
                text: "Problemas de basura",
                color: Color(int.parse(pinkColor)),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => {
                Navigator.pushNamed(context, 'reporte',
                    arguments: Reporte(
                        tipo: "Problemas de energia",
                        icon: "problemas-de-energia.svg",
                        color: "7f66ff")),
              },
              child: PhysicalModelCircleContainer(
                icon: "problemas-de-energia.svg",
                text: "Problemas de energia",
                color: Color(int.parse(purpleColor)),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => {
                Navigator.pushNamed(context, 'reporte',
                    arguments: Reporte(
                        tipo: "Problemas de telecomunicaciones",
                        icon: "problemas-de-telecomunicaciones.svg",
                        color: "43abcd"))
              },
              child: PhysicalModelCircleContainer(
                icon: "problemas-de-telecomunicaciones.svg",
                text: "Problemas de telecomunicaciones",
                color: Color(int.parse(blueColor)),
              ),
            ),
            // No quiero ubicar más columnas en esta fila
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "problems-de-transporte-publico.svg",
                  text: "Problemas de transporte publico",
                  color: Color(0xFF414073),
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Problemas de transporte publico",
                              icon: "problems-de-transporte-publico.svg",
                              color: "414073"))
                    }),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "corazon.png",
                  text: "Buena acción",
                  color: Color(0xFFeea15f),
                  isSvg: false,
                ),
                onTap: () => {
                      Navigator.pushNamed(context, 'reporte',
                          arguments: Reporte(
                              tipo: "Buena acción",
                              icon: "corazon.png",
                              color: "eea15f",
                              isSvg: false))
                    }),
          ],
        ),
        TableRow(children: [
          // No quiero ubicar más columnas en esta fila
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: const PhysicalModelCircleContainer(
                icon: "comunicar.png",
                text: "Aviso comunitario",
                color: Color(0xFFff2e74),
                isSvg: false,
              ),
              onTap: () => {
                    Navigator.pushNamed(context, 'reporte',
                        arguments: Reporte(
                            tipo: "Aviso comunitario",
                            icon: "comunicar.png",
                            color: "ff2e74",
                            isSvg: false))
                  }),
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: const PhysicalModelCircleContainer(
                icon: "mascotas.png",
                text: "Mascota perdida",
                color: Color(0xFFFC9032),
                isSvg: false,
              ),
              onTap: () => {
                    Navigator.pushNamed(context, 'reporte',
                        arguments: Reporte(
                            tipo: "Mascota perdida",
                            icon: "mascotas.png",
                            color: "FC9032",
                            isSvg: false))
                  }),
          //agrega un espacio vacio
          const TableCell(
            child: SizedBox(),
          ),
        ]),
        // vacio
      ],
    );
  }
}

class PhysicalModelCircleContainer extends StatelessWidget {
  final String icon;
  final String text;
  final Color color;
  final bool isSvg;

  const PhysicalModelCircleContainer({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    this.isSvg = true,
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
              child: isSvg
                  ? SvgPicture.asset(
                      "assets/alertas/$icon",
                      fit: BoxFit.cover,
                      width: 50,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    )
                  : Image.asset(
                      "assets/alertas/$icon",
                      fit: BoxFit.cover,
                      width: 50,
                      color: Colors.white,
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
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
