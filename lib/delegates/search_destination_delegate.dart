import 'package:flutter/material.dart';
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
    return const Text('buildResults');
  }

  //Sugerencias que aparecen cuando la persona escribe en el buscador
  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
            leading:
                const Icon(Icons.location_on_outlined, color: Colors.black),
            title: const Text('Colocar la ubicación manualmente',
                style: TextStyle(color: Colors.black)),
            onTap: () {
              //TODO: Retornar algo
              final result = SearchResult(cancel: false, manual: true);
              close(context, result);
            })
      ],
    );
  }
}
