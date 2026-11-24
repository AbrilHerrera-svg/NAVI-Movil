/// Resultado de crear un pedido en NAVI-web (POST /api/orders).
class Pedido {
  final String id;
  final String folio;
  final String estado;
  final String horaEstimada;

  const Pedido({
    required this.id,
    required this.folio,
    required this.estado,
    required this.horaEstimada,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'] as String? ?? '',
      folio: json['orderNumber'] as String? ?? '',
      estado: json['status'] as String? ?? 'Nuevo',
      horaEstimada: json['dueTime'] as String? ?? 'Por definir',
    );
  }
}
