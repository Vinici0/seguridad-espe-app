import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';

class PerfilScreen extends StatelessWidget {
  static const String salesroute = 'perfil';
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title: const Text('Menú',
            style: TextStyle(color: Colors.black87, fontSize: 20)),
        elevation: 0.5,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Container(
              //paddin arriva y abajo
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 10),
                      child: Text(
                        'Perfil',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _ListIconName(
                      icon: Icons.person_2_rounded,
                      name: 'Mi perfil',
                      route: 'perfilDetalle',
                    ),

                    // _ListIconName(
                    //   //icnoo de direccion, lugares sin fonodo negro
                    //   icon: Icons.house_sharp,
                    //   name: 'Mis Direcciones',
                    //   route: 'lugares',
                    // ),
                    Divider(
                      color: Colors.black45,
                    ),
                    //mis contactos
                    _ListIconName(
                      icon: Icons.quick_contacts_dialer_rounded,
                      name: "Mis contactos",
                      route: "information_familyauth",
                    ),
                    Divider(
                      color: Colors.black45,
                    ),
                    _ListIconName(
                      icon: Icons.group_add_rounded,
                      name: "Mis Grupos",
                      route: "salas",
                    ),
                    // cambiar contrasena
                  ]),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 10),
                    child: Text(
                      'Ajustes',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  //cuenta
                  SizedBox(
                    height: 10,
                  ),
                  // _ListIconName(
                  //   icon: Icons.account_circle_outlined,
                  //   name: 'Cuenta',
                  //   route: '',
                  // ),
                  Divider(
                    color: Colors.black45,
                  ),
                  //cerrar sesion
                  _ListIconName(
                    icon: Icons.logout,
                    name: 'Cerrar sesión',
                    route: 'login',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListIconName extends StatelessWidget {
  const _ListIconName(
      {Key? key, required this.icon, required this.name, this.route})
      : super(key: key);
  final IconData icon;
  final String name;
  // ignore: prefer_typing_uninitialized_variables
  final route;
  @override
  Widget build(BuildContext context) {
    final authServiceBloc = BlocProvider.of<AuthBloc>(context);
    const bool routeActive = true;
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          if (name.contains('Cerrar sesión')) {
            await authServiceBloc.logout();

            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, 'login');
            return;
          }

          Navigator.pushNamed(context, route, arguments: routeActive);
        },
        child: Row(
          children: [
            name.contains('Cerrar sesión')
                ? const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 30,
                  )
                : Icon(
                    icon,
                    color: Colors.grey[800],
                    size: 30,
                  ),
            const SizedBox(
              width: 30,
            ),
            Text(
              name,
              style: TextStyle(
                  color: name.contains('Cerrar sesión')
                      ? Colors.red
                      : Colors.black87,
                  fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
