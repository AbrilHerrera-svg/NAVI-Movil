import 'package:navi/models/item.carrito.dart';
import 'package:navi/models/pedido.dart';
import 'package:navi/services/servicio_api.dart';

/// Crea pedidos reales en NAVI-web (POST /api/orders, origin "App"): el
/// mismo endpoint y colección "orders" que usa el panel de administración,
/// así el pedido aparece ahí para que el negocio lo prepare y cobre.
class ServicioPedidos {
  final ServicioApi _api = ServicioApi();

  Future<Pedido> crearPedido({
    required List<ItemCarrito> items,
    required double total,
    required String metodoPago,
    String? nombreCliente,
  }) async {
    final ahora = DateTime.now();
    final horaRecibido = '${ahora.hour.toString().padLeft(2, '0')}:${ahora.minute.toString().padLeft(2, '0')}';

    final resumen = items.map((item) => '${item.producto.nombre} x${item.cantidad}').join(', ');

    final respuesta = await _api.post('/api/orders', {
      'origin': 'App',
      'receivedTime': horaRecibido,
      'dueTime': 'Por definir',
      if (nombreCliente != null && nombreCliente.isNotEmpty) 'customerName': nombreCliente,
      'productsSummary': resumen,
      'total': total,
      'paymentMethod': metodoPago,
    });

    return Pedido.fromJson(respuesta as Map<String, dynamic>);
  }
}
