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

  /// Pedidos del cliente que inició sesión (GET /api/orders/mine), filtrados
  /// en el backend por su propio uid. El folio es secuencial ("#104"), así
  /// que ordenar por su número da los más recientes primero sin depender
  /// del orden de Firestore.
  Future<List<Pedido>> misPedidos() async {
    final respuesta = await _api.get('/api/orders/mine');
    final lista = (respuesta as List).cast<Map<String, dynamic>>();
    final pedidos = lista.map(Pedido.fromJson).toList();
    pedidos.sort((a, b) => _numeroFolio(b.folio).compareTo(_numeroFolio(a.folio)));
    return pedidos;
  }

  int _numeroFolio(String folio) => int.tryParse(folio.replaceAll('#', '')) ?? 0;
}
