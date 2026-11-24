import 'package:flutter/material.dart';
import 'package:navi/models/pedido.dart';

/// Tarjeta de un pedido con su línea de tiempo de estado, reutilizada en
/// Pedidos (lista completa) y Perfil (historial reciente).
class TarjetaPedidoNavi extends StatelessWidget {
  const TarjetaPedidoNavi({super.key, required this.pedido});

  static const Color naviMorado = Color(0xFF5960A1);

  final Pedido pedido;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pedido.folio.isEmpty ? 'Pedido' : 'Pedido ${pedido.folio}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '\$${pedido.total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: naviMorado),
              ),
            ],
          ),
          if (pedido.resumenProductos.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              pedido.resumenProductos,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
          const SizedBox(height: 16),
          _LineaDeTiempoPedido(estado: pedido.estado),
        ],
      ),
    );
  }
}

class _LineaDeTiempoPedido extends StatelessWidget {
  const _LineaDeTiempoPedido({required this.estado});

  static const Color naviMorado = Color(0xFF5960A1);
  static const List<String> _pasos = ['Nuevo', 'En preparación', 'Listo', 'Recogido'];

  final String estado;

  @override
  Widget build(BuildContext context) {
    if (estado == 'Cancelado') {
      return const Row(
        children: [
          Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 18),
          SizedBox(width: 8),
          Text('Pedido cancelado', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        ],
      );
    }

    final indiceActual = _pasos.indexOf(estado);

    return Row(
      children: [
        for (var i = 0; i < _pasos.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2,
                color: i <= indiceActual ? naviMorado : const Color(0xFFE2E8F0),
              ),
            ),
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i <= indiceActual ? naviMorado : const Color(0xFFE2E8F0),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _pasos[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: i == indiceActual ? FontWeight.bold : FontWeight.normal,
                  color: i <= indiceActual ? naviMorado : Colors.black45,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
