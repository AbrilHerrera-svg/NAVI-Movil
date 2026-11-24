import 'package:flutter/material.dart';
import 'package:navi/widgets/logotipo_navi.dart';

/// Historial/seguimiento de pedidos. Placeholder por ahora: se conecta de
/// verdad a /api/orders cuando lleguemos a los mockups de confirmación y
/// seguimiento de pedido.
class PantallaPedidos extends StatelessWidget {
  const PantallaPedidos({super.key});

  static const Color naviMorado = Color(0xFF5960A1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 16,
        title: Row(
          children: [
            const LogotipoNavi(tamanoIcono: 28, tamanoTexto: 18),
            const SizedBox(width: 8),
            const Text('| Pedidos', style: TextStyle(fontSize: 14, color: Colors.black45)),
          ],
        ),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.receipt_long_outlined, size: 48, color: Colors.black26),
              SizedBox(height: 16),
              Text('Todavía no tienes pedidos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 8),
              Text(
                'Cuando hagas tu primer pedido, aquí verás su estado y tu historial.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
