// ignore_for_file: prefer_const_constructors

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/comentarios.dart';
import 'package:flutter_maps_adv/models/publicacion.dart';
import 'package:flutter_maps_adv/resources/services/publicacion.dart';
import 'package:flutter_maps_adv/screens/news_detalle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class NewsScreen extends StatefulWidget {
  static const String newsroute = 'news';

  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool isLiked = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final publicaciones =
        BlocProvider.of<PublicacionService>(context).publicaciones;
    final size = MediaQuery.of(context).size;
    String city = '';
    String sector = '';
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Tendencias',
            style: TextStyle(color: Colors.black, fontSize: 20)),
        // backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: publicaciones.length,
        itemBuilder: (context, i) => Card(
          //quitar margenes y sombra
          margin: EdgeInsets.all(0),
          elevation: 0,
          //ubicar una linea en la parte inferior de cada card
          shape: Border(
            bottom:
                BorderSide(color: Color.fromARGB(255, 228, 223, 223), width: 1),
          ),
          child: Column(
            children: [
              GestureDetector(
                //quitar retrazo al hacer click
                behavior: HitTestBehavior
                    .translucent, //sirve para que el GestureDetector funcione en cualquier parte del widget y no solo en el texto

                child: ListTile(
                  // dense: true,
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  leading: CircleAvatar(
                    backgroundColor: Color(int.parse(
                        "0xFF" + publicaciones[i].color)), //Color(0xffFDCF09
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgPicture.asset(
                        'assets/alertas/${publicaciones[i].imgAlerta}',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(publicaciones[i].titulo),
                  subtitle: Text(publicaciones[i].usuario),
                ),
                onTap: () {
                  Navigator.pushNamed(context, DetalleScreen.detalleroute,
                      arguments: publicaciones[i]);
                },
              ),
              Container(
                padding: EdgeInsets.only(left: 75, right: 10),
                child: Column(children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      //alinear a la izquierda
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(publicaciones[i].contenido),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, DetalleScreen.detalleroute,
                          arguments: publicaciones[i]);
                    },
                  ),

                  publicaciones[i].archivo != null &&
                          publicaciones[i].archivo!.isNotEmpty
                      ? GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              // Otros estilos de decoración
                            ),
                            width: double.infinity,
                            height: size.height * 0.35,
                            child: Image.network(
                              Environment.apiUrl +
                                  "/uploads/publicaciones/" +
                                  publicaciones[i].uid! +
                                  "?imagenIndex=" +
                                  publicaciones[i].archivo!.first,
                              fit: BoxFit.cover,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              DetalleScreen.detalleroute,
                              arguments: publicaciones[i],
                            );
                          },
                        )
                      : Container(),
                  //texto pegado a la izquierda
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //ciudad y sector

                        Text(publicaciones[i].ciudad +
                            ' - ' +
                            publicaciones[i].barrio),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 30.0,
                                  height: 35.0,
                                  //Elimina el margen del IconButton
                                  margin: EdgeInsets.zero,
                                  child: IconButton(
                                    onPressed: toggleLike,
                                    icon: Icon(
                                      isLiked
                                          ? FontAwesomeIcons.solidHeart
                                          : FontAwesomeIcons.heart,
                                      color: isLiked ? Colors.red : Colors.grey,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                Text(
                                  publicaciones[i].likes.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.zero,
                              child: Text(
                                'Me gusta',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                        //comentario y cantidad de comentarios
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.zero,
                                    width: 30.0,
                                    height: 35.0,
                                    child: Icon(
                                      FontAwesomeIcons.comment,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    '0',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.zero,
                                child: Text(
                                  'Comentarios',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                                context, DetalleScreen.detalleroute,
                                arguments: publicaciones[i]);
                          },
                        ),

                        //compartir
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.zero,
                                  width: 30.0,
                                  height: 35.0,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      FontAwesomeIcons.share,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.zero,
                              child: Text(
                                'Compartir',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
