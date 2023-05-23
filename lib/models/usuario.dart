import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  bool online;
  String nombre;
  String email;
  String uid;
  double? latitud;
  double? longitud;
  Usuario({
    required this.online,
    required this.nombre,
    required this.email,
    required this.uid,
    required this.latitud,
    required this.longitud,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        online: json["online"],
        nombre: json["nombre"],
        email: json["email"],
        uid: json["uid"],
        latitud: json["latitud"],
        longitud: json["longitud"],
      );

  Map<String, dynamic> toJson() => {
        "online": online,
        "nombre": nombre,
        "email": email,
        "uid": uid,
        "latitud": latitud,
        "longitud": longitud,
      };

  //getters y setters
  get getNombre => this.nombre;

  void setNombre(String? nombre) {
    this.nombre = nombre!;
  }

  get getEmail => this.email;

  void setEmail(String? email) {
    this.email = email!;
  }

  get getUid => this.uid;

  void setUid(String? uid) {
    this.uid = uid!;
  }

  get getOnline => this.online;

  void setOnline(bool? online) {
    this.online = online!;
  }

  @override
  String toString() {
    return 'Usuario{online: $online, nombre: $nombre, email: $email, uid: $uid}';
  }
}
