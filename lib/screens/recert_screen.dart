import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/helpers/mostrar_alerta.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:flutter_maps_adv/widgets/boton_login.dart';
import 'package:flutter_maps_adv/widgets/custom_input.dart';
import 'package:flutter_maps_adv/widgets/labels_login.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecertScreen extends StatelessWidget {
  static const String recertroute = 'recert';
  const RecertScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              margin: const EdgeInsets.all(30),
              height: MediaQuery.of(context).size.height * 0.99,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        //Restablecer contraseña
                        const Text(
                          "Restablecer contraseña",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        SizedBox(
                            width: 240,
                            height: 240,
                            child: SvgPicture.asset(
                              'assets/olvida_contrasena.svg',
                            )),
                      ],
                    ),
                    const Text(
                        "¿Olvidaste tu contraseña? Por favor, introduce tu dirección de correo electrónico. Muy pronto nos pondremos en contacto con usted para restablecer tu contraseña.",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 0, 0, 0.782))),
                    const _From(),
                    const Labels(
                        ruta: 'login',
                        text: "¿No tienes cuenta?",
                        text2: "Ingresa"),
                    const SizedBox(height: 10),
                    const Text("Terminos y condiciones de uso",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 0, 0, 0.782)))
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _From extends StatefulWidget {
  const _From({super.key});

  @override
  State<_From> createState() => __FromState();
}

class __FromState extends State<_From> {
  //provider

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final roomBloc = BlocProvider.of<RoomBloc>(context);
    final publicationBloc = BlocProvider.of<PublicationBloc>(context);
    return Column(children: [
      CustonInput(
        icon: Icons.mail_outline,
        placeholder: "Email",
        keyboardType: TextInputType.emailAddress,
        textController: emailController,
      ),
      BotonForm(
        text: "Enviar",
        onPressed: () async {
          FocusScope.of(context).unfocus();

          // Validar que el correo sea válido con un operador ternario
          final isEmailValid = emailController.text.isNotEmpty &&
              emailController.text.contains("@");

          if (isEmailValid) {
            final result = await authBloc.recoverPassword(
              emailController.text,
            );

            if (result) {
              mostrarAlerta(
                context,
                "Correo enviado",
                "Se ha enviado con éxito el correo para recuperar su contraseña.",
              );
            } else {
              // ignore: use_build_context_synchronously
              mostrarAlerta(
                context,
                "Error al recuperar contraseña",
                "Revise sus credenciales nuevamente",
              );
            }
          } else {
            mostrarAlerta(
              context,
              "El correo no es válido",
              "Revise sus credenciales nuevamente",
            );
          }
        },
      ),
    ]);
  }
}
