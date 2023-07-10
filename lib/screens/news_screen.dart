// ignore_for_file: prefer_const_constructors

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/publication.dart';
import 'package:flutter_maps_adv/screens/news_detalle.dart';
import 'package:flutter_maps_adv/widgets/option_publication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:uni_links/uni_links.dart';
import 'package:timeago/timeago.dart' as timeago;

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
          return RefreshIndicator(
            onRefresh: () async {
              await _publicationBloc.getAllPublicaciones();
            },
            color: Color(0xFF6165FA),
            child: Scrollbar(
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
                                    width: MediaQuery.of(context).size.width *
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
                                    width: MediaQuery.of(context).size.width *
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
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
                                    _publicationBloc.add(PublicacionSelectEvent(
                                        publicaciones[i]));
                                    Navigator.pushNamed(
                                        context, DetalleScreen.detalleroute,
                                        arguments: {
                                          'publicacion': publicaciones[i],
                                        });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
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
                      _publicationBloc
                          .add(PublicacionSelectEvent(publicaciones[i]));

                      Navigator.pushNamed(context, DetalleScreen.detalleroute,
                          arguments: {
                            'publicacion': publicaciones[i],
                            'likes': publicaciones[i].likes!.length.toString(),
                          });
                    },
                  ),
                  OptionNews(
                      publicaciones: publicaciones,
                      state: state,
                      usuarioBloc: usuarioBloc,
                      i: i),
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
            backgroundColor: Color(0xFF6165FA),
          ),
      ],
    );
  }
}
