import 'package:flutter/material.dart';
import 'package:navi/widgets/barra_superior_navi.dart';
import 'package:navi/widgets/estado_vacio_navi.dart';

/// Historial/seguimiento de pedidos. Placeholder por ahora: se conecta de
/// verdad a /api/orders cuando lleguemos a los mockups de confirmación y
/// seguimiento de pedido.
class PantallaPedidos extends StatelessWidget {
  const PantallaPedidos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: const BarraSuperiorNavi(seccion: 'Pedidos'),
      body: const EstadoVacioNavi(
        icono: Icons.receipt_long_outlined,
        titulo: 'Todavía no tienes pedidos',
        subtitulo: 'Cuando hagas tu primer pedido, aquí verás su estado y tu historial.',
      ),
    );
  }
}
