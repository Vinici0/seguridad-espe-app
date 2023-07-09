import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigator_event.dart';
part 'navigator_state.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, NavigatorStateInit> {
  NavigatorBloc() : super(const NavigatorStateInit(index: 0)) {
    on<NavigatorIndexEvent>((event, emit) {
      emit(state.copyWith(index: event.index));
    });
  }
}
