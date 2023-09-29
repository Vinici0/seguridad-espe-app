import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/models/reporte.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TableAlertsSeguridad extends StatelessWidget {
  const TableAlertsSeguridad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Table(
        children: [
          TableRow(
            children: [
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: const PhysicalModelCircleContainer(
                    icon: "robo.svg",
                    text: "Robo",
                    color: Color(0xFFeddbc4),
                  ),
                  onTap: () => {
                        Navigator.pushNamed(context, 'reporte',
                            arguments: Reporte(
                                tipo: "Robo",
                                icon: "robo.svg",
                                color: "eddbc4"))
                      }),
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: const PhysicalModelCircleContainer(
                    icon: "bullying1.svg",
                    text: "Bullying",
                    color: Color(0xFFa3c9a7),
                  ),
                  onTap: () => {
                        Navigator.pushNamed(context, 'reporte',
                            arguments: Reporte(
                                tipo: "Bullying",
                                icon: "bullying1.svg",
                                color: "a3c9a7"))
                      }),
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: const PhysicalModelCircleContainer(
                    icon: "violencia_entre_pares1.svg",
                    text: "Violencia por pares",
                    color: Color(0xFFffb353),
                  ),
                  onTap: () => {
                        Navigator.pushNamed(context, 'reporte',
                            arguments: Reporte(
                                tipo: "Violencia por pares",
                                icon: "violencia_entre_pares1.svg",
                                color: "ffb353"))
                      }),
            ],
          ),
          TableRow(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const PhysicalModelCircleContainer(
                  icon: "acoso_sexual1.svg",
                  text: "Acoso sexual",
                  color: Color(0xFFff6e4a),
                ),
                onTap: () => {
                  Navigator.pushNamed(context, 'reporte',
                      arguments: Reporte(
                          tipo: "Acoso sexual",
                          icon: "acoso_sexual1.svg",
                          color: "ff6e4a"))
                },
              ),
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: const PhysicalModelCircleContainer(
                    icon: "droga1.svg",
                    text: "Alcohol y drogas",
                    color: Color(0xFF5c5259),
                  ),
                  onTap: () => {
                        Navigator.pushNamed(context, 'reporte',
                            arguments: Reporte(
                                tipo: "Alcohol y drogas",
                                icon: "droga1.svg",
                                color: "5c5259"))
                      }),
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: const PhysicalModelCircleContainer(
                    icon: "maltrato1.svg",
                    text: "Maltrato escolar",
                    color: Color(0xFF8bb375),
                  ),
                  onTap: () => {
                        Navigator.pushNamed(context, 'reporte',
                            arguments: Reporte(
                                tipo: "Maltrato escolar",
                                icon: "maltrato1.svg",
                                color: "8bb375"))
                      }),
            ],
          ),
          TableRow(
            children: [
              TableCell(child: Container()),
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: const PhysicalModelCircleContainer(
                    icon: "otros.svg",
                    text: "Otros",
                    color: Color(0xFFa68c69),
                  ),
                  onTap: () => {
                        Navigator.pushNamed(context, 'reporte',
                            arguments: Reporte(
                                tipo: "Otros",
                                icon: "otros.svg",
                                color: "a68c69"))
                      }),
              TableCell(child: Container()),
            ],
          ),
        ],
      ),
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
                "assets/iconvinculacion/$icon",
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
