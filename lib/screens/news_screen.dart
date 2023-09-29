// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/publication.dart';
import 'package:flutter_maps_adv/screens/news_detalle.dart';
import 'package:flutter_maps_adv/widgets/option_publication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:uni_links/uni_links.dart';
import 'package:latlong2/latlong.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  static const String newsroute = 'news';
  final Function onNewPublication;

  const NewsScreen({Key? key, required this.onNewPublication})
      : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late PublicationBloc _publicationBloc;
  bool _isLoading = false;

  final ScrollController _firstController = ScrollController();
  @override
  void initState() {
    _publicationBloc = BlocProvider.of<PublicationBloc>(context);
    _firstController.addListener(() {
      if (!_isLoading &&
          _firstController.position.pixels >=
              _firstController.position.maxScrollExtent - 500) {
        _isLoading = true;
        _publicationBloc.getNextPublicaciones().then((_) {
          _isLoading = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final usuarioBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title: const Text(
          'Tendencias',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        elevation: 0.5,
      ),
      body: BlocBuilder<PublicationBloc, PublicationState>(
        builder: (context, state) {
          if (state.firstController == true) {
            _firstController.animateTo(
              0.0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
          }

          //si no hay publicaciones muestra un mensaje
          if (state.publicaciones.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/alertaIcon.png',
                    width: size.width * 0.5,
                  ),
                  Text(
                    'No hay publicaciones',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await _publicationBloc.getAllPublicaciones();
            },
            color: Color(0xFF7ab466),
            child: Stack(
              children: [
                //Si no hay publicaciones muestra un mensaje

                Scrollbar(
                  thumbVisibility: true,
                  controller: _firstController,
                  child: _ListNews(
                      publicaciones: state.publicaciones,
                      firstController: _firstController,
                      size: size,
                      publicationBloc: _publicationBloc,
                      usuarioBloc: usuarioBloc,
                      state: state),
                ),
                Positioned(
                  top: size.height * 0.3 -
                      (size.height * 0.57 / 2), // Centrar verticalmente
                  left: size.width / 2 - 112.5, // Centrar horizontalmente
                  child: AnimatedOpacity(
                    opacity: state.showNewPostsButton ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: 225,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7ab466),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          await _publicationBloc.getAllPublicaciones();

                          _publicationBloc
                              .add(const ShowNewPostsButtonEvent(false));
                          _publicationBloc.add(const GoToStartListEvent(true));
                          // Aquí puedes realizar la acción para cargar nuevos posts
                          // y luego llamar setState para mostrar nuevamente el botón
                          // cuando haya nuevos posts disponibles.
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Icono de la flecha hacia arriba
                            Container(
                              margin: EdgeInsets.only(left: 2),
                              child: Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            // Agrega la imagen de comunicar que está en el assets .png
                            Container(
                              margin: EdgeInsets.only(left: 2),
                              child: Image.asset(
                                'assets/alertas/newPost.png',
                                width: 40,
                              ),
                            ),
                            Center(
                              child: Text(
                                'Ver posts nuevos',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ListNews extends StatelessWidget {
  const _ListNews({
    super.key,
    required this.publicaciones,
    required ScrollController firstController,
    required this.size,
    required PublicationBloc publicationBloc,
    required this.usuarioBloc,
    required this.state,
  })  : _firstController = firstController,
        _publicationBloc = publicationBloc;

  final List<Publicacion> publicaciones;
  final ScrollController _firstController;
  final Size size;
  final PublicationBloc _publicationBloc;
  final AuthBloc usuarioBloc;
  final PublicationState state;

  @override
  Widget build(BuildContext context) {
    final circleMarkers = <CircleMarker>[
      CircleMarker(
          point: LatLng(publicaciones[0].latitud, publicaciones[0].longitud),
          color: const Color(0xFF7ab466).withOpacity(0.3),
          borderStrokeWidth: 2,
          borderColor: const Color(0xFF7ab466),
          useRadiusInMeter: true,
          radius: 2000 // 2000 meters | 2 km
          ),
    ];
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: publicaciones.length,
            controller: _firstController,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, i) => Card(
              //quitar margenes y sombra
              margin: EdgeInsets.all(0),
              elevation: 0,
              //ubicar una linea en la parte inferior de cada card
              shape: Border(
                bottom: BorderSide(
                    color: Color.fromARGB(255, 228, 223, 223), width: 1),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: [
                              Row(
                                //centrar de arriva a abajo
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: CircleAvatar(
                                      backgroundColor: Color(int.parse(
                                          "0xFF${publicaciones[i].color}")), //Color(0xffFDCF09
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),

                                        //si ternmina despues del punto en .png muestra la imagen
                                        child: publicaciones[i]
                                                .imgAlerta
                                                .endsWith('.png')
                                            ? Image.asset(
                                                'assets/alertas/${publicaciones[i].imgAlerta}',
                                                // ignore: deprecated_member_use
                                                color: Colors.white,
                                              )
                                            : SvgPicture.asset(
                                                'assets/iconvinculacion/${publicaciones[i].imgAlerta}',
                                                // ignore: deprecated_member_use
                                                color: Colors.white,
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.50,
                                        child: Text(
                                          publicaciones[i].titulo,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.50,
                                        child: Text(
                                          timeago.format(
                                            DateTime.parse(
                                                publicaciones[i].createdAt!),
                                            locale:
                                                'es', // Opcional: establece el idioma en español
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 62, right: 5),
                          child: Column(
                            children: [
                              //TODO UBICAR FOTO
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(bottom: 3),
                                child: Text(publicaciones[i].contenido),
                              ),

                              publicaciones[i].imagenes != null &&
                                      publicaciones[i].imagenes!.isNotEmpty
                                  ? Container(
                                      width: double.infinity,
                                      height: size.height * 0.35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9.0),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9.0),
                                        ),
                                        child: _buildCachedImage(
                                          "${Environment.apiUrl}/uploads/publicaciones/${publicaciones[i].uid!}?imagenIndex=${publicaciones[i].imagenes!.first}",
                                          double.infinity,
                                          size.height * 0.35,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              // : Container(
                              //     width: double.infinity,
                              //     height: size.height * 0.35,
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(9.0),
                              //       ),
                              //     ),
                              //     child: ClipRRect(
                              //       borderRadius: BorderRadius.circular(
                              //           16.0), // Misma cantidad que en el BoxDecoration
                              //       child: FlutterMap(
                              //         options: MapOptions(
                              //           center: LatLng(
                              //               publicaciones[i].latitud,
                              //               publicaciones[i].longitud),
                              //           zoom:
                              //               10.0, // Reducir el nivel de zoom inicial
                              //           maxZoom:
                              //               18, // Limitar el zoom máximo
                              //           interactiveFlags:
                              //               InteractiveFlag.none,
                              //         ),
                              //         children: [
                              //           TileLayer(
                              //             // Usar teselas de Stamen Toner con resolución más baja
                              //             urlTemplate:
                              //                 'https://stamen-tiles-{s}.a.ssl.fastly.net/toner-lite/{z}/{x}/{y}.png',
                              //             subdomains: ['a', 'b', 'c', 'd'],
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),

                              //texto pegado a la izquierda
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.only(top: 10),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    _publicationBloc.add(PublicacionSelectEvent(
                                        publicaciones[i]));

                                    Navigator.of(context)
                                        .push(_createRoute(publicaciones[i]));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        '${publicaciones[i].ciudad} - ${publicaciones[i].barrio}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      _publicationBloc
                          .add(PublicacionSelectEvent(publicaciones[i]));

                      Navigator.of(context)
                          .push(_createRoute(publicaciones[i]));
                    },
                  ),
                  OptionNews(
                      publicaciones: publicaciones,
                      state: state,
                      usuarioBloc: usuarioBloc,
                      i: i,
                      likes: publicaciones[i].likes!),
                ],
              ),
            ),
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 1,
              );
            },
          ),
        ),
        if (state.isLoading)
          const LinearProgressIndicator(
            backgroundColor: Color(0xFF7ab466),
          ),
      ],
    );
  }

  Widget _buildCachedImage(String imageUrl, double width, double height) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Image.asset(
          'assets/jar-loading.gif'), // Placeholder mientras se carga la imagen
      errorWidget: (context, url, error) =>
          Icon(Icons.error), // Widget en caso de error de carga
      width: width,
      height: height,
      fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor
    );
  }
}

Route _createRoute(Publicacion publicacion) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => DetalleScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
