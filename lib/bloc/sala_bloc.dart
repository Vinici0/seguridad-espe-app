import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sala_event.dart';
part 'sala_state.dart';

class SalaBloc extends Bloc<SalaEvent, SalaState> {
  SalaBloc() : super(SalaInitial()) {
    on<SalaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
