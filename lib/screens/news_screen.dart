// ignore_for_file: prefer_const_constructors

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/blocs/publication/publication_bloc.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/screens/news_detalle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
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
    _publicationBloc.add(PublicacionesInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final usuarioBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      appBar: AppBar(
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
          return Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: publicaciones.length,
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
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          //centrar de arriva a abajo
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: CircleAvatar(
                                backgroundColor: Color(int.parse("0xFF" +
                                    publicaciones[i].color)), //Color(0xffFDCF09
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
                            Container(
                              child: Text(
                                publicaciones[i].titulo,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
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
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, DetalleScreen.detalleroute,
                            arguments: publicaciones[i]);
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 75, right: 5),
                      child: Column(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              //alinear a la izquierda
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(bottom: 3),
                              child: Text(publicaciones[i].contenido),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, DetalleScreen.detalleroute,
                                  arguments: publicaciones[i]);
                            },
                          ),

                          publicaciones[i].archivo != null &&
                                  publicaciones[i].archivo!.isNotEmpty
                              ? GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: Container(
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
                                        Environment.apiUrl +
                                            "/uploads/publicaciones/" +
                                            publicaciones[i].uid! +
                                            "?imagenIndex=" +
                                            publicaciones[i].archivo!.first,
                                        fit: BoxFit.cover,
                                      ),
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
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    _publicationBloc.add(PublicacionesUpdate(
                                        publicaciones[i].uid!));
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 30.0,
                                            height: 35.0,
                                            //Elimina el margen del IconButton
                                            margin: EdgeInsets.zero,
                                            child: state.publicaciones[i].likes
                                                        ?.contains(usuarioBloc
                                                            .state
                                                            .usuario!
                                                            .uid) ==
                                                    true
                                                ? Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                  )
                                                : Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.grey,
                                                  ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            publicaciones[i]
                                                .likes!
                                                .length
                                                .toString(),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
