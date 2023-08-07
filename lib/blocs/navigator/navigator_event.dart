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

class NavigatorIsNumberFamilySelectedEvent extends NavigatorEvent {
  final bool isNumberFamilySelected;

  const NavigatorIsNumberFamilySelectedEvent(
      {required this.isNumberFamilySelected});

  @override
  List<Object> get props => [isNumberFamilySelected];
}
