import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/models/lugares.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlacesScreen extends StatelessWidget {
  static const String salesroute = 'lugares';
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Lugares> lugares = [
      Lugares(
          idUsuario: "1", uid: "abc123", ciudad: "Londres", barrio: "Camden"),
      Lugares(
          idUsuario: "2", uid: "def456", ciudad: "París", barrio: "Le Marais"),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Mis Direcciones',
            style: TextStyle(color: Colors.black, fontSize: 20)),
        // backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            //pagado a la izquierda
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SvgPicture.asset(
                  "assets/lugares2.svg",
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.38,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, left: 20),
                width: MediaQuery.of(context).size.width * 0.95,
                child: const Text(
                  "Agrega direcciones para mantenerte informado de lo que sucede alrededor de tus seres queridos y protegelos.",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 14,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 30, bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PlaceAddScreen.placeddd);
                  },
                  child: Row(
                    children: const [
                      //icon de add grupo
                      Icon(
                        FontAwesomeIcons.plus,
                        color: Color(0xFF6165FA),
                        size: 20,
                      ),

                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        'Agregar dirección',
                        style:
                            TextStyle(color: Color(0xFF6165FA), fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.black12,
                thickness: 1,
              ),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: lugares.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(lugares[index].ciudad),
                    subtitle: Text(lugares[index].barrio),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigator.pushNamed(context, 'lugardetail',
                      //     arguments: lugares[index]);
                    },
                  );
                },
              ),
              const Divider(
                color: Colors.black12,
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
