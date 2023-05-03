class Usuario2 {
  final String nombre;
  final int edad;
  final List<String> profesiones;

  Usuario2(
      {required this.nombre, required this.edad, required this.profesiones});

  copyWith({
    String? nombre,
    int? edad,
    List<String>? profesiones,
  }) =>
      new Usuario2(
          nombre: nombre ?? this.nombre,
          edad: edad ?? this.edad,
          profesiones: profesiones ?? this.profesiones);
}
