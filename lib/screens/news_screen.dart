// ignore_for_file: prefer_const_constructors

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/publication.dart';
import 'package:flutter_maps_adv/screens/news_detalle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:uni_links/uni_links.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsScreen extends StatefulWidget {
  static const String newsroute = 'news';

  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late PublicationBloc _publicationBloc;

  @override
  void initState() {
    _publicationBloc = BlocProvider.of<PublicationBloc>(context);
    _publicationBloc.getAllPublicaciones();

    super.initState();
  }

  final ScrollController _firstController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final usuarioBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //color de la flecha de regreso
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: false,
        title: const Text('Tendencias',
            style: TextStyle(color: Colors.black, fontSize: 20)),
        // backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: BlocBuilder<PublicationBloc, PublicationState>(
        builder: (context, state) {
          final publicaciones =
              BlocProvider.of<PublicationBloc>(context).state.publicaciones;
          String city = '';
          String sector = '';
          return Scrollbar(
            thumbVisibility: true,
            controller: _firstController,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification) {}
                return false;
              },
              child: _ListNews(
                  publicaciones: publicaciones,
                  firstController: _firstController,
                  size: size,
                  publicationBloc: _publicationBloc,
                  usuarioBloc: usuarioBloc,
                  state: state),
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
    final publicationBloc = BlocProvider.of<PublicationBloc>(context);

    final localtionBloc = BlocProvider.of<LocationBloc>(context);
    return ListView.builder(
      itemCount: publicaciones.length,
      controller: _firstController,
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
              behavior: HitTestBehavior.translucent,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      //centrar de arriva a abajo
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: CircleAvatar(
                            backgroundColor: Color(int.parse(
                                "0xFF${publicaciones[i].color}")), //Color(0xffFDCF09
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SvgPicture.asset(
                                'assets/alertas/${publicaciones[i].imgAlerta}',
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
                              width: MediaQuery.of(context).size.width * 0.50,
                              child: Text(
                                publicaciones[i].titulo,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.50,
                              child: Text(
                                timeago.format(
                                  DateTime.parse(publicaciones[i].createdAt!),
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
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 62, right: 5),
                    child: Column(
                      children: [
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
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(9.0),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(9.0),
                                  ),
                                  child: Image.network(
                                    "${Environment.apiUrl}/uploads/publicaciones/${publicaciones[i].uid!}?imagenIndex=${publicaciones[i].imagenes!.first}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                // width: double.infinity,
                                height: size.height * 0.35,
                                decoration: BoxDecoration(
                                  color: Color(int.parse(
                                      '0xFF${publicaciones[i].color}')),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(9.0),
                                  ),
                                ),
                                child: SizedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(9.0),
                                    ),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.35,
                                      width: double.infinity,
                                      child: SvgPicture.asset(
                                        'assets/alertas/${publicaciones[i].imgAlerta}',
                                        color: Colors.white,
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                        //texto pegado a la izquierda
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.only(top: 10),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              publicationBloc.add(
                                  PublicacionSelectEvent(publicaciones[i]));
                              Navigator.pushNamed(
                                  context, DetalleScreen.detalleroute,
                                  arguments: {
                                    'publicacion': publicaciones[i],
                                    'likes': publicaciones[i]
                                        .likes!
                                        .length
                                        .toString(),
                                  });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                //ciudad y sector

                                Text(
                                    '${publicaciones[i].ciudad} - ${publicaciones[i].barrio}'),
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
                publicationBloc.add(PublicacionSelectEvent(publicaciones[i]));

                Navigator.pushNamed(context, DetalleScreen.detalleroute,
                    arguments: {
                      'publicacion': publicaciones[i],
                      'likes': publicaciones[i].likes!.length.toString(),
                    });
              },
            ),
            _OptionNews(
                publicationBloc: _publicationBloc,
                publicaciones: publicaciones,
                state: state,
                usuarioBloc: usuarioBloc,
                i: i),
          ],
        ),
      ),
    );
  }
}

class _OptionNews extends StatelessWidget {
  const _OptionNews({
    super.key,
    required PublicationBloc publicationBloc,
    required this.publicaciones,
    required this.state,
    required this.usuarioBloc,
    required this.i,
  }) : _publicationBloc = publicationBloc;

  final PublicationBloc _publicationBloc;
  final List<Publicacion> publicaciones;
  final PublicationState state;
  final AuthBloc usuarioBloc;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            try {
              await _publicationBloc.publicacionesUpdate(publicaciones[i].uid!);
            } catch (e) {
              print(e);
            }
          },
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 30.0,
                    height: 35.0,

                    ///margin de la izquierda
                    margin: EdgeInsets.only(left: 28),
                    child: state.publicaciones[i].likes
                                ?.contains(usuarioBloc.state.usuario!.uid) ==
                            true
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 18.5,
                          )
                        : Icon(
                            Icons.favorite_border,
                            color: Colors.grey,
                            size: 18.5,
                          ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    publicaciones[i].likes!.length.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                      size: 16,
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
            ],
          ),
          onTap: () {
            Navigator.pushNamed(context, DetalleScreen.detalleroute,
                arguments: {
                  'publicacion': publicaciones[i],
                  'likes': publicaciones[i].likes!.length.toString(),
                });
          },
        ),

        //compartir
        Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                // await Share.share('Confirme');
              },
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.zero,
                    width: 30.0,
                    height: 35.0,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.share_outlined,
                        color: Colors.grey,
                        size: 18,
                      ),
                    ),
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
            ),
          ],
        ),
      ],
    );
  }
}
