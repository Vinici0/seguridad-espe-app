import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreen extends StatelessWidget {
  static const String authroute = 'auth';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Fondo(),
          //Logo de la aplicacion
          Container(
            margin: const EdgeInsets.only(top: 10),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(
                    width: 290,
                    height: 290,
                    child: SvgPicture.asset(
                      'assets/iconvinculacion/logo_movil.svg',
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Fondo extends StatelessWidget {
  const Fondo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      //que empiece de abajo hacia arriba
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,

      children: [
        Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6,
            // color: Color.fromARGB(255, 196, 98, 98),
            decoration: const BoxDecoration(
              color: Color(0xFF1d5f28),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(170),
                  topRight: Radius.circular(170)),
            ),
            //Agregar el boton de iniciar sesion y registrarse
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Centra los elementos verticalmente

              children: [
                //Boton de iniciar sesion y registrarse
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'login');
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF7ab466),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(70)),
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.25,
                            vertical: 15),
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    child: const Text('Iniciar Sesion'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'register');
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xFF1d5f28),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(70)),
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.27,
                            vertical: 15),
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    child: const Text('Registrarse'),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
