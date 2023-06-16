import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/search/search_bloc.dart';
import 'package:flutter_maps_adv/models/search_result.dart';

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
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final proximity =
        BlocProvider.of<LocationBloc>(context).state.lastKnownLocation;
    searchBloc.getResultsByQuery(proximity!, query);
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final places = state.places;
        return ListView.separated(
            itemBuilder: (_, i) {
              final place = places[i];
              return ListTile(
                leading: const Icon(Icons.place),
                title: Text(place.textEs!),
                subtitle: Text(place.placeNameEs!),
                onTap: () {
                  // close(
                  //     context,
                  //     SearchResult(
                  //         cancel: false, manual: false, places: place));
                  searchBloc.add(AddToHistoryEvent(place));
                  print("Tapped");
                },
              );
            },
            separatorBuilder: (_, i) => const Divider(),
            itemCount: places.length);
      },
    );
  }

  //Sugerencias que aparecen cuando la persona escribe en el buscador
  @override
  Widget buildSuggestions(BuildContext context) {
    final history = BlocProvider.of<SearchBloc>(context).state.history;
    return ListView(
      children: [
        ListTile(
            leading:
                const Icon(Icons.location_on_outlined, color: Colors.black),
            title: const Text('Colocar la ubicación manualmente',
                style: TextStyle(color: Colors.black)),
            onTap: () {
              final result = SearchResult(cancel: false, manual: true);
              close(context, result);
            }),
        ...history
            .map((place) => ListTile(
                  leading: const Icon(Icons.history, color: Colors.black),
                  title: Text(place.textEs!),
                  subtitle: Text(place.placeNameEs!),
                  // onTap: () {
                  //   final result = SearchResult(
                  //       cancel: false, manual: false, places: place);
                  //   close(context, result);
                  // },
                ))
            .toList()
      ],
    );
  }
}
