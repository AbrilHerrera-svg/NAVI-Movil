class Negocio {
  final String nombre;
  final String direccion;

  const Negocio({required this.nombre, required this.direccion});

  factory Negocio.fromJson(Map<String, dynamic> json) {
    return Negocio(
      nombre: (json['name'] as String?)?.trim() ?? '',
      direccion: (json['address'] as String?)?.trim() ?? '',
    );
  }
}
