/*
  Model Comentarios:
  id, id_usuario, nombre, comentario, fecha, hora, id_publicacion
 */

class Comentarios {
  String id;
  String id_usuario;
  String nombre;
  String comentario;
  String fecha;
  String hora;
  String id_publicacion;
  int likes;

  Comentarios({
    required this.id,
    required this.id_usuario,
    required this.nombre,
    required this.comentario,
    required this.fecha,
    required this.hora,
    required this.id_publicacion,
    required this.likes,
  });

  factory Comentarios.fromJson(Map<String, dynamic> json) => Comentarios(
        id: json["id"],
        id_usuario: json["id_usuario"],
        nombre: json["nombre"],
        comentario: json["comentario"],
        fecha: json["fecha"],
        hora: json["hora"],
        id_publicacion: json["id_publicacion"],
        likes: json["likes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_usuario": id_usuario,
        "nombre": nombre,
        "comentario": comentario,
        "fecha": fecha,
        "hora": hora,
        "id_publicacion": id_publicacion,
        "likes": likes,
      };
}
