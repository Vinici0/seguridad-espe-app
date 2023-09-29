import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/models/publication.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:timeago/timeago.dart' as timeago;

class PerfilDetalleScreen extends StatelessWidget {
  static const String perfilDetalleroute = 'perfilDetalle';
  const PerfilDetalleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Environment.apiUrl
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final publicationBloc = BlocProvider.of<PublicationBloc>(context);
    publicationBloc.getPublicacionesUsuario();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: false,
        title: const Text(
          'Perfil',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: BlocBuilder<PublicationBloc, PublicationState>(
          builder: (context, state) {
        //si no hay publicaciones

        return BlocBuilder<PublicationBloc, PublicationState>(
          builder: (context, state) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: _PerfilCicle(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, EditPerfilScreen.editPerfilroute);
                    },
                    //color del boton
                    color: Colors.white,
                    child: Row(
                      children: const [
                        Icon(Icons.edit),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Editar perfil')
                      ],
                    ),
                  ),
                ),
                //miembro desde hace
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                          'Miembro desde ${timeago.format(DateTime.parse(authBloc.state.usuario!.createdAt), locale: 'es')}'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: Colors.black26,
                ),
                const Text('Mis Reportes',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const Divider(
                  color: Colors.black26,
                ),

                state.publicacionesUsuario.isEmpty
                    ? const Center(
                        child: Text('No hay reportes'),
                      )
                    : Flexible(
                        child: _ListNews(
                          publicaciones: state.publicacionesUsuario,
                          firstController: ScrollController(),
                          size: MediaQuery.of(context).size,
                          publicationBloc: publicationBloc,
                          usuarioBloc: authBloc,
                          state: state,
                        ),
                      ),
              ],
            );
          },
        );
      }),
    );
  }
}

class _PerfilCicle extends StatelessWidget {
  const _PerfilCicle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //un circulo con la foto
            state.usuario!.img == null
                ? const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/no-image.png'),
                  )
                : state.usuario!.google
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(state.usuario!.img!),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            '${Environment.apiUrl}/uploads/usuario/usuarios/${state.usuario!.uid}'),
                      ),
            const SizedBox(
              width: 10,
            ),
            //un texto con el nombre
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.usuario!.nombre,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    state.usuario!.email,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ListNews extends StatelessWidget {
  const _ListNews({
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
            // reverse: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, i) => Card(
              margin: const EdgeInsets.all(0),
              elevation: 0,
              //ubicar una linea en la parte inferior de cada card
              shape: const Border(
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
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            //centrar de arriva a abajo
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: CircleAvatar(
                                  backgroundColor: Color(int.parse(
                                      "0xFF${publicaciones[i].color}")), //Color(0xffFDCF09
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: publicaciones[i]
                                            .imgAlerta
                                            .endsWith('.png')
                                        ? Image.asset(
                                            'assets/iconvinculacion/${publicaciones[i].imgAlerta}',
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
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Text(
                                      publicaciones[i].titulo,
                                      style: const TextStyle(
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
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 62, right: 5),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Text(publicaciones[i].contenido),
                              ),

                              publicaciones[i].imagenes != null &&
                                      publicaciones[i].imagenes!.isNotEmpty
                                  ? Container(
                                      width: double.infinity,
                                      height: size.height * 0.35,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9.0),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(9.0),
                                        ),
                                        child: Image.network(
                                          "${Environment.apiUrl}/uploads/publicaciones/${publicaciones[i].uid!}?imagenIndex=${publicaciones[i].imagenes!.first}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(),

                              //texto pegado a la izquierda
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.only(top: 10),
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
                                      Text(
                                        '${publicaciones[i].ciudad} - ${publicaciones[i].barrio}',
                                        style: const TextStyle(
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

                      Navigator.pushNamed(context, DetalleScreen.detalleroute,
                          arguments: {
                            'publicacion': publicaciones[i],
                            'likes': publicaciones[i].likes!.length.toString(),
                          });
                    },
                  ),
                ],
              ),
            ),
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
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
}
