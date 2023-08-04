import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/blocs/notification/notification_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends StatelessWidget {
  static const routeName = 'notifications_screen';
  static const String sos = 'sos';
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          final authBloc = BlocProvider.of<AuthBloc>(context, listen: false);
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
                        ? state.notificaciones[index].usuario.nombre
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
                        timeago.format(
                          state.notificaciones[index].createdAt,
                          locale: 'es',
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // ignore: unrelated_type_equality_checks
                      state.notificaciones[index].leidaPorUsuario
                              .map((e) => e.leida == true)
                              .toList()
                              .isEmpty
                          ? const SizedBox()
                          : const CircleAvatar(
                              radius: 10,
                              backgroundColor: Color(0xFF6165FA),
                            ),
                    ],
                  ),
                  onTap: () {
                    state.notificaciones[index].tipo == NotificationsScreen.sos
                        ? Navigator.pushNamed(context, 'sos_detalle',
                            arguments: state.notificaciones[index].uid)
                        : Navigator.pushNamed(context, 'publicacion_detalle',
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
