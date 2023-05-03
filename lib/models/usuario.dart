import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  bool online;
  String nombre;
  String email;
  String uid;
  Usuario({
    required this.online,
    required this.nombre,
    required this.email,
    required this.uid,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        online: json["online"],
        nombre: json["nombre"],
        email: json["email"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "online": online,
        "nombre": nombre,
        "email": email,
        "uid": uid,
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
