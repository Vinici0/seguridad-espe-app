import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/models/sales_response.dart';
import 'package:flutter_maps_adv/resources/services/salas_provider.dart';
import 'package:flutter_maps_adv/screens/chatsales_screen.dart';
import 'package:flutter_maps_adv/screens/codigo_add_sreen.dart';
import 'package:flutter_maps_adv/screens/codigo_create_sreen.dart';
import 'package:flutter_maps_adv/screens/grupos_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SalasScreen extends StatelessWidget {
  static const String salasroute = 'salas';
  const SalasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('Grupos',
              style: TextStyle(color: Colors.black, fontSize: 20)),
          // backgroundColor: Colors.white,
          elevation: 1,
          actions: [IconModal()],
        ),
        body: Column(
          children: [
            // _CretaGroup(),
            Expanded(
              child: _listSalesGroup(context),
            ),
          ],
        ));
  }

  ListView _listSalesGroup(BuildContext context) {
    final salasService = BlocProvider.of<SalasProvider>(context);
    final salas = salasService.salas;
    print(salas.length);
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: salas.length,
      itemBuilder: (_, i) => SalaListTitle(sala: salas[i]),
    );
  }
}

class SalaListTitle extends StatelessWidget {
  final Sala sala;
  const SalaListTitle({super.key, required this.sala});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(sala.nombre),
      leading: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(int.parse(
                  '0xFF${sala.color.substring(0, 2)}DDBB${sala.color.substring(4)}')),
              Color(int.parse('0xFF${sala.color}')),
              Color.fromARGB(255, 230, 116, 226),

              //0xFF6165FA
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Text(
            sala.nombre.substring(0, 2),
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      onTap: () {
        final salaService = BlocProvider.of<SalasProvider>(context);
        salaService.salaSeleccionada = sala;
        Navigator.pushNamed(context, ChatScreen.chatsalesroute);
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
          shape: RoundedRectangleBorder(
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
                      title: Text('Crear un nuevo grupo'),
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
                      title: Text('Unir a un grupo'),
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
