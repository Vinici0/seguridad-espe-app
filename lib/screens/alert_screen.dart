import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AlertScreen extends StatelessWidget {
  static const String routeName = 'alert';
  const AlertScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //agrega un svg y el texto de la alerta
        iconTheme: IconThemeData(color: Colors.white),
        // centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/alertas/accidente.svg',
              width: 30,
              height: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text('Accidente'),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 0, 73, 128),
      ),
      body: Container(
        color: Color.fromARGB(255, 0, 73, 128),
        child: Center(
          //agrega un texfield
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Describe lo que sucedió',
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: Color.fromARGB(255, 0, 85, 149),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  onPressed: () {},
                  child: Icon(FontAwesomeIcons.userSecret),
                  heroTag: "fab1",
                  backgroundColor: Color.fromARGB(255, 0, 85, 149),
                ),
                FloatingActionButton.extended(
                  onPressed: () {},
                  label: Text('Reportar'),
                  icon: Icon(FontAwesomeIcons.fire),
                  heroTag: "fab2",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
