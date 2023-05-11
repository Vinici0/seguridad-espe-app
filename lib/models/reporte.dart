class Reporte {
  String id;
  String nombre;

  Reporte({
    required this.id,
    required this.nombre,
  });

  factory Reporte.fromJson(Map<String, dynamic> json) => Reporte(
        id: json["id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };

  //getters y setters
}
