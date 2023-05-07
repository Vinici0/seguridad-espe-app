import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/models/sales_response.dart';
import 'package:flutter_maps_adv/resources/services/chat_provider.dart';
import 'package:flutter_maps_adv/screens/chatsales_screen.dart';
import 'package:flutter_maps_adv/screens/codigo_sreen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GruposScreen extends StatefulWidget {
  static final String salesroute = 'sales';
  const GruposScreen({Key? key}) : super(key: key);

  @override
  State<GruposScreen> createState() => _GruposScreenState();
}

class _GruposScreenState extends State<GruposScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
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
          title: Text('Grupos',
              style: TextStyle(color: Colors.black87, fontSize: 20)),
          backgroundColor: Colors.white,
          elevation: 1,
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
    return ListTile(
        title: Text(sala.nombre),
        leading: CircleAvatar(
          child: Text(sala.nombre.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        onTap: () {
          final salaService = BlocProvider.of<ChatProvider>(context);
          //navegacion a screen ingreso nombre grupo CodigoGrupoScreen
          salaService.salaSeleccionada = sala;
          Navigator.pushNamed(context, ChatScreen.chatsalesroute);
        });
  }

  _cargarSalas() async {
    final salasService = BlocProvider.of<ChatProvider>(context);
    salas.addAll(await salasService.getSalesAll());
    setState(() {});
    _refreshController.refreshCompleted();
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
              Navigator.pushNamed(context, CodigoGrupoScreen.codigoGruporoute);
            },
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(Icons.add, color: Colors.blue),
                ),
                const SizedBox(width: 10),
                Text(
                  'Crear grupo',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
