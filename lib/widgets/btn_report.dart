import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/screens/alerts_screen.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BtnReport extends StatelessWidget {
  const BtnReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
            width: width * 0.95,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                //largor del boton

                backgroundColor: Color(0xFF6165FA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              ),
              onPressed: () {
                // AlertasScreen.routeName
                Navigator.pushNamed(context, AlartasScreen.routeName);
              },
              //icono de una campana de aleerta
              icon: Icon(FontAwesomeIcons.fire),
              label: Text("REPORTAR",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
