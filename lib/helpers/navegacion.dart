import 'dart:async';

class _NavegacionServiceBloc {
  int _index = 0;

  // Usamos un broadcast StreamController para poder tener varios listeners.
  final StreamController<int> _counterController =
      StreamController<int>.broadcast();

  Stream<int> get counterStream => _counterController.stream;

  void cambiarIndex(int index) {
    _index = index;
    _counterController.sink.add(_index);
  }

  get index => _index;

  void dispose() {
    _counterController.close();
  }
}

final counterBloc = _NavegacionServiceBloc();
