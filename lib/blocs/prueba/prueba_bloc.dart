import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_maps_adv/models/usuario2.dart';

part 'prueba_event.dart';
part 'prueba_state.dart';

class PruebaBloc extends Bloc<PruebaEvent, PruebaState> {
  PruebaBloc() : super(PruebaState()) {
    on<ActivarUsuario>((event, emit) {
      emit(state.copyWith(usuario: event.usuario));
    });
  }
}
