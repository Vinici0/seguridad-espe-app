part of 'navigator_bloc.dart';

class NavigatorStateInit extends Equatable {
  final int index;

  const NavigatorStateInit({required this.index});

  NavigatorStateInit copyWith({
    int? index,
  }) {
    return NavigatorStateInit(
      index: index ?? this.index,
    );
  }

  @override
  List<Object> get props => [index];
}
