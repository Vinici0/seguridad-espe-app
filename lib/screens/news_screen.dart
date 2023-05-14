// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter_maps_adv/screens/news_detalle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewsScreen extends StatefulWidget {
  static const String newsroute = 'news';

  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  bool isLiked = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Noticias',
            style: TextStyle(color: Colors.black, fontSize: 20)),
        // backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, i) => Card(
          margin: const EdgeInsets.all(10.0),
          elevation: 0,
          // color: Colors.red,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                child: Container(
                  // alinea que quede en la parte superior centrado
                  alignment: Alignment.center,
                  // color: Colors.yellow,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.warning),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  // color: Colors.red,
                  child: Column(
                    children: [
                      Container(
                        // color: Colors.blue,
                        // height: size.height * 0.08,
                        //titulo, descripcion y que se ajuste al ancho
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  //hora
                                  Text(
                                    'Titulo de la noticia',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),

                                  const Spacer(),
                                  Text(
                                    '12:00',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              //descripcion
                              Text(
                                'Descripcion de la noticia',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, DetalleScreen.detalleroute);
                        },

                        //Dentro de aqui
                        child: Container(
                          height: size.height *
                              0.32, // Definimos una altura proporcional
                          // color: Colors.green,
                          width: double.infinity,
                          //padin a la derecha
                          padding: const EdgeInsets.only(right: 10),
                          //Image 'assets/no-image.png'
                          child: SvgPicture.asset(
                            'assets/accidente.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                          height: 50,
                          // color: Colors.green,
                          child: Row(
                            //agrega el icono de corazon y cantidad de likes y de comentarios y de compartir
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: GestureDetector(
                                  onTap: toggleLike,
                                  child: Icon(
                                      isLiked
                                          ? FontAwesomeIcons.solidHeart
                                          : FontAwesomeIcons.heart,
                                      color: isLiked
                                          ? Colors.red
                                          : Colors.grey.shade400,
                                      size: 12),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 5.0, right: 25.0),
                                child: Text(
                                  '10',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 25.0),
                                  child: Icon(
                                    FontAwesomeIcons.comment,
                                    color: Colors.grey,
                                    size: 12,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(left: 5.0, right: 25),
                                child: Text(
                                  '10',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 25.0),
                                child: Icon(
                                  FontAwesomeIcons.shareFromSquare,
                                  color: Colors.grey,
                                  size: 12,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Text(
                                  'Compartir',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
