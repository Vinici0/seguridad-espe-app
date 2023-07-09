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
