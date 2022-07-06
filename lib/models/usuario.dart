class Usuario {
  bool online;
  String email;
  String nombre;
  String uid;

  Usuario({
    this.online = false,
    required this.email,
    required this.nombre,
    required this.uid,
  });
}