import 'dart:io';

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

class AlertScreen extends StatefulWidget {
  static const String routeName = 'reporte';

  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  Position? currentPosition;
  String name = '';
  String ciudad = '';
  final _textController = TextEditingController();
  final ImagePicker imgpicker = ImagePicker();
  List<String>? imagePaths;
  List<XFile>? imagefiles;
  bool isPressed = false;
  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final Reporte reporte =
        ModalRoute.of(context)!.settings.arguments as Reporte;
    final size = MediaQuery.of(context).size;
    final publicaciones = BlocProvider.of<PublicationBloc>(context);
    final authService = BlocProvider.of<AuthBloc>(context, listen: false);
    Color buttonColor = isPressed ? Colors.blue : Colors.grey;
    String tooltipText =
        isPressed ? 'Inconicto activado' : 'Inconicto desactivado';

    /*
      
      final position = await Geolocator.getCurrentPosition();
    */

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF111b21),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(int.parse('0xFF${reporte.color}')),
              child: SvgPicture.asset(
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
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    color: const Color(0xFF111b21),
                    child: TextField(
                      controller:
                          _textController, //sirve para limpiar el texto del textfield cuando se envia el mensaje
                      style: const TextStyle(color: Colors.white, fontSize: 20),
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
                        // Container(
                        //   margin: EdgeInsets.only(left: 15),
                        //   alignment: Alignment.center,
                        //   // width: MediaQuery.of(context).size.width * 0.1,
                        //   height: 35,
                        //   decoration: BoxDecoration(
                        //     color: Color.fromARGB(255, 49, 67, 78),
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   child: IconButton(
                        //     alignment: Alignment.center,
                        //     icon: Icon(
                        //       FontAwesomeIcons.camera,
                        //       color: Colors.white,
                        //       size: 18,
                        //     ),
                        //     onPressed: () async {
                        //       final XFile? image = await imgpicker.pickImage(
                        //           source: ImageSource.camera);
                        //       if (image != null) {
                        //         setState(() {
                        //           imagefiles = [image];
                        //         });
                        //       }
                        //       // openImages();
                        //     },
                        //   ),
                        // ),
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
                                margin:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  children: [
                                    Container(
                                        // color: Color.fromARGB(255, 49, 67, 78),
                                        padding: const EdgeInsets.all(5),
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                        ),
                                        decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 49, 67, 78),
                                          borderRadius: BorderRadius.only(
                                              //bordes redondeados
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                        )),
                                    //icono con texto de ubicacion
                                    Container(
                                      // color: Color.fromARGB(255, 0, 93, 164),
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      padding: const EdgeInsets.only(left: 5),
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
                      ? Container(
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
                                margin: EdgeInsets.all(5),
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
                      : Container(),

                  const Divider(
                    color: Colors.white,
                  ),
                  //repotar o reportar incognito el incidente
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          // Acción de la galería
                        },
                        child: Tooltip(
                          message: tooltipText,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: buttonColor,
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
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFF6165FA),
                        ),
                        child: MaterialButton(
                          onPressed: () async {
                            if (_textController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Campo vacío'),
                                    content:
                                        Text('Por favor, escriba qué sucedió.'),
                                    actions: [
                                      TextButton(
                                        child: const Text(
                                          'Aceptar',
                                          style: TextStyle(
                                              color: Color(0xFF6165FA)),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              return;
                            }

                            publicaciones.add(PublicacionesCreateEvent(
                              reporte.tipo,
                              _textController.text,
                              reporte.color,
                              reporte.icon,
                              false,
                              true,
                              authService.state.usuario!.uid,
                              imagePaths,
                            ));

                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
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
      var pickedfiles = await imgpicker.pickMultiImage();
      if (pickedfiles != null) {
        imagefiles = pickedfiles;
        imagePaths = pickedfiles.map((e) => e.path).toList();
        setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }
}
