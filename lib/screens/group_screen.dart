import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/models/sales_response.dart';
import 'package:flutter_maps_adv/resources/services/chat_provider.dart';
import 'package:flutter_maps_adv/screens/chatsales_screen.dart';
import 'package:flutter_maps_adv/screens/code_add_sreen.dart';
import 'package:flutter_maps_adv/screens/code_create_sreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GruposScreen extends StatefulWidget {
  static const String salesroute = 'sales';
  const GruposScreen({Key? key}) : super(key: key);

  @override
  State<GruposScreen> createState() => _GruposScreenState();
}

class _GruposScreenState extends State<GruposScreen> {
  RefreshController _refreshController = RefreshController(
      initialRefresh:
          false); //Sirve para refrescar la pantalla cuando se crea un grupo
  // final salaService = new SalasServices();
  List<Sala> salas = [];

  @override
  void initState() {
    // TODO: implement initState
    this._cargarSalas();
    super.initState();
  }

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
            _CretaGroup(),
            Expanded(
              child: _listSalesGroup(context),
            ),
          ],
        ));
  }

  ListView _listSalesGroup(BuildContext context) {
    print(salas.length);
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: salas.length,
      itemBuilder: (_, i) => _salaListTile(salas[i]),
    );
  }

  ListTile _salaListTile(Sala sala) {
    print(sala.color);
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
        final salaService = BlocProvider.of<ChatProvider>(context);
        salaService.salaSeleccionada = sala;
        Navigator.pushNamed(context, ChatScreen.chatsalesroute);
      },
    );
  }

  _cargarSalas() async {
    final salasService = BlocProvider.of<ChatProvider>(context);
    // salas.addAll(await salasService.getSalesAll());
    setState(() {});
    _refreshController.refreshCompleted();
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

class _CretaGroup extends StatelessWidget {
  const _CretaGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, CodigoCreateGrupoScreen.codigoGruporoute);
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFF6165FA).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(Icons.add, color: Color(0xFF6165FA)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Crear grupo',
                    style: TextStyle(
                        color: Color(0xFF6165FA),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
