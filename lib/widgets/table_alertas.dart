import 'package:flutter/material.dart';

class TableAlerts extends StatelessWidget {
  const TableAlerts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: [
            _buildCircleContainer(Icons.access_alarm),
            _buildCircleContainer(Icons.access_alarm),
            _buildCircleContainer(Icons.access_alarm),
          ],
        ),
        TableRow(
          children: [
            _buildCircleContainer(Icons.access_alarm),
            _buildCircleContainer(Icons.access_alarm),
            _buildCircleContainer(Icons.access_alarm),
          ],
        ),
      ],
    );
  }

  Widget _buildCircleContainer(IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            //center
            alignment: Alignment.center,
            width: 80,
            height: 80,
            //borde del circulo de color gris

            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              //borde del circulo de color blanco
              border: Border.all(color: Colors.white, width: 2),
              shape: BoxShape.circle,
              color: Colors.blueGrey[400],
            ),
            child: Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
          ),
          //center text

          Center(
            child: Text(
              'Alertadawdadawdawdwada',
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
