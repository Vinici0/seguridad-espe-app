import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/helpers/show_loading_message.dart';
import 'package:flutter_maps_adv/models/publication.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_maps_adv/widgets/comments.dart';
import 'package:flutter_maps_adv/widgets/comment_pulbicacion.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetalleScreen extends StatefulWidget {
  static const String detalleroute = 'detalle';
  const DetalleScreen({Key? key}) : super(key: key);

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  PublicationBloc publicationBloc = PublicationBloc();
  bool _estaEscribiendo = false;
  AuthBloc authService = AuthBloc();

  final _textController = TextEditingController();

  @override
  void initState() {
    publicationBloc = BlocProvider.of<PublicationBloc>(context);

    if (publicationBloc.state.currentPublicacion != null &&
        publicationBloc.state.publicaciones.isNotEmpty) {
      final matchingPublication =
          publicationBloc.state.publicaciones.firstWhere(
        (element) =>
            element.uid == publicationBloc.state.currentPublicacion!.uid,
        orElse: () => publicationBloc.state.currentPublicacion!,
      );

      if (matchingPublication != null &&
          matchingPublication.comentarios != null) {
        final commentCount = matchingPublication.comentarios!.length;
        publicationBloc.add(CountCommentEvent(commentCount));
      } else {
        const commentCount =
            0; // Establecer un valor predeterminado para la cantidad de comentarios
        publicationBloc.add(const CountCommentEvent(commentCount));
      }
    }

    _caragrHistorial(publicationBloc.state.currentPublicacion!.uid!);
    authService = BlocProvider.of<AuthBloc>(context, listen: false);

    authService.socketService.socket.emit('join-room', {
      'codigo': publicationBloc.state.currentPublicacion!.uid!,
    });

    authService.socketService.socket
        .on('comentario-publicacion', _escucharComeentario);

    super.initState();
  }

  void _caragrHistorial(String uid) async {
    await publicationBloc
        .getAllComments(publicationBloc.state.currentPublicacion!.uid!);
    // final comments = publicationBloc.state.comentarios;
    // final comment = comments!.firstWhere((element) => element.uid == auth.uid);
    // final userLikes = comment.likes;
  }

  void _escucharComeentario(dynamic payload) {
    CommentPublication comment = CommentPublication(
      comentario: payload['mensaje'],
      nombre: payload['nombre'],
      createdAt: payload['createdAt'],
      uid: payload['uid'],
      isGoogle: payload['isGoogle'],
      fotoPerfil: payload['fotoPerfil'],
      uidUsuario: payload['uidUsuario'],
      likes: const [],
      isLiked: false,
    );

    final List<String> comentarios = [
      ...publicationBloc.state.currentPublicacion!.comentarios ?? [],
      comment.uid!
    ];
    publicationBloc.add(UpdatePublicationEvent(Publicacion(
      titulo: publicationBloc.state.currentPublicacion!.titulo,
      contenido: publicationBloc.state.currentPublicacion!.contenido,
      color: publicationBloc.state.currentPublicacion!.color,
      ciudad: publicationBloc.state.currentPublicacion!.ciudad,
      barrio: publicationBloc.state.currentPublicacion!.barrio,
      isPublic: publicationBloc.state.currentPublicacion!.isPublic,
      usuario: publicationBloc.state.currentPublicacion!.usuario,
      latitud: publicationBloc.state.currentPublicacion!.latitud,
      longitud: publicationBloc.state.currentPublicacion!.longitud,
      imgAlerta: publicationBloc.state.currentPublicacion!.imgAlerta,
      isLiked: publicationBloc.state.currentPublicacion!.isLiked,
      uid: publicationBloc.state.currentPublicacion!.uid,
      comentarios: comentarios,
      likes: publicationBloc.state.currentPublicacion!.likes,
      imagenes: publicationBloc.state.currentPublicacion!.imagenes,
      createdAt: publicationBloc.state.currentPublicacion!.createdAt,
      updatedAt: publicationBloc.state.currentPublicacion!.updatedAt,
      nombreUsuario: publicationBloc.state.currentPublicacion!.nombreUsuario,
    )));

    publicationBloc.add(CountCommentEvent(
        publicationBloc.state.conuntComentarios + 1)); //aumenta el contador

    publicationBloc.add(AddCommentPublicationEvent(comment));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<String>? likes = publicationBloc.state.currentPublicacion!.likes;
    final publicacion = publicationBloc.state.currentPublicacion;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  _CustonAppBarDetalle(publicacion: publicacion!),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _DescripcionDetalle(publicacion: publicacion),
                      _UbicacionDetalle(publicacion: publicacion),
                      const Divider(),
                      LikesCommentsDetails(
                          publicacion: publicacion, likes: likes!),
                      const Divider(),
                      const _ListComentario(),
                      const SizedBox(
                        height: 80,
                      ),
                    ]),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.white,
                  child: _inputComentario(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputComentario() {
    final publicationBloc = BlocProvider.of<PublicationBloc>(context);
    return Container(
      color: const Color.fromARGB(95, 162, 158, 158),
      child: Row(
        children: [
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: TextField(
                maxLength: 700,
                buildCounter: (BuildContext context,
                        {required int currentLength,
                        required bool isFocused,
                        required int? maxLength}) =>
                    null,
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (comentario) {
                  setState(() {
                    _estaEscribiendo = comentario.isNotEmpty;
                  });
                },

                decoration: InputDecoration(
                  hintText: 'Escribe un comentario',
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color(0xFF6165FA).withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 100, 100, 108),
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                maxLines: null, // <-- SEE HERE
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: _estaEscribiendo
                  ? () {
                      _handleSubmit(_textController.text.trim());
                      publicationBloc.add(CountCommentEvent(
                          publicationBloc.state.conuntComentarios + 1));
                    }
                  : null,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                width: 50,
                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _estaEscribiendo
                      ? const Color(0xFF6165FA)
                      : Colors.grey.withOpacity(0.3),
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _handleSubmit(String comentario) async {
    if (comentario.isEmpty) return;

    _textController.clear();
    final createdAt = DateTime.now();

    final resultadoComentario = await publicationBloc.createComentarioService(
        comentario, publicationBloc.state.currentPublicacion!.uid!);

    final newComment = CommentPublication(
      comentario: comentario,
      nombre: authService.state.usuario!.nombre,
      createdAt: createdAt.toString(),
      uid: resultadoComentario.uid,
      isGoogle: authService.state.usuario!.google,
      fotoPerfil: authService.state.usuario!.img == null
          ? null
          : authService.state.usuario!.img!,
      isLiked: false,
      uidUsuario: authService.state.usuario!.uid,
      likes: const [],
    );

    authService.socketService.socket.emit('comentario-publicacion', {
      'nombre': authService.state.usuario!.nombre,
      'mensaje': newComment.comentario,
      'fotoPerfil': authService.state.usuario!.uid,
      'createdAt': createdAt.toString(),
      'para': publicationBloc.state.currentPublicacion!.uid!,
      'de': authService.state.usuario!.uid,
      'isGoogle': authService.state.usuario!.google,
      'uid': resultadoComentario.uid,
    });

    publicationBloc.add(AddCommentPublicationEvent(newComment));

    final List<String> comentarios = [
      ...publicationBloc.state.currentPublicacion!.comentarios ?? [],
      newComment.uid!
    ]; //agrega el comentario a la lista de comentarios

    publicationBloc.add(UpdatePublicationEvent(Publicacion(
      titulo: publicationBloc.state.currentPublicacion!.titulo,
      contenido: publicationBloc.state.currentPublicacion!.contenido,
      color: publicationBloc.state.currentPublicacion!.color,
      ciudad: publicationBloc.state.currentPublicacion!.ciudad,
      barrio: publicationBloc.state.currentPublicacion!.barrio,
      isPublic: publicationBloc.state.currentPublicacion!.isPublic,
      usuario: publicationBloc.state.currentPublicacion!.usuario,
      latitud: publicationBloc.state.currentPublicacion!.latitud,
      longitud: publicationBloc.state.currentPublicacion!.longitud,
      imgAlerta: publicationBloc.state.currentPublicacion!.imgAlerta,
      isLiked: publicationBloc.state.currentPublicacion!.isLiked,
      uid: publicationBloc.state.currentPublicacion!.uid,
      comentarios: comentarios,
      likes: publicationBloc.state.currentPublicacion!.likes,
      imagenes: publicationBloc.state.currentPublicacion!.imagenes,
      createdAt: publicationBloc.state.currentPublicacion!.createdAt,
      updatedAt: publicationBloc.state.currentPublicacion!.updatedAt,
      nombreUsuario: publicationBloc.state.currentPublicacion!.nombreUsuario,
    )));

    publicationBloc.add(CountCommentEvent(
        publicationBloc.state.conuntComentarios + 1)); //aumenta el contador
    setState(() {
      _estaEscribiendo = false;
    });
  }

  @override
  void dispose() {
    publicationBloc.add(const GetAllCommentsEvent([]));
    authService.socketService.socket.off('comentario-publicacion');
    authService.socketService.socket.off('join-room');
    publicationBloc.add(const ResetCommentPublicationEvent());

    super.dispose();
  }
}

class _ListComentario extends StatelessWidget {
  const _ListComentario({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicationBloc, PublicationState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.comentariosP.isEmpty) {
          return const Center(
            child: Text('No hay comentarios'),
          );
        }

        final comentariosP = state.comentariosP;

        return ListView.builder(
          shrinkWrap: true,

          physics: const BouncingScrollPhysics(),
          itemCount: comentariosP.length,
          itemBuilder: (_, i) => comentariosP[i],
          // reverse: true,
        );
      },
    );
  }
}

class _UbicacionDetalle extends StatefulWidget {
  final Publicacion publicacion;

  const _UbicacionDetalle({Key? key, required this.publicacion})
      : super(key: key);

  @override
  State<_UbicacionDetalle> createState() => _UbicacionDetalleState();
}

class _UbicacionDetalleState extends State<_UbicacionDetalle> {
  String barrio = '';
  String locality = '';
  String ciudad = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final publicacion = widget.publicacion;
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final counterBloc = BlocProvider.of<NavigatorBloc>(context);
    final gpsBloc = BlocProvider.of<GpsBloc>(context);
    LatLng? end;
    return Container(
      //aagregar un margen en el contenedor
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      // color: Color(0xFF6165FA),
      child: Row(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black26,
                width: 1.0,
                //color de fondo del contenedor
              ),
            ),
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
              color: Color(int.parse('0xFF${publicacion.color}')),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //mes y dia con icno de reloj y la de publicacion
                  Text(
                    DateFormat('MMMM d').format(DateTime.parse(
                        widget.publicacion.createdAt.toString())),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.clock,
                          size: 20, color: Colors.white),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        //hora conn import 'timeago; HH:mm
                        timeago.format(
                            DateTime.parse(
                                widget.publicacion.createdAt.toString()),
                            locale: 'es_short'),
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 6.5),
              decoration: const BoxDecoration(),

              // color: Color.fromARGB(255, 252, 81, 81),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   barrio,
                  //   style: const TextStyle(color: Colors.black, fontSize: 12),
                  // ),
                  // Text(
                  //   ciudad,
                  //   style: const TextStyle(color: Colors.black, fontSize: 12),
                  // ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black26,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Icno que represente noticia finalizada ya atendida
                      Icon(
                        Icons.check_circle,
                        size: 20,
                        color: Color(int.parse('0xFF${publicacion.color}')),
                      ),
                      const Text(
                        'Atendida',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                onTap: () async {},
              ),
              GestureDetector(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black26,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        //mapa icono
                        // Icons.map_outlined,
                        FontAwesomeIcons.mapMarkedAlt,
                        size: 20,
                        color: Color(int.parse('0xFF${publicacion.color}')),
                      ),
                      const Text(
                        'Ver mapa',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  if (!gpsBloc.state.isGpsEnabled ||
                      !gpsBloc.state.isGpsPermissionGranted) {
                    Fluttertoast.showToast(
                        msg: 'Activa el GPS para ver la ubicación',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: const Color(0xff6165FA),
                        textColor: Colors.white,
                        fontSize: 16.0);
                    return;
                  }

                  final start = locationBloc.state.lastKnownLocation;
                  if (start == null) return;
                  end = LatLng(publicacion.latitud, publicacion.longitud);
                  if (end == null) return;
                  searchBloc.add(OnActivateManualMarkerEvent());
                  showLoadingMessage(context);
                  final destination =
                      await searchBloc.getCoorsStartToEnd(start, end!);
                  await mapBloc.drawRoutePolyline(destination);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  counterBloc.add(const NavigatorIndexEvent(index: 0));
                },
              ),
              GestureDetector(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black26,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        //denuncias icono
                        // FontAwesomeIcons.flag,
                        Icons.flag_rounded,
                        size: 25,
                        color: Color(int.parse('0xFF${publicacion.color}')),
                      ),
                      const Text(
                        'Denunciar',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  Navigator.pushNamed(context, 'denunciar');
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void _getCurrentLocation() async {
    final double lat = widget.publicacion.latitud;
    final double lon = widget.publicacion.longitud;
    final List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    // print(placemarks);
    if (placemarks.isNotEmpty) {
      final Placemark place = placemarks.first;
      barrio = place.locality ?? '';
      locality = place.subLocality ?? '';
      ciudad = place.administrativeArea ?? '';
    }

    setState(() {});
  }
}

// class from type SliverAppBar
class _CustonAppBarDetalle extends StatelessWidget {
  final Publicacion publicacion;
  const _CustonAppBarDetalle({required this.publicacion});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (publicacion.imagenes == null || publicacion.imagenes!.isEmpty) {
      return SliverAppBar(
        elevation: 1,
        backgroundColor: Color(int.parse('0xFF${publicacion.color}')),
        floating: false,
        pinned: true,
      );
    }

    return SliverAppBar(
      //color del appbar al regresar sobre negrea transparencia

      iconTheme: const IconThemeData(
        color: Colors.white,
        shadows: [
          Shadow(
            blurRadius: 18.0,
            color: Colors.black,
            offset: Offset(1.0, 1.0),
          ),
        ],
      ),
      elevation: 2,
      backgroundColor: Color(int.parse('0xFF${publicacion.color}')),
      expandedHeight: size.height * 0.40,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        title: Text(
          publicacion.titulo,
          style: const TextStyle(color: Colors.white),
        ),
        background: Swiper(
          pagination: const SwiperPagination(),
          itemCount: publicacion.imagenes!.length,
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              "${Environment.apiUrl}/uploads/publicaciones/${publicacion.uid!}?imagenIndex=${publicacion.imagenes![index]}",
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}

class _DescripcionDetalle extends StatefulWidget {
  const _DescripcionDetalle({required this.publicacion});

  final Publicacion publicacion;

  @override
  _DescripcionDetalleState createState() => _DescripcionDetalleState();
}

class _DescripcionDetalleState extends State<_DescripcionDetalle> {
  bool alertaAtendida = false;

  @override
  Widget build(BuildContext context) {
    final isAlertaAtendida = alertaAtendida;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // InkWell(
          //   //inkwell es para que se pueda hacer click en el texto y se pueda cambiar el estado
          //   onTap: () {
          //     setState(() {
          //       alertaAtendida = !alertaAtendida;
          //     });
          //   },
          //   borderRadius: BorderRadius.circular(5),
          //   child: Ink(
          //     decoration: BoxDecoration(
          //       color: isAlertaAtendida ? Colors.green[100] : Colors.red[100],
          //       borderRadius: BorderRadius.circular(5),
          //     ),
          //     padding: const EdgeInsets.all(10),
          //     child: Row(
          //       children: [
          //         Icon(
          //           isAlertaAtendida
          //               ? Icons.check_circle_outline
          //               : Icons.error_outline,
          //           size: 16,
          //           color: isAlertaAtendida ? Colors.green : Colors.red,
          //         ),
          //         const SizedBox(width: 5),
          //         Text(
          //           isAlertaAtendida
          //               ? 'Haz clic aquí si la alerta ha sido atendida'
          //               : 'Haz clic aquí si la alerta no ha sido atendida',
          //           style: TextStyle(
          //             color: isAlertaAtendida ? Colors.green : Colors.red,
          //             fontSize: 16,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //         const Spacer(),
          //       ],
          //     ),
          //   ),
          // ),
          const SizedBox(height: 10),
          Text(
            widget.publicacion.contenido,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
