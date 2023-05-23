import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/models/lugares.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LugaresScreen extends StatelessWidget {
  static const String salesroute = 'lugares';
  const LugaresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Lugares> lugares = [
      Lugares(
          idUsuario: "1", uid: "abc123", ciudad: "Londres", barrio: "Camden"),
      Lugares(
          idUsuario: "2", uid: "def456", ciudad: "París", barrio: "Le Marais"),
      Lugares(
          idUsuario: "3",
          uid: "ghi789",
          ciudad: "Nueva York",
          barrio: "Brooklyn"),
      Lugares(
          idUsuario: "4", uid: "jkl012", ciudad: "Tokio", barrio: "Shibuya"),
      Lugares(
          idUsuario: "5", uid: "mno345", ciudad: "Roma", barrio: "Trastevere"),
      Lugares(idUsuario: "6", uid: "pqr678", ciudad: "Sídney", barrio: "Bondi")
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Mis Direcciones',
            style: TextStyle(color: Colors.black, fontSize: 20)),
        // backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: SvgPicture.asset(
                "assets/lugares1.svg",
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                "Agrega direcciones para mantenerte informado de lo que sucede alrededor de tus seres queridos y protegelos.",
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'addlugares');
                },
                child: Text('Agregar Dirección'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF111b21),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ),
            Container(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: lugares.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(lugares[index].ciudad),
                    subtitle: Text(lugares[index].barrio),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigator.pushNamed(context, 'lugardetail',
                      //     arguments: lugares[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
