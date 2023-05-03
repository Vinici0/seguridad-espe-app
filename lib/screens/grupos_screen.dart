import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/models/sales_response.dart';
import 'package:flutter_maps_adv/screens/chatsales_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GruposScreen extends StatefulWidget {
  static final String salesroute = 'sales';
  const GruposScreen({Key? key}) : super(key: key);

  @override
  State<GruposScreen> createState() => _GruposScreenState();
}

class _GruposScreenState extends State<GruposScreen> {
  // final salaService = new SalasServices();
  List<Sala> salas = [
    Sala(uid: '1', nombre: 'Grupo 1'),
    Sala(uid: '2', nombre: 'Grupo 2'),
    Sala(uid: '3', nombre: 'Grupo 3'),
    Sala(uid: '4', nombre: 'Grupo 4'),
  ];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
        title: Text('Grupos',
            style: TextStyle(color: Colors.black87, fontSize: 20)),
        backgroundColor: Colors.white,
        //icono de tres puntos para crear grupo a la derecha
        actions: [
          IconButton(
              onPressed: () {
                // Navigator.pushNamed(context, CodigoGrupoScreen.codigoGruporoute);
              },
              icon: Icon(Icons.more_vert, color: Colors.black87))
        ],
        elevation: 1,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        child: Column(
          children: [
            _CretaGroup(),
            Expanded(
              child: _listSalesGroup(context),
            ),
          ],
        ),
      ),
    );
  }

  ListView _listSalesGroup(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Column(
              //pegado a la izquierda
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Grupo $index', style: TextStyle(fontSize: 16)),
                //cantidad de miembros
                Text('3 miembros',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ]),
          leading: CircleAvatar(
            child: Text('G$index', style: TextStyle(color: Colors.white)),
            backgroundColor: Color.fromRGBO(232, 155, 218, 1),
          ),
          onTap: () {
            Navigator.pushNamed(context, ChatSalesScreen.chatsalesroute);
          },
        );
      },
    );
  }

  ListTile _salaListTile(Sala sala) {
    return ListTile(
        title: Text(sala.nombre),
        leading: CircleAvatar(
          child: Text(sala.nombre.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        onTap: () {
          Navigator.pushNamed(context, ChatSalesScreen.chatsalesroute);
        });
  }

  _cargarSalas() async {
    // salas = await salaService.getSales();
    setState(() {});
    // _refreshController.refreshCompleted();
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
          GestureDetector(
            onTap: () {
              //navegacion a screen ingreso nombre grupo CodigoGrupoScreen
              // Navigator.pushNamed(context, CodigoGrupoScreen.codigoGruporoute);
            },
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(Icons.add, color: Colors.indigo),
                ),
                const SizedBox(width: 10),
                Text(
                  'Crear nuevo grupo',
                  style: TextStyle(
                      color: Colors.indigo, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
