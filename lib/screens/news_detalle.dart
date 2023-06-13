import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/search/search_bloc.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/helpers/navegacion.dart';
import 'package:flutter_maps_adv/models/publication.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_maps_adv/widgets/comments.dart';
import 'package:flutter_maps_adv/widgets/comment_pulbicacion.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class DetalleScreen extends StatefulWidget {
  static const String detalleroute = 'detalle';
  const DetalleScreen({Key? key}) : super(key: key);

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  List<CommentPublication> _comentarios = [
    CommentPublication(
      comentario:
          'lore ipsum dolor sit amet consectetur adipiscing elit a mi awddad qdwdad e ipsum dolor sit amet consectetur adipiscing elit a mi awddad qdwdad',
      nombre: 'Juan',
      fotoPerfil: 'assets/images/usuario.png',
      fecha: '2021-09-10 10:00:00',
      likes: 10,
      totalComentarios: 2,
      uid: 'ad',
    ),
    CommentPublication(
      comentario:
          'lore ipsum dolor sit amet consectetur adipiscing elit a mi awddad qdwdad e ipsum dolor sit amet consectetur adipiscing elit a mi awddad qdwdad',
      nombre: 'Juan',
      fotoPerfil: 'assets/images/usuario.png',
      fecha: '2021-09-10 10:00:00',
      likes: 10,
      totalComentarios: 2,
      uid: 'ad',
    ),
    CommentPublication(
      comentario:
          'lore ipsum dolor sit amet consectetur adipiscing elit a mi awddad qdwdad e ipsum dolor sit amet consectetur adipiscing elit a mi awddad qdwdad',
      nombre: 'Juan',
      fotoPerfil: 'assets/images/usuario.png',
      fecha: '2021-09-10 10:00:00',
      likes: 10,
      totalComentarios: 2,
      uid: 'ad',
    ),
    CommentPublication(
      comentario:
          'lore ipsum dolor sit amet consectetur adipiscing elit a mi awddad qdwdad e ipsum dolor sit amet consectetur adipiscing elit a mi awddad qdwdad',
      nombre: 'Juan',
      fotoPerfil: 'assets/images/usuario.png',
      fecha: '2021-09-10 10:00:00',
      likes: 10,
      totalComentarios: 2,
      uid: 'ad',
    ),
  ];
  AuthBloc authService = AuthBloc();
  final _textController = new TextEditingController();
  bool _estaEscribiendo = false;

  @override
  void initState() {
    this.authService = BlocProvider.of<AuthBloc>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> mapNews =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final publicacion = mapNews['publicacion'] as Publicacion;
    final likes = mapNews['likes'] as String;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  _CustonAppBarDetalle(publicacion: publicacion),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _UbicacionDetalle(publicacion: publicacion),
                      _DescripcionDetalle(publicacion: publicacion),
                      const Divider(),
                      LikesCommentsDetails(
                          publicacion: publicacion, likes: likes),
                      const Divider(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: _comentarios.length,
                        itemBuilder: (_, i) => _comentarios[i],
                        reverse: true,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 80,
                      ),
                    ]),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _inputComentario(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputComentario() {
    final Map<String, dynamic> mapNews =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final publicacion = mapNews['publicacion'] as Publicacion;
    return Opacity(
      opacity: 1,
      child: Container(
        height: 50,
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmit,
                  onChanged: (comentario) {
                    setState(() {
                      if (comentario.length > 0) {
                        _estaEscribiendo = true;
                      } else {
                        _estaEscribiendo = false;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Escribe un comentario',
                    filled: true,
                    fillColor: Colors.white30,
                    contentPadding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  maxLines: null, // Permite múltiples líneas de texto
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconTheme(
                data: IconThemeData(
                    color: Color(int.parse('0xFF${publicacion.color}'))),
                child: IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: _estaEscribiendo
                      ? () => _handleSubmit(_textController.text.trim())
                      : null,
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit(String comentario) {
    if (comentario.length == 0) return;
    _textController.clear();
    final newComment = CommentPublication(
      comentario: comentario,
      nombre: authService.state.usuario!.nombre,
      fotoPerfil: 'da',
      fecha: '2021-10-10',
      likes: 0,
      totalComentarios: 0,
      uid: authService.state.usuario!.uid,
    );

    _comentarios.insert(0, newComment);
    _estaEscribiendo = false;
    setState(() {});
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
    final Map<String, dynamic> mapNews =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final publicacion = mapNews['publicacion'] as Publicacion;
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
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
                        DateFormat('HH:mm').format(DateTime.parse(
                            widget.publicacion.createdAt.toString())),
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
                  Text(
                    barrio,
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  Text(
                    ciudad,
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ],
              ),
            ),
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
                    FontAwesomeIcons.mapLocationDot,
                    size: 20,
                    color: Color(int.parse('0xFF${publicacion.color}')),
                  ),
                  const Text(
                    'Ver pin',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ],
              ),
            ),
            onTap: () async {
              final start = locationBloc.state.lastKnownLocation;
              if (start == null) return;
              end = LatLng(publicacion.latitud, publicacion.longitud);
              if (end == null) return;
              final destination =
                  await searchBloc.getCoorsStartToEnd(start, end!);
              await mapBloc.drawRoutePolyline(destination);
              Navigator.pop(context);
              counterBloc.cambiarIndex(0);
            },
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
  const _CustonAppBarDetalle({Key? key, required this.publicacion});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (publicacion.archivo == null || publicacion.archivo!.isEmpty) {
      return SliverAppBar(
        elevation: 1,
        backgroundColor: Color(int.parse('0xFF${publicacion.color}')),
        floating: false,
        pinned: true,
      );
    }

    return SliverAppBar(
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
          itemCount: publicacion.archivo!.length,
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              "${Environment.apiUrl}/uploads/publicaciones/${publicacion.uid!}?imagenIndex=${publicacion.archivo![index]}",
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}

class _DescripcionDetalle extends StatelessWidget {
  const _DescripcionDetalle({super.key, required this.publicacion});

  final Publicacion publicacion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Text(
        publicacion.contenido,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
