import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/screens/screens.dart';

class PerfilDetalleScreen extends StatelessWidget {
  static const String perfilDetalleroute = 'perfilDetalle';
  const PerfilDetalleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final publicationBloc = BlocProvider.of<PublicationBloc>(context);
    publicationBloc.getPublicacionesUsuario();
    return Scaffold(
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

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //un circulo con la foto
                  authBloc.state.usuario!.img == null
                      ? const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/no-image.png'),
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(authBloc.state.usuario!.img!),
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  //un texto con el nombre
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authBloc.state.usuario!.nombre,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        authBloc.state.usuario!.email,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(
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
                children: const [
                  Icon(Icons.calendar_today),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Miembro desde hace 1 mes')
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: Colors.black26,
            ),
            const Text('Reportes',
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
                : Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: const Icon(Icons.report_problem),
                          title: const Text('Reporte 1'),
                          subtitle: const Text('Reporte 1'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        );
                      },
                    ),
                  ),
          ],
        );
      }),
    );
  }
}
