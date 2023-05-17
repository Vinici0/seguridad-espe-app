import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/helpers/mostrar_alerta.dart';
import 'package:flutter_maps_adv/resources/services/socket_service.dart';
import 'package:flutter_maps_adv/screens/home_screen.dart';
import 'package:flutter_maps_adv/screens/loading_login_screen.dart';
import 'package:flutter_maps_adv/widgets/boton_login.dart';
import 'package:flutter_maps_adv/widgets/custom_input.dart';
import 'package:flutter_maps_adv/widgets/labels_login.dart';
import 'package:flutter_maps_adv/widgets/logo_login.dart';

class LoginScreen extends StatelessWidget {
  static const String loginroute = 'login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.all(30),
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Logo(text: "Seguridad"),
                      _From(),
                      Labels(
                          ruta: 'register',
                          text: "¿No tienes cuenta?",
                          text2: "Crea una"),
                      SizedBox(height: 10),
                      Text("Terminos y condiciones de uso",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 0.782)))
                    ]),
              ),
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

    final socketService = SocketService();

    return Container(
      child: Column(children: [
        CustonInput(
          icon: Icons.mail_outline,
          placeholder: "Email",
          keyboardType: TextInputType.emailAddress,
          textController: emailController,
        ),
        CustonInput(
          icon: Icons.lock_outline,
          placeholder: "Password",
          textController: passwordController,
          isPassword: true,
        ),
        BotonForm(
          text: "Ingrese",
          onPressed: () async {
            FocusScope.of(context).unfocus();

            authBloc.add(AuthLoginEvent(
                email: emailController.text,
                password: passwordController.text));

            // socketService.connect();
            if (await authBloc.apiAuthRepository
                .login(emailController.text, passwordController.text)) {
              Navigator.pushReplacementNamed(
                  context, LoadingLoginScreen.loadingroute);
            } else {
              mostrarAlerta(context, "Login incorrecto",
                  "Revise sus credenciales nuevamente");
            }
          },
        ),
      ]),
    );
  }
}
