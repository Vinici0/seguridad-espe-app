part of 'navigator_bloc.dart';

class NavigatorStateInit extends Equatable {
  final int index;
  final bool isNewSelected;
  final bool isNumberFamilySelected;

  const NavigatorStateInit(
      {required this.index,
      this.isNewSelected = false,
      this.isNumberFamilySelected = false});

  NavigatorStateInit copyWith({
    int? index,
    bool? isNewSelected,
    bool? isNumberFamilySelected,
  }) {
    return NavigatorStateInit(
      index: index ?? this.index,
      isNewSelected: isNewSelected ?? this.isNewSelected,
      isNumberFamilySelected:
          isNumberFamilySelected ?? this.isNumberFamilySelected,
    );
  }

  @override
  List<Object> get props => [index, isNewSelected, isNumberFamilySelected];
}
