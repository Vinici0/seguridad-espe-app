part of 'navigator_bloc.dart';

class NavigatorStateInit extends Equatable {
  int index;
  final bool isNewSelected;
  final bool isPlaceSelected;
  final bool isNumberFamily;

  NavigatorStateInit(
      {this.index = 0,
      this.isNewSelected = false,
      this.isNumberFamily = false,
      this.isPlaceSelected = false});

  NavigatorStateInit copyWith({
    int? index,
    bool? isNewSelected,
    bool? isNumberFamilySelected,
    bool? isNumberFamily,
  }) {
    return NavigatorStateInit(
      index: index ?? this.index,
      isNewSelected: isNewSelected ?? this.isNewSelected,
      isPlaceSelected: isNumberFamilySelected ?? this.isPlaceSelected,
      isNumberFamily: isNumberFamily ?? this.isNumberFamily,
    );
  }

  @override
  List<Object> get props =>
      [index, isNewSelected, isPlaceSelected, isNumberFamily];
}
