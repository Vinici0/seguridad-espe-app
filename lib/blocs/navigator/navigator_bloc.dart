import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigator_event.dart';
part 'navigator_state.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, NavigatorStateInit> {
  NavigatorBloc() : super(NavigatorStateInit(index: 0)) {
    on<NavigatorIndexEvent>((event, emit) {
      emit(state.copyWith(index: event.index));
    });

    on<NavigatorIsNewSelectedEvent>((event, emit) {
      emit(state.copyWith(isNewSelected: event.isNewSelected));
    });

    on<NavigatorIsPlaceSelectedEvent>((event, emit) {
      emit(state.copyWith(isNumberFamilySelected: event.isPlaceSelected));
    });

    on<NavigatorIsNumberFamilyEvent>((event, emit) {
      emit(state.copyWith(isNumberFamily: event.isNumberFamily));
    });
  }
}
