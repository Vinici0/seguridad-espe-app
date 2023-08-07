import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/delegates/search_destination_delegate.dart';
import 'package:flutter_maps_adv/helpers/page_route.dart';
import 'package:flutter_maps_adv/models/search_result.dart';
import 'package:flutter_maps_adv/screens/home_screen.dart';
import 'package:flutter_maps_adv/screens/place_details_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlacesScreen extends StatelessWidget {
  static const String salesroute = 'lugares';
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onSearchResults(BuildContext context, SearchResult result) {
      final searchBloc = BlocProvider.of<SearchBloc>(context);

      if (result.manual == true) {
        searchBloc.add(OnActivateManualMarkerEvent());
        return;
      }
    }

    final navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: false,
        title: const Text('Mis Direcciones',
            style: TextStyle(color: Colors.black, fontSize: 20)),
        // backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          //boton texto de siguiente
          !navigatorBloc.state.isNumberFamilySelected
              ? const SizedBox()
              : TextButton(
                  onPressed: () {
                    navigatorBloc.add(
                        const NavigatorIsNumberFamilySelectedEvent(
                            isNumberFamilySelected: false));

                    Navigator.pushReplacementNamed(
                        context, HomeScreen.homeroute);
                  },
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(color: Color(0xFF6165FA), fontSize: 16),
                  ),
                ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                //pagado a la izquierda
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      "assets/lugares2.svg",
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.38,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 20),
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: const Text(
                      "Agrega direcciones para mantenerte informado de lo que sucede alrededor de tu comunidad y recibir alertas de emergencia.",
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final result = await showSearch(
                          context: context,
                          delegate: SearchDestinationDelegate());
                      if (result == null) return;
                      // ignore: use_build_context_synchronously
                      onSearchResults(context, result);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 20),
                      color: Colors.white,
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: const [
                                Icon(
                                  FontAwesomeIcons.plus,
                                  color: Color(0xFF6165FA),
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  'Agregar dirección',
                                  style: TextStyle(
                                      color: Color(0xFF6165FA), fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  state.ubicaciones.isEmpty
                      ? Container(
                          margin: const EdgeInsets.only(top: 20, left: 20),
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: const Text(
                            "No tienes direcciones agregadas",
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            const Divider(
                              color: Colors.black12,
                              thickness: 1,
                            ),
                            ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.ubicaciones.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(Icons.place,
                                      color: Color(0xFF6165FA)),
                                  title: Text(state.ubicaciones[index].barrio),
                                  subtitle: Text(
                                      '${state.ubicaciones[index].ciudad}, ${state.ubicaciones[index].referencia ?? ''} ${state.ubicaciones[index].pais}'),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, PlaceDetailScreen.place,
                                        arguments: {
                                          'ubicacion': state.ubicaciones[index],
                                          'isDelete': true
                                        });
                                  },
                                );
                              },
                            ),
                            const Divider(
                              color: Colors.black12,
                              thickness: 1,
                            ),
                          ],
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
