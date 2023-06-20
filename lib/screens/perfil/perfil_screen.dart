import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  static const String salesroute = 'perfil';
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title: const Text('Menu',
            style: TextStyle(color: Colors.black, fontSize: 20)),
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
                      icon: Icons.person_outline,
                      name: 'Mi perfil',
                      route: '',
                    ),
                    Divider(
                      color: Colors.black45,
                    ),
                    _ListIconName(
                      //icnoo de direccion, lugares sin fonodo negro
                      icon: Icons.house_outlined,
                      name: 'Mis Direcciones',
                      route: 'lugares',
                    ),
                    Divider(
                      color: Colors.black45,
                    ),
                    //mis contactos
                    _ListIconName(
                      icon: Icons.quick_contacts_dialer_outlined,
                      name: "Mis contactos",
                      route: "information_family",
                    ),
                    Divider(
                      color: Colors.black45,
                    ),
                    _ListIconName(
                      icon: Icons.group_add_outlined,
                      name: "Mis Grupos",
                      route: "salas",
                    )
                  ]),
            ),
            SizedBox(
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
                      'Ajutes',
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
                  _ListIconName(
                    //agrega el icono de cuenta de datos personales
                    icon: Icons.account_circle_outlined,
                    name: 'Cuenta',
                    route: '',
                  ),
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
  final route;
  @override
  Widget build(BuildContext context) {
    const bool routeActive = true;
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.pushNamed(context, route, arguments: routeActive);
        },
        child: Row(
          children: [
            //icono de perfil
            Icon(
              icon,
              color: Colors.black87,
              size: 30,
            ),
            const SizedBox(
              width: 30,
            ),
            Text(
              name,
              style: TextStyle(color: Colors.black87, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
