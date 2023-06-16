part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool displayManualMarker;
  final List<Feature> history;

  const SearchState(
      {this.displayManualMarker = false, this.history = const []});

  SearchState copyWith({bool? displayManualMarker, List<Feature>? history}) =>
      SearchState(
          displayManualMarker: displayManualMarker ?? this.displayManualMarker,
          history: history ?? this.history);

  @override
  List<Object> get props => [displayManualMarker, history];
}
