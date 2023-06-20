import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InformationFamily extends StatefulWidget {
  static const String informationFamily = 'information_family';
  const InformationFamily({Key? key}) : super(key: key);

  @override
  State<InformationFamily> createState() => _InformationFamilyState();
}

class _InformationFamilyState extends State<InformationFamily> {
  final TextEditingController telefonoController = TextEditingController();
  bool areFieldsEmpty = true;
  late SvgPicture image1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    telefonoController.addListener(updateFieldsState);
    image1 = SvgPicture.asset(
      "assets/info/numberfamily.svg",
      fit: BoxFit.cover,
    );
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
    final RegExp phoneRegex = RegExp(r'^09\d{8}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final authService = BlocProvider.of<AuthBloc>(
      context,
    );

    //recupera dato de los argumentos
    final routeActive = ModalRoute.of(context)?.settings.arguments as bool;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: false,
        automaticallyImplyLeading: routeActive,
        title: const Text(
          'Numeros de Familiares',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          routeActive
              ? Container()
              : TextButton(
                  onPressed: authService.state.usuario?.telefonos.isNotEmpty ??
                          false
                      ? () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, HomeScreen.homeroute, (route) => false);
                        }
                      : null,
                  child: Text(
                    'Siguiente',
                    style: TextStyle(
                      color: authService.state.usuario?.telefonos.isNotEmpty ??
                              false
                          ? const Color(0xFF6165FA)
                          : Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  shrinkWrap: true,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.80,
                          height: MediaQuery.of(context).size.height * 0.40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: image1),
                    ),
                    const Text(
                      "Agregar números de familiares para que puedan recibir alertas de tus seres queridos.",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(0, 0, 0, 0.782),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _TextFieldAddTelefono(
                        telefonoController: telefonoController),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 38,
                      child: ElevatedButton(
                        onPressed: areFieldsEmpty
                            ? null
                            : () {
                                if (authService.state.usuario?.telefonos
                                        .contains(
                                            telefonoController.text.trim()) ??
                                    false) {
                                  mostrarAlerta(
                                    context,
                                    'Número ya registrado',
                                    'El número que intenta registrar ya se encuentra registrado.',
                                  );
                                  return;
                                }
                                authService.addTelefonoFamily(
                                    telefonoController.text.trim());
                                telefonoController.clear();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6165FA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text('Agregar número'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _ListContact(authService: authService),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void mostrarAlerta(BuildContext context, String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (!Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(titulo),
            content: Text(mensaje),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text(titulo),
            content: Text(mensaje),
            actions: <Widget>[
              TextButton(
                child: const Text('Cerrar',
                    style: TextStyle(color: Color(0xFF6165FA))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }
}

class _TextFieldAddTelefono extends StatelessWidget {
  const _TextFieldAddTelefono({
    Key? key,
    required this.telefonoController,
  }) : super(key: key);

  final TextEditingController telefonoController;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.asset(
                "assets/ecuador.jpg",
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
    );
  }
}

class _ListContact extends StatelessWidget {
  const _ListContact({
    Key? key,
    required this.authService,
  }) : super(key: key);

  final AuthBloc authService;

  @override
  Widget build(BuildContext context) {
    final state = authService.state;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: state.usuario?.telefonos.length ?? 0,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ListTile(
            leading: const Icon(
              Icons.person,
              color: Color(0xFF6165FA),
            ),
            title: Text(
              state.usuario?.telefonos[index] ?? '',
              style: const TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.782),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: IconButton(
              onPressed: () async {
                await authService.deleteTelefonoFamily(
                    state.usuario?.telefonos[index] ?? '');
              },
              icon: const Icon(
                Icons.delete,
                color: Color.fromRGBO(0, 0, 0, 0.782),
              ),
            ),
          ),
        );
      },
    );
  }
}
