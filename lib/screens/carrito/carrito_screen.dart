import 'package:flutter/material.dart';
import 'package:navi/screens/carrito/checkout_screen.dart';
import 'package:navi/services/carrito_service.dart';
import 'package:navi/services/servicio_negocio.dart';
import 'package:navi/widgets/barra_superior_navi.dart';
import 'package:navi/widgets/boton_primario_navi.dart';
import 'package:navi/widgets/estado_vacio_navi.dart';
import 'package:navi/widgets/opcion_seleccionable_navi.dart';
import 'package:navi/widgets/selector_cantidad_navi.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  static const Color naviMorado = Color(0xFF5960A1);
  static const Color fondoSuave = Color(0xFFEEF0FB);

  // Nota: la hora de recolección es solo una preferencia local todavía; el
  // backend no tiene un endpoint de pedidos, así que no se envía a ningún
  // lado hasta que exista esa parte en NAVI-web.
  bool _loAntesPosible = true;
  String _nombreSucursal = '';

  @override
  void initState() {
    super.initState();
    _cargarNegocio();
  }

  Future<void> _cargarNegocio() async {
    try {
      final negocio = await ServicioNegocio().obtenerNegocio();
      if (!mounted) return;
      setState(() => _nombreSucursal = negocio.nombre);
    } catch (_) {
      // Informativo; si falla simplemente no se muestra el nombre.
    }
  }

  @override
  Widget build(BuildContext context) {
    final carrito = CarritoService();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: const BarraSuperiorNavi(seccion: 'Carrito'),
      body: ListenableBuilder(
        listenable: carrito,
        builder: (context, _) {
          if (carrito.items.isEmpty) {
            return const EstadoVacioNavi(
              icono: Icons.shopping_bag_outlined,
              titulo: 'Tu carrito está vacío',
              subtitulo: 'Agrega productos del menú para armar tu pedido.',
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      children: [
                        for (final item in carrito.items)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(color: fondoSuave, borderRadius: BorderRadius.circular(10)),
                                  child: Icon(item.producto.icono, color: naviMorado, size: 26),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.producto.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 2),
                                      Text(
                                        '\$${item.producto.precio.toStringAsFixed(2)} c/u',
                                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                                SelectorCantidadNavi(
                                  cantidad: item.cantidad,
                                  onDecrementar: () => carrito.quitar(item.producto),
                                  onIncrementar: () => carrito.agregar(item.producto),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 4),
                        const Text('Horario de recolección', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 10),
                        OpcionSeleccionableNavi(
                          titulo: 'Lo antes posible',
                          subtitulo: _nombreSucursal.isEmpty
                              ? 'Listo en 6-9 min'
                              : 'Listo en 6-9 min · $_nombreSucursal',
                          icono: Icons.bolt,
                          seleccionado: _loAntesPosible,
                          onTap: () => setState(() => _loAntesPosible = true),
                        ),
                        const SizedBox(height: 8),
                        OpcionSeleccionableNavi(
                          titulo: 'Programar para más tarde',
                          subtitulo: 'Próximamente',
                          icono: Icons.schedule,
                          seleccionado: !_loAntesPosible,
                          habilitado: false,
                          onTap: () => setState(() => _loAntesPosible = false),
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
                              const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text(
                                '\$${carrito.totalPrecio.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: naviMorado),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          BotonPrimarioNavi(
                            texto: 'Continuar al pago',
                            cargando: false,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
