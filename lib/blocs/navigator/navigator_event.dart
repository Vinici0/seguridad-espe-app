part of 'navigator_bloc.dart';

abstract class NavigatorEvent extends Equatable {
  const NavigatorEvent();

  @override
  List<Object> get props => [];
}

class NavigatorIndexEvent extends NavigatorEvent {
  final int index;

  const NavigatorIndexEvent({required this.index});

  @override
  List<Object> get props => [index];
}

class NavigatorIsNewSelectedEvent extends NavigatorEvent {
  final bool isNewSelected;

  const NavigatorIsNewSelectedEvent({required this.isNewSelected});

  @override
  List<Object> get props => [isNewSelected];
}

class NavigatorIsPlaceSelectedEvent extends NavigatorEvent {
  final bool isPlaceSelected;

  const NavigatorIsPlaceSelectedEvent({required this.isPlaceSelected});

  @override
  List<Object> get props => [isPlaceSelected];
}

//isNumberFamily
class NavigatorIsNumberFamilyEvent extends NavigatorEvent {
  final bool isNumberFamily;

  const NavigatorIsNumberFamilyEvent({required this.isNumberFamily});

  @override
  List<Object> get props => [isNumberFamily];
}
