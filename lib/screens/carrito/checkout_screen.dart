import 'package:flutter/material.dart';
import 'package:navi/services/carrito_service.dart';
import 'package:navi/widgets/barra_superior_navi.dart';
import 'package:navi/widgets/boton_primario_navi.dart';
import 'package:navi/widgets/opcion_seleccionable_navi.dart';

enum _MetodoPago { tarjeta, efectivo, transferencia }

/// Mockup 7: solo pago en sucursal al recoger el pedido (no hay cobro en
/// línea todavía). Elegir método es local; cuando exista un endpoint de
/// pedidos en NAVI-web, esto se enviará junto con el pedido.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const Color naviMorado = Color(0xFF5960A1);

  _MetodoPago _metodo = _MetodoPago.tarjeta;
  bool _confirmando = false;

  Future<void> _confirmarPedido() async {
    setState(() => _confirmando = true);

    // TODO: cuando exista POST /api/orders en NAVI-web, mandar aquí el
    // carrito + horario + método de pago en vez de solo limpiar localmente.
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    CarritoService().limpiar();
    Navigator.popUntil(context, (route) => route.isFirst);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pedido confirmado con éxito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final carrito = CarritoService();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: const BarraSuperiorNavi(seccion: 'Método de pago'),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF0FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.storefront_outlined, color: naviMorado, size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'El pago se realiza al recoger tu pedido en sucursal.',
                              style: TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Elige cómo vas a pagar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 10),
                    OpcionSeleccionableNavi(
                      titulo: 'Tarjeta en sucursal',
                      subtitulo: 'Pago con terminal al recoger',
                      icono: Icons.credit_card,
                      seleccionado: _metodo == _MetodoPago.tarjeta,
                      onTap: () => setState(() => _metodo = _MetodoPago.tarjeta),
                    ),
                    const SizedBox(height: 8),
                    OpcionSeleccionableNavi(
                      titulo: 'Efectivo',
                      subtitulo: 'Pago en caja al recoger',
                      icono: Icons.payments_outlined,
                      seleccionado: _metodo == _MetodoPago.efectivo,
                      onTap: () => setState(() => _metodo = _MetodoPago.efectivo),
                    ),
                    const SizedBox(height: 8),
                    OpcionSeleccionableNavi(
                      titulo: 'Transferencia',
                      subtitulo: 'Próximamente',
                      icono: Icons.account_balance_outlined,
                      seleccionado: _metodo == _MetodoPago.transferencia,
                      habilitado: false,
                      onTap: () => setState(() => _metodo = _MetodoPago.transferencia),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Color(0x1A5960A1), blurRadius: 12, offset: Offset(0, -2))],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total a pagar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(
                            '\$${carrito.totalPrecio.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: naviMorado),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      BotonPrimarioNavi(
                        texto: 'Confirmar pedido',
                        cargando: _confirmando,
                        onPressed: _confirmarPedido,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
