import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/notification/notification_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationsScreen extends StatelessWidget {
  static const routeName = 'notifications_screen';
  static const String sos = 'sos';
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final publicationBloc =
        BlocProvider.of<PublicationBloc>(context, listen: false);
    final notificationBloc =
        BlocProvider.of<NotificationBloc>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title: const Text(
          'Notificaciones',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        elevation: 0.5,
      ),

      /*
        ListTiles lisview
       */
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          //no tienes notificaciones
          if (state.notificaciones.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  //icono de notificaciones
                  Icon(
                    Icons.notifications,
                    color: Colors.black54,
                    size: 100,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'No tienes nada pendiente',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Cuando tengas notificaciones pendientes, las verás aquí.',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.notificaciones.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: state.notificaciones[index].tipo ==
                            NotificationsScreen.sos
                        ? Colors.white
                        : Color(int.parse(
                            "0xFF${state.notificaciones[index].publicacion!.color}")),
                    // backgroundImage: AssetImage('assets/images/usuario.png'),
                    child: state.notificaciones[index].tipo ==
                            NotificationsScreen.sos
                        ? Image.asset('assets/sos.png')
                        : SvgPicture.asset(
                            'assets/alertas/${state.notificaciones[index].publicacion!.imgAlerta}',
                            width: 25,
                            color: Colors.white,
                          ),
                  ),
                  title: Text(
                    // state.notificaciones[index].usuario.nombre,
                    state.notificaciones[index].tipo == NotificationsScreen.sos
                        ? state.notificaciones[index].usuarioRemitente.nombre
                        : state.notificaciones[index].publicacion!.titulo,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    state.notificaciones[index].mensaje,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.notificaciones[index].createdAt
                            .toString()
                            .substring(0, 10),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // ignore: unrelated_type_equality_checks
                      state.notificaciones[index].isLeida
                          ? const SizedBox()
                          : const CircleAvatar(
                              radius: 10,
                              backgroundColor: Color(0xFF6165FA),
                            ),
                    ],
                  ),
                  onTap: () {
                    notificationBloc.add(MarcarNotificacionComoLeidaEvent(
                        state.notificaciones[index].uid));

                    state.notificaciones[index].tipo == NotificationsScreen.sos
                        ? null
                        : publicationBloc.add(PublicacionSelectEvent(
                            state.notificaciones[index].publicacion!));

                    state.notificaciones[index].tipo == NotificationsScreen.sos
                        ? Navigator.pushNamed(context, 'sos_notification',
                            arguments: state.notificaciones[index])
                        : Navigator.pushNamed(context, 'detalle',
                            arguments: state.notificaciones[index].publicacion);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Route _createRoute(Widget screen) {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => screen,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(0.0, 1.0);
//       const end = Offset.zero;
//       const curve = Curves.ease;

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }
