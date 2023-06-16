part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool displayManualMarker;
  final List<Feature> places;
  final List<Feature> history;

  const SearchState(
      {this.displayManualMarker = false,
      this.places = const [],
      this.history = const []});

  SearchState copyWith({bool? displayManualMarker, List<Feature>? history}) =>
      SearchState(
          displayManualMarker: displayManualMarker ?? this.displayManualMarker,
          places: history ?? this.places,
          history: history ?? this.history);

  @override
  List<Object> get props => [displayManualMarker, places, history];
}
