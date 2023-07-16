import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/search/search_bloc.dart';
import 'package:flutter_maps_adv/models/search_result.dart';
import 'package:flutter_maps_adv/models/ubicacion.dart';
import 'package:flutter_maps_adv/screens/place_details_screen.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {
  SearchDestinationDelegate() : super(searchFieldLabel: 'Buscar...');

  //Cuando se presiona la X
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  //Cuando se presiona la flecha de regreso del buscador
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        final result = SearchResult(cancel: true);
        close(context, result);
      },
    );
  }

  //Cuando se selecciona una opcion del buscador
  @override
  Widget buildResults(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
    if (query.isEmpty) {
      return Container();
    }

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final places = state.ubicacion;

        if (places.isEmpty || places.isEmpty) {
          return const Center(
            child: Text('No hay resultados'),
          );
        }

        return ListView.separated(
            itemBuilder: (_, i) {
              final place = places[i];
              return ListTile(
                leading: const Icon(Icons.place),
                title: Text(place.barrio),
                subtitle: Text(
                    '${place.ciudad}, ${place.referencia ?? ''} ${place.pais}'),
                onTap: () {
                  searchBloc.add(AddToHistoryEvent(place));
                  final result = SearchResult(cancel: false, manual: true);
                  close(context, result);
                  Navigator.pushNamed(context, PlaceDetailScreen.place,
                      arguments: {'ubicacion': place, 'isDelete': false});
                },
              );
            },
            separatorBuilder: (_, i) => const Divider(),
            itemCount: places.length);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
    if (query.isEmpty) {
      return Container();
    }
    searchBloc.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: searchBloc.listUbicacionStream,
      builder: (context, AsyncSnapshot<List<Ubicacion>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text('No hay resultados'),
          );
        }

        final places = snapshot.data!;

        if (places.isEmpty) {
          return const Center(
            child: Text('No hay resultados'),
          );
        }

        return ListView.separated(
            itemBuilder: (_, i) {
              final place = places[i];
              return ListTile(
                leading: const Icon(Icons.place),
                title: Text(place.barrio),
                subtitle: Text(
                    '${place.ciudad}, ${place.referencia ?? ''} ${place.pais}'),
                onTap: () {
                  searchBloc.add(AddToHistoryEvent(place));
                  final result = SearchResult(cancel: false, manual: true);
                  close(context, result);
                  Navigator.pushNamed(context, PlaceDetailScreen.place,
                      arguments: {'ubicacion': place, 'isDelete': false});
                },
              );
            },
            separatorBuilder: (_, i) => const Divider(),
            itemCount: places.length);
      },
    );
  }
}
