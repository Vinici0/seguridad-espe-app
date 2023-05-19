// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter_maps_adv/models/comentarios.dart';
import 'package:flutter_maps_adv/models/publicacion.dart';
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
  bool isLiked = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Publicacion> publicaciones = [
      Publicacion(
          titulo: 'Mascota perdida',
          contenido:
              'Por favor, ayude a encontrar a mi perro, se perdió en la calle 12 con 34. Llevo dias que no lo encuentro, por favor, si lo ve, llame al 123456789',
          usuario: 'Juan Perez',
          likes: 8,
          ciudad: 'Bogotá',
          sector: 'Chapinero',
          latitud: -0.412703,
          longitud: -79.309187,
          img: [
            'assets/perroPerdido.jpg',
            'assets/perroPerdido.jpg',
          ],
          comentarios: [
            Comentarios(
              nombre: 'Juan Perez',
              comentario: 'Que triste, espero que lo encuentres pronto1',
              fecha: '2023-04-13T08:35:11.826+00:00',
              hora: '12:00',
              id: '1',
              id_publicacion: '1',
              id_usuario: '1',
              likes: 7,
            ),
            Comentarios(
              nombre: 'Pedro Ramirez',
              comentario: 'Que triste, espero que lo encuentres pronto2',
              fecha: '2023-04-13T08:35:11.826+00:00',
              hora: '12:00',
              id: '2',
              id_publicacion: '1',
              id_usuario: '1',
              likes: 5,
            ),
            Comentarios(
              nombre: 'Juan Perez',
              comentario: 'Que triste, espero que lo encuentres pronto1',
              fecha: '2023-04-13T08:35:11.826+00:00',
              hora: '12:00',
              id: '1',
              id_publicacion: '1',
              id_usuario: '1',
              likes: 7,
            ),
            Comentarios(
              nombre: 'Pedro Ramirez',
              comentario: 'Que triste, espero que lo encuentres pronto2',
              fecha: '2023-04-13T08:35:11.826+00:00',
              hora: '12:00',
              id: '2',
              id_publicacion: '1',
              id_usuario: '1',
              likes: 5,
            ),
            Comentarios(
              nombre: 'Juan Perez',
              comentario: 'Que triste, espero que lo encuentres pronto3',
              fecha: '2023-04-13T08:35:11.826+00:00',
              hora: '12:00',
              id: '3',
              id_publicacion: '1',
              id_usuario: '1',
              likes: 0,
            ),
            Comentarios(
              nombre: 'Pedro Ramirez',
              comentario: 'Que triste, espero que lo encuentres pronto4',
              fecha: '2023-04-13T08:35:11.826+00:00',
              hora: '12:00',
              id: '4',
              id_publicacion: '1',
              id_usuario: '1',
              likes: 5,
            ),
            Comentarios(
              nombre: 'Juan Perez',
              comentario: 'Que triste, espero que lo encuentres pronto5',
              fecha: '2023-04-13T08:35:11.826+00:00',
              hora: '12:00',
              id: '5',
              id_publicacion: '1',
              id_usuario: '1',
              likes: 0,
            ),
          ],
          fecha: '2023-04-13T08:35:11.826+00:00'),
      Publicacion(
          titulo: 'Mascota perdida',
          contenido:
              'Por favor, ayude a encontrar a mi perro, se perdió en la calle 12 con 34. Llevo dias que no lo encuentro, por favor, si lo ve, llame al 123456789',
          usuario: 'Juan Perez',
          likes: 8,
          ciudad: 'Bogotá',
          sector: 'Chapinero',
          latitud: -0.412703,
          longitud: -79.309187,
          img: [
            'assets/perroPerdido.jpg',
            'assets/perroPerdido.jpg',
          ],
          comentarios: [
            Comentarios(
              nombre: 'Juan Perez',
              comentario: 'Que triste, espero que lo encuentres pronto1',
              fecha: '2023-04-13T08:35:11.826+00:00',
              hora: '12:00',
              id: '1',
              id_publicacion: '1',
              id_usuario: '1',
              likes: 7,
            ),
            Comentarios(
              nombre: 'Pedro Ramirez',
              comentario: 'Que triste, espero que lo encuentres pronto2',
              fecha: '2023-04-13T08:35:11.826+00:00',
              hora: '12:00',
              id: '2',
              id_publicacion: '1',
              id_usuario: '1',
              likes: 0,
            ),
            Comentarios(
              nombre: 'Juan Perez',
              comentario: 'Que triste, espero que lo encuentres pronto3',
              fecha: '2023-04-13T08:35:11.826+00:00',
              hora: '12:00',
              id: '3',
              id_publicacion: '1',
              id_usuario: '1',
              likes: 0,
            ),
          ],
          fecha: '2023-04-13T08:35:11.826+00:00'),
      Publicacion(
          titulo: 'Mascota perdida',
          likes: 5,
          ciudad: 'Bogotá',
          sector: 'Chapinero',
          latitud: -0.412703,
          longitud: -79.309187,
          contenido:
              'Por favor, ayude a encontrar a mi perro, se perdió en la calle 12 con 34. Llevo dias que no lo encuentro, por favor, si lo ve, llame al 123456789',
          usuario: 'Juan Perez',
          comentarios: [
            Comentarios(
              nombre: 'Juan Perez',
              comentario: 'Que triste, espero que lo encuentres pronto1',
              fecha: '2023-04-13T08:35:11.826+00:00',
              hora: '12:00',
              id: '1',
              id_publicacion: '1',
              id_usuario: '1',
              likes: 1,
            ),
            Comentarios(
              nombre: 'Pedro Ramirez',
              comentario:
                  'Que triste, espero que lo encuentres pronto2 dsfsdf\n adadiaidnwianoinaoindaindaiowndnfuiafubauifb',
              fecha: '2023-04-13T08:35:11.826+00:00',
              hora: '12:00',
              id: '2',
              id_publicacion: '1',
              id_usuario: '1',
              likes: 7,
            ),
            Comentarios(
              nombre: 'Juan Perez',
              comentario: 'Que triste, espero que lo encuentres pronto3',
              fecha: '2023-04-13T08:35:11.826+00:00',
              hora: '12:00',
              id: '3',
              id_publicacion: '1',
              id_usuario: '1',
              likes: 0,
            ),
          ],
          fecha: '2023-04-13T08:35:11.826+00:00'),
    ];

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
        itemCount: publicaciones.length,
        itemBuilder: (context, i) => Card(
          child: Column(
            children: [
              GestureDetector(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/perroPerdido.jpg'),
                  ),
                  title: Text(publicaciones[i].titulo),
                  subtitle: Text(publicaciones[i].usuario),
                ),
                onTap: () {
                  Navigator.pushNamed(context, DetalleScreen.detalleroute,
                      arguments: publicaciones[i]);
                },
              ),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(publicaciones[i].contenido),
                ),
                onTap: () {
                  Navigator.pushNamed(context, DetalleScreen.detalleroute,
                      arguments: publicaciones[i]);
                },
              ),
              publicaciones[i].img != null
                  ? GestureDetector(
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        child: Image.asset(
                          publicaciones[i].img![0],
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, DetalleScreen.detalleroute,
                            arguments: publicaciones[i]);
                      },
                    )
                  : Container(),
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
                        Navigator.pushNamed(context, DetalleScreen.detalleroute,
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
            ],
          ),
        ),
      ),
    );
  }
}
