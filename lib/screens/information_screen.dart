import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/screens/information_family_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InformationScreen extends StatefulWidget {
  static const String information = 'information';
  const InformationScreen({Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final TextEditingController telefonoController = TextEditingController();
  bool areFieldsEmpty = true;

  @override
  void initState() {
    super.initState();
    telefonoController.addListener(updateFieldsState);
  }

  @override
  void dispose() {
    telefonoController.removeListener(updateFieldsState);

    telefonoController.dispose();
    super.dispose();
  }

  void updateFieldsState() {
    setState(() {
      areFieldsEmpty = telefonoController.text.trim().isEmpty ||
          !isValidPhoneNumber(telefonoController.text.trim());
    });
  }

  bool isValidPhoneNumber(String phoneNumber) {
    // Expresión regular para validar el número telefónico
    // Debe tener 10 dígitos y empezar con "09"
    final RegExp phoneRegex = RegExp(r'^09\d{8}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: false,
        title: const Text(
          'Información del contacto',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Por favor complete su perfil de información de emergencia",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(0, 0, 0, 0.782),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                //bandera y +593
                Row(
                  children: [
                    //imagen de la bandera
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Image.asset(
                        'assets/ecuador.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 60,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Center(
                        child: Text(
                          'EC +593',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.782),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: telefonoController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 38,
              child: ElevatedButton(
                onPressed: areFieldsEmpty
                    ? null
                    : () async {
                        await authBloc
                            .addTelefono(telefonoController.text.trim());
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(
                            context, InformationFamily.informationFamily);
                      },
                child: const Text('Guardar'),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF6165FA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}