/// Pedido tal como lo guarda NAVI-web (colección "orders"), ya sea el
/// resultado de POST /api/orders o un renglón de GET /api/orders/mine.
class Pedido {
  final String id;
  final String folio;
  final String estado;
  final String horaEstimada;
  final String resumenProductos;
  final double total;

  const Pedido({
    required this.id,
    required this.folio,
    required this.estado,
    required this.horaEstimada,
    required this.resumenProductos,
    required this.total,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'] as String? ?? '',
      folio: json['orderNumber'] as String? ?? '',
      estado: json['status'] as String? ?? 'Nuevo',
      horaEstimada: json['dueTime'] as String? ?? 'Por definir',
      resumenProductos: json['productsSummary'] as String? ?? '',
      total: ((json['total'] as num?) ?? 0).toDouble(),
    );
  }
}
