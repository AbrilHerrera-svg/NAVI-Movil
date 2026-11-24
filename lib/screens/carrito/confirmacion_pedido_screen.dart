import 'package:flutter/material.dart';
import 'package:navi/models/pedido.dart';
import 'package:navi/screens/main_screen.dart';
import 'package:navi/widgets/logotipo_navi.dart';

/// Mockup 8: folio real (viene de POST /api/orders), hora estimada y
/// sucursal, con acceso directo a Pedidos para darle seguimiento.
class ConfirmacionPedidoScreen extends StatelessWidget {
  const ConfirmacionPedidoScreen({super.key, required this.pedido, required this.nombreSucursal});

  static const Color naviMorado = Color(0xFF5960A1);
  static const Color fondoSuave = Color(0xFFEEF0FB);

  final Pedido pedido;
  final String nombreSucursal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LogotipoNavi(),
                  const SizedBox(height: 24),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(color: naviMorado, shape: BoxShape.circle),
                    child: const Icon(Icons.check, color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '¡Pedido confirmado!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Te avisamos cuando esté listo para recoger.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(color: fondoSuave, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        _Fila(etiqueta: 'Folio', valor: pedido.folio.isEmpty ? '—' : pedido.folio),
                        const SizedBox(height: 12),
                        _Fila(etiqueta: 'Hora estimada', valor: pedido.horaEstimada),
                        const SizedBox(height: 12),
                        _Fila(
                          etiqueta: 'Sucursal',
                          valor: nombreSucursal.isEmpty ? '—' : nombreSucursal,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const MainNavigationScreen(indiceInicial: 2),
                          ),
                          (route) => false,
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: naviMorado,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Ver seguimiento', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Fila extends StatelessWidget {
  const _Fila({required this.etiqueta, required this.valor});

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(etiqueta, style: const TextStyle(color: Colors.black54)),
        Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
