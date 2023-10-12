import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/helpers/mostrar_alerta.dart';
import 'package:flutter_maps_adv/models/institucionmodel.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:flutter_maps_adv/widgets/boton_login.dart';
import 'package:flutter_maps_adv/widgets/custom_input.dart';
import 'package:flutter_maps_adv/widgets/labels_login.dart';
import 'package:flutter_maps_adv/widgets/logo_login.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterScreen extends StatelessWidget {
  static const String registerroute = 'register';

  const RegisterScreen({Key? key}) : super(key: key);

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
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 170,
                        height: 170,
                        child: SvgPicture.asset(
                          'assets/iconvinculacion/login.svg',
                        )),
                    const _From(),
                    const Labels(
                        ruta: 'login',
                        text: "¿Ya tienes cuenta?",
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  String? unidadEducativa = '';
// Definición de la lista de DropdownMenuItem
  List<DropdownMenuItem<String>> dropdownItems = [];

  AuthBloc authServiceBloc = AuthBloc();
  @override
  void initState() {
    authServiceBloc = BlocProvider.of<AuthBloc>(context, listen: false);

    // authServiceBloc.add(const EventListInstituciones());
    for (Institucione institucion in authServiceBloc.instituciones) {
      dropdownItems.add(
        DropdownMenuItem(
          value: institucion.nombre,
          child: Text(institucion.nombre,
              style: const TextStyle(color: Colors.black54)),
        ),
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //Nombre
      CustonInput(
        icon: Icons.perm_identity,
        placeholder: "Nombres",
        keyboardType: TextInputType.text,
        textController: nomController,
      ),

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
      //Select para el tipo de usuario
      Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  //offset: para mover la sobra
                  offset: Offset(0, 5),
                  blurRadius: 5)
            ]),
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Color(0xFF7ab466)),
              //cuando se selecciona el input sea de un color verde - border
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFF7ab466)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFF7ab466)),
            ),
            hintText: 'Unidad educativa afiliada',
            labelText: 'Unidad educativa afiliada',
            labelStyle: const TextStyle(color: Colors.black54),
            prefixIcon: const Icon(Icons.person, color: Color(0xFF7ab466)),
          ),
          items: dropdownItems, // Utiliza la lista de elementos aquí
          onChanged: (opt) {
            setState(() {
              unidadEducativa = opt;
            });
          },
        ),
      ),
      BotonForm(
        text: "Crear cuenta",
        onPressed: authServiceBloc.isLoggedInTrue
            ? () {}
            : () async {
                FocusScope.of(context).unfocus();

                String nombre = nomController.text.trim();
                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                if (nombre.isEmpty || email.isEmpty || password.isEmpty) {
                  // Mostrar alerta indicando que los campos son obligatorios
                  mostrarAlerta(context, 'Campos vacíos',
                      'Todos los campos son obligatorios');
                  return;
                }

                if (!isValidEmail(email)) {
                  // Mostrar alerta indicando que el formato del correo electrónico es incorrecto
                  mostrarAlerta(context, 'Correo electrónico inválido',
                      'Ingrese un correo electrónico válido');
                  return;
                }

                if (password.length < 6) {
                  // Mostrar alerta indicando que la contraseña debe tener al menos 6 caracteres
                  mostrarAlerta(context, 'Contraseña inválida',
                      'La contraseña debe tener al menos 6 caracteres');
                  return;
                }

                if (!containsNumber(password)) {
                  // Mostrar alerta indicando que la contraseña debe contener al menos un número
                  mostrarAlerta(context, 'Contraseña inválida',
                      'La contraseña debe contener al menos un número');
                  return;
                }

                if (!containsUppercaseLetter(password)) {
                  // Mostrar alerta indicando que la contraseña debe contener al menos una letra en mayúscula
                  mostrarAlerta(context, 'Contraseña inválida',
                      'La contraseña debe contener al menos una letra en mayúscula');
                  return;
                }

                if (unidadEducativa == '') {
                  mostrarAlerta(context, 'Unidad no seleccionada',
                      'Seleccione una unidad educativa afiliada');
                  return;
                }

                final resulta = await authServiceBloc.register(
                    nombre, email, password, unidadEducativa ?? '');

                if (!resulta) {
                  // Mostrar alerta indicando que el correo electrónico ya está en uso
                  // ignore: use_build_context_synchronously
                  mostrarAlerta(context, 'Correo electrónico en uso',
                      'El correo electrónico ya está en uso');
                  return;
                }

                if (authServiceBloc.isLoggedInTrue) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(
                      context, LoadingLoginScreen.loadingroute);
                } else {
                  // ignore: use_build_context_synchronously
                  mostrarAlerta(context, 'Registro incorrecto',
                      'Revise sus credenciales nuevamente');
                }

                //Si no escogio ninguna unidad educativa afiliada no se registra
              },
      )
    ]);
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');

    return emailRegex.hasMatch(email);
  }

  bool containsNumber(String password) {
    return password.contains(RegExp(r'\d'));
  }

  bool containsUppercaseLetter(String password) {
    return password.contains(RegExp(r'[A-Z]'));
  }
}
