// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/blocs/publication/publication_bloc.dart';
import 'package:flutter_maps_adv/models/reporte.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AlertScreen extends StatefulWidget {
  static const String routeName = 'reporte';

  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  bool isIconicActivated = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Position? currentPosition;
  String name = '';
  String ciudad = '';
  final _textController = TextEditingController();
  final ImagePicker imgpicker = ImagePicker();
  List<String>? imagePaths;
  List<XFile>? imagefiles;
  bool isPressed = false;
  bool isButtonDisabled = false;
  bool isLoading = false;
  final FocusNode _focusNode = FocusNode();

  bool isErrorMessageShown = false; // New flag to track error dialog

  @override
  void initState() {
    super.initState();
    isButtonDisabled = false;

    Future.delayed(Duration.zero, () {
      _focusNode.requestFocus();
    });
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Reporte reporte =
        ModalRoute.of(context)!.settings.arguments as Reporte;

    final size = MediaQuery.of(context).size;
    final publicaciones = BlocProvider.of<PublicationBloc>(context);
    final authService = BlocProvider.of<AuthBloc>(context, listen: false);

    //controlar que reporte no sea null

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF111b21),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(int.parse('0xFF${reporte.color}')),
              child: reporte.isSvg == true
                  ? SvgPicture.asset(
                      'assets/alertas/${reporte.icon}',
                      width: 30,
                      color: Colors.white,
                    )
                  : Image.asset(
                      'assets/alertas/${reporte.icon}',
                      width: 30,
                      color: Colors.white,
                    ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: size.width * 0.6,
              child: Text(
                reporte.tipo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFF111b21),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: const Color(0xFF111b21),
                          child: TextField(
                            focusNode: _focusNode,
                            maxLength: 500,
                            controller:
                                _textController, //sirve para limpiar el texto del textfield cuando se envia el mensaje
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                            maxLines: null,
                            expands: true,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              filled: true,
                              hintText: '¿Qué está pasando?',
                              border: InputBorder.none,
                              //color del texto blanco
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.white),
                              fillColor: Color(0xFF111b21),

                              //size del texto
                              // contentPadding: EdgeInsets.all(20),
                            ),
                            textAlignVertical: TextAlignVertical.top,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          // color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 15),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 49, 67, 78),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  alignment: Alignment.center,
                                  icon: const Icon(
                                    FontAwesomeIcons.image,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    openImages();
                                  },
                                ),
                              ),
                              Expanded(
                                  child: Row(
                                children: [
                                  //icono de ubicacion
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF202c33),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Row(
                                        children: [
                                          Container(
                                              // color: Color.fromARGB(255, 49, 67, 78),
                                              padding: const EdgeInsets.all(5),
                                              decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 49, 67, 78),
                                                borderRadius: BorderRadius.only(
                                                    //bordes redondeados
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10)),
                                              ),
                                              child: const Icon(
                                                Icons.location_on,
                                                color: Colors.white,
                                              )),
                                          //icono con texto de ubicacion
                                          Container(
                                            // color: Color.fromARGB(255, 0, 93, 164),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              '${name.isNotEmpty ? name : 'Ubicación'} - ${ciudad.isNotEmpty ? ciudad : 'Ciudad'}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ),

                        //Lista de imagenes selccinoadas de la galeria

                        imagefiles != null
                            ? SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: imagefiles!.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      //bordes redondeados
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      margin: const EdgeInsets.all(5),
                                      width: 100,
                                      height: 100,
                                      child: Image.file(
                                        File(imagefiles![index].path),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(top: 10),
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: const Text(
                                  'Máximo 3 fotos',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),

                        const Divider(
                          color: Colors.white,
                        ),
                        //repotar o reportar incognito el incidente
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                setState(() {
                                  isIconicActivated = !isIconicActivated;
                                });
                                Fluttertoast.showToast(
                                  msg:
                                      'Modo icónico ${isIconicActivated ? 'activado' : 'desactivado'}',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: const Color(0xFF6165FA),
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              },
                              child: Tooltip(
                                message: isIconicActivated
                                    ? 'Modo icónico activado'
                                    : 'Modo icónico desactivado',
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: isIconicActivated
                                        ? const Color.fromARGB(
                                            255, 243, 149, 33)
                                        : Colors.grey,
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.userSecret,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 43,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFF6165FA),
                              ),
                              child: MaterialButton(
                                onPressed: isButtonDisabled
                                    ? null
                                    : () async {
                                        _focusNode
                                            .unfocus(); // Hide the keyboard
                                        final text =
                                            _textController.text.trim();

                                        if (text.isEmpty &&
                                            !isErrorMessageShown) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'Campo vacío',
                                                  style: TextStyle(
                                                    color: Color(0xFF6165FA),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content:
                                                    const SingleChildScrollView(
                                                  child: Text(
                                                    'Por favor, escriba qué sucedió.',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text(
                                                      'Aceptar',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF6165FA),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else if (text.isNotEmpty) {
                                          try {
                                            setState(() {
                                              isLoading =
                                                  true; // Mostrar el indicador de progreso
                                              isErrorMessageShown = true;
                                              isButtonDisabled = true;
                                            });
                                            await publicaciones
                                                .createPublication(
                                              reporte.tipo,
                                              text,
                                              reporte.color,
                                              reporte.icon,
                                              !isIconicActivated,
                                              true,
                                              authService.state.usuario!.uid,
                                              authService.state.usuario!.nombre,
                                              imagePaths ?? [],
                                            );
                                            Fluttertoast.showToast(
                                              msg:
                                                  'Reporte publicado en noticias',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 2,
                                              backgroundColor:
                                                  const Color(0xFF6165FA),
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );

                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            setState(() {
                                              isLoading =
                                                  false; // Ocultar el indicador de progreso
                                            });
                                          } catch (e) {
                                            setState(() {
                                              isLoading =
                                                  false; // Ocultar el indicador de progreso en caso de error
                                            });
                                            print('Error: $e');
                                            return;
                                          }
                                        }
                                      },
                                child: Row(
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.bullhorn,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Reportar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  //Circular Progress Indicator dialog

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      final Placemark place = placemarks[0];
      // print(place);
      setState(() {
        currentPosition = position;
        name = place.street ?? '';
        ciudad = place.subAdministrativeArea ?? '';
      });
    } catch (e) {
      // Manejo de errores
    }
  }

  openImages() async {
    try {
      var pickedFiles = await ImagePicker().pickMultiImage();

      if (pickedFiles != null) {
        if (pickedFiles.length <= 3) {
          imagefiles = pickedFiles;
          imagePaths = pickedFiles.map((e) => e.path).toList();
        } else {
          if (Platform.isIOS) {
            // ignore: use_build_context_synchronously
            showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: const Text('Máximo 3 fotos'),
                  content: const Text(
                    'Por favor, seleccione máximo 3 fotos para su reporte.',
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text(
                        'Aceptar',
                        style: TextStyle(color: CupertinoColors.activeBlue),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            // ignore: use_build_context_synchronously
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Máximo 3 fotos'),
                  content: const Text(
                    'Por favor, seleccione máximo 3 fotos para su reporte.',
                  ),
                  actions: [
                    TextButton(
                      child: const Text(
                        'Aceptar',
                        style: TextStyle(color: Color(0xFF6165FA)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        }

        setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("Error while picking file.");
    }
  }
}
