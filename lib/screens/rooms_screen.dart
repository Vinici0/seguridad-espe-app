import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/models/sales_response.dart';
import 'package:flutter_maps_adv/screens/chatsales_screen.dart';
import 'package:flutter_maps_adv/screens/code_add_sreen.dart';
import 'package:flutter_maps_adv/screens/code_create_sreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoomsScreen extends StatelessWidget {
  static const String salasroute = 'salas';
  const RoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: false,
        title: const Text('Grupos',
            style: TextStyle(color: Colors.black, fontSize: 20)),
        elevation: 0.5,
        actions: const [IconModal()],
      ),
      body: BlocBuilder<RoomBloc, RoomState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            color: Colors.white,
            child: RefreshIndicator(
              onRefresh: () async {
                // roonBloc.add(SalasInitEvent());
              },
              color: const Color(0xFF6165FA),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 13),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Navigator.pushNamed(context,
                                  CodigoCreateGrupoScreen.codigoGruporoute);
                            },
                            child: Row(
                              children: const [
                                //icon de add grupo
                                Icon(
                                  FontAwesomeIcons.plus,
                                  color: Color(0xFF6165FA),
                                  size: 20,
                                ),

                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  'Crear un nuevo grupo',
                                  style: TextStyle(
                                      color: Color(0xFF6165FA), fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.salas.length,
                            itemBuilder: (context, index) {
                              return SalaListTitle(sala: state.salas[index]);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SalaListTitle extends StatelessWidget {
  final Sala sala;
  const SalaListTitle({Key? key, required this.sala}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final salasService = BlocProvider.of<RoomBloc>(context);
    final membersBloc = BlocProvider.of<MembersBloc>(context);
    return ListTile(
      title: Text(sala.nombre),
      //total mensaje no leidos
      trailing: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: const Center(
          child: Text(
            "5",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ),
      ),

      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(int.parse(
                  '0xFF${sala.color.substring(0, 2)}DDBB${sala.color.substring(4)}')),
              Color(int.parse('0xFF${sala.color}')),
              const Color.fromARGB(255, 230, 116, 226),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Text(
            sala.nombre.substring(0, 2),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      onTap: () {
        membersBloc.add(ChatInitEvent());
        salasService.add(SalaSelectEvent(sala));
        Navigator.of(context).push(_createRoute(const ChatScreen()));
      },
    );
  }
}

class IconModal extends StatelessWidget {
  const IconModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        //boton de los tres puntos
        Icons.more_vert,
        color: Colors.black,
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          builder: (BuildContext context) {
            return Container(
              height: 120.0,
              decoration: const BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        FontAwesomeIcons.plus,
                        color: Colors.black,
                      ),
                      title: const Text('Crear un nuevo grupo'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, CodigoCreateGrupoScreen.codigoGruporoute);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        FontAwesomeIcons.userGroup,
                        color: Colors.black,
                      ),
                      title: const Text('Unir a un grupo'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, CodigoAddGrupoScreen.codigoAddGruporoute);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Route _createRoute(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
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
