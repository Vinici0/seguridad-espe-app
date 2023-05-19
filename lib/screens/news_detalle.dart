import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/models/comentarios.dart';
import 'package:flutter_maps_adv/models/publicacion.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

class DetalleScreen extends StatefulWidget {
  static const String detalleroute = 'detalle';
  const DetalleScreen({Key? key}) : super(key: key);

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final Publicacion publicacion =
        ModalRoute.of(context)!.settings.arguments as Publicacion;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  _CustonAppBarDetalle(publicacion: publicacion),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Divider(),
                      _UbicacionDetalle(publicacion: publicacion),
                      Divider(),
                      _DescripcionDetalle(publicacion: publicacion),
                      Divider(),
                      _LikesComentariosDetalle(publicacion: publicacion),
                      Divider(),
                      _CargarComentariosUsuariosListReverse(),
                      Divider(),
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
    return Opacity(
      opacity: 1,
      child: Container(
        height: 50,
        color: Colors.white,
        child: Row(
          children: [
            // Icono de la cámara y de la galería
            IconButton(
              onPressed: () {},
              icon: Icon(
                FontAwesomeIcons.camera,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                FontAwesomeIcons.images,
                color: Colors.black,
              ),
            ),
            // Caja de texto
            Flexible(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Escribe un comentario',
                  filled: true,
                  fillColor: Colors.white30,
                  contentPadding: EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                maxLines: null, // Permite múltiples líneas de texto
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    final lat = position.latitude;
    final lon = position.longitude;
    final List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    print(placemarks);
    final Placemark place = placemarks[0];
    final String city = place.locality.toString();
    final String sector = place.subLocality.toString();
    print(city);
    print(sector);
  }
}

class _UbicacionDetalle extends StatelessWidget {
  final Publicacion publicacion;
  const _UbicacionDetalle({Key? key, required this.publicacion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //quita el margen de tood el contenedor
      margin: EdgeInsets.all(0),

      color: Color.fromARGB(255, 189, 135, 135),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Column(
          children: [
            Icon(
              Icons.location_on,
              color: Colors.white,
            ),
            //fecha
            Text(
              DateTime.parse(publicacion.fecha).day.toString() +
                  '/' +
                  DateTime.parse(publicacion.fecha).month.toString() +
                  '/' +
                  DateTime.parse(publicacion.fecha).year.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              publicacion.ciudad,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              publicacion.sector,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        Column(
          children: [
            Icon(
              Icons.star,
              color: Colors.white,
            ),
            Text(
              publicacion.likes.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      ]),
    );
  }
}

// class from type SliverAppBar
class _CustonAppBarDetalle extends StatelessWidget {
  final Publicacion publicacion;
  const _CustonAppBarDetalle({super.key, required this.publicacion});

  @override
  Widget build(BuildContext context) {
    if (publicacion.img == null) {
      return SliverAppBar(
          // elevation: 1,
          backgroundColor: Color.fromARGB(255, 209, 122, 122),
          floating: false,
          pinned: true,
          flexibleSpace: Container());
    }

    return SliverAppBar(
      elevation: 2,
      backgroundColor: Color.fromARGB(255, 193, 21, 21),
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: false,
          title: Text(
            publicacion.titulo,
            style: TextStyle(color: Colors.white),
          ),
          background: Swiper(
            //punto de referencia para el swiper
            pagination: SwiperPagination(),
            itemCount: publicacion.img!.length,
            itemBuilder: (BuildContext context, int index) {
              return Image.asset(
                publicacion.img![index],
                fit: BoxFit.cover,
              );
            },
          )),
    );
  }
}

class _DescripcionDetalle extends StatelessWidget {
  const _DescripcionDetalle({super.key, required this.publicacion});

  final Publicacion publicacion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Text(
        publicacion.contenido,
        style: TextStyle(fontSize: 18, color: Colors.black87),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

class _CargarComentariosUsuariosListReverse extends StatelessWidget {
  const _CargarComentariosUsuariosListReverse({super.key});

  @override
  Widget build(BuildContext context) {
    final Publicacion publicacion =
        ModalRoute.of(context)!.settings.arguments as Publicacion;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: publicacion.comentarios?.length,
        itemBuilder: (BuildContext context, int index) {
          return _ComentarioUsuario(
              comentarios: publicacion.comentarios![index]);
        },
      ),
    );
  }
}

class _ComentarioUsuario extends StatelessWidget {
  final Comentarios comentarios;
  const _ComentarioUsuario({super.key, required this.comentarios});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.red,
            //Las dos primeras letras del nombre
            child: Text(
              comentarios.nombre.substring(0, 2),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comentarios.nombre,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),

                //fecha de publicacion
                Text(
                  comentarios.fecha,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  comentarios.comentario,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          Icon(
            FontAwesomeIcons.heart,
            size: 15,
          ),
          SizedBox(width: 5),
          Text(
            comentarios.likes.toString(),
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}

class _LikesComentariosDetalle extends StatelessWidget {
  const _LikesComentariosDetalle({super.key, required this.publicacion});

  final Publicacion publicacion;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              //nombre de usuario que publico
              children: [
                Text(
                  publicacion.usuario,
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '  ${publicacion.fecha}',
                  style: TextStyle(fontSize: 2),
                )
              ],
            ),
          ),
          Divider(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.heart,
                  size: 16,
                ),
                SizedBox(width: 5),
                Text(
                  publicacion.likes.toString(),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 28),
                Icon(
                  FontAwesomeIcons.comment,
                  size: 16,
                ),
                SizedBox(width: 5),
                Text(
                  publicacion.comentarios!.length.toString(),
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                //Icono de compartir
                GestureDetector(
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.shareFromSquare,
                          size: 16,
                          color: Color(0xFF6165FA),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Compartir',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6165FA),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      print('Compartir');
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
