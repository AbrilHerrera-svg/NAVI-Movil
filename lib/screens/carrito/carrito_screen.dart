import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navi/models/item.carrito.dart';
import 'package:navi/screens/carrito/checkout_screen.dart';
import 'package:navi/services/carrito_service.dart';
import 'package:navi/services/servicio_negocio.dart';
import 'package:navi/widgets/barra_superior_navi.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  static const Color naviMorado = Color(0xFF5960A1);
  static const Color naviCafe = Color(0xFFAC8572);
  static const Color naviOscuro = Color(0xFF2B2F5E);
  static const Color fondoSuave = Color(0xFFEEF0FB);

  // fondo, texto principal, texto secundario, acento (mismas variantes que el menú)
  static const List<List<Color>> _paletas = [
    [Color(0xFF5960A1), Colors.white, Color(0xFFE3E5F7), Color(0xFFF3E8E1)],
    [Color(0xFFF3E8E1), Color(0xFF2B2F5E), Color(0xFF7A5C4B), Color(0xFFAC8572)],
    [Color(0xFF2B2F5E), Colors.white, Color(0xFFD9DBF2), Color(0xFFE3C7B6)],
    [Color(0xFFD9DCF5), Color(0xFF2B2F5E), Color(0xFF4A4F8C), Color(0xFF5960A1)],
  ];

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
            return _construirVacio();
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 0, 2, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TU ORDEN',
                                style: GoogleFonts.hankenGrotesk(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2.2,
                                  color: naviCafe,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Tu pedido',
                                style: GoogleFonts.bricolageGrotesque(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1.1,
                                  height: 1.05,
                                  color: naviOscuro,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${carrito.totalItems} productos listos para ti',
                                style: GoogleFonts.hankenGrotesk(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        for (var i = 0; i < carrito.items.length; i++)
                          _construirItem(carrito, carrito.items[i], i),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Text(
                            'Horario de recolección',
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                              color: naviOscuro,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _OpcionRecoleccion(
                          titulo: 'Lo antes posible',
                          subtitulo: _nombreSucursal.isEmpty
                              ? 'Listo en 6-9 min'
                              : 'Listo en 6-9 min · $_nombreSucursal',
                          icono: Icons.bolt,
                          seleccionado: _loAntesPosible,
                          onTap: () => setState(() => _loAntesPosible = true),
                        ),
                        const SizedBox(height: 8),
                        _OpcionRecoleccion(
                          titulo: 'Programar para más tarde',
                          subtitulo: 'Próximamente',
                          icono: Icons.schedule,
                          seleccionado: !_loAntesPosible,
                          habilitado: false,
                          onTap: () => setState(() => _loAntesPosible = false),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                      boxShadow: [BoxShadow(color: Color(0x1A2B2F5E), blurRadius: 12, offset: Offset(0, -3))],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Total',
                                style: GoogleFonts.hankenGrotesk(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                '\$${carrito.totalPrecio.toStringAsFixed(2)}',
                                style: GoogleFonts.bricolageGrotesque(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.8,
                                  height: 1.0,
                                  color: naviMorado,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                                );
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: naviOscuro,
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Continuar al pago',
                                    style: GoogleFonts.bricolageGrotesque(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.5,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.arrow_forward, size: 18),
                                ],
                              ),
                            ),
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

  Widget _construirVacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: fondoSuave,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Color(0x1A2B2F5E), blurRadius: 12, offset: Offset(0, 4))],
              ),
              child: const Icon(Icons.shopping_bag_outlined, size: 38, color: naviMorado),
            ),
            const SizedBox(height: 18),
            Text(
              'Tu carrito está vacío',
              textAlign: TextAlign.center,
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
                height: 1.1,
                color: naviOscuro,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Agrega productos del menú para armar tu pedido.',
              textAlign: TextAlign.center,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirItem(CarritoService carrito, ItemCarrito item, int indice) {
    final paleta = _paletas[indice % _paletas.length];
    final fondo = paleta[0];
    final textoPrincipal = paleta[1];
    final textoSecundario = paleta[2];
    final acento = paleta[3];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: fondo.withValues(alpha: 0.28), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: textoPrincipal.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.producto.icono, color: textoPrincipal, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.producto.nombre,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    height: 1.1,
                    color: textoPrincipal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\$${item.producto.precio.toStringAsFixed(2)} c/u',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: textoSecundario,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '\$${item.subtotal.toStringAsFixed(2)}',
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: acento,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: textoPrincipal.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _BotonCantidad(
                  icono: Icons.remove,
                  color: textoPrincipal,
                  onTap: () => carrito.quitar(item.producto),
                ),
                SizedBox(
                  width: 22,
                  child: Text(
                    '${item.cantidad}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bricolageGrotesque(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: textoPrincipal,
                    ),
                  ),
                ),
                _BotonCantidad(
                  icono: Icons.add,
                  color: textoPrincipal,
                  onTap: () => carrito.agregar(item.producto),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonCantidad extends StatelessWidget {
  const _BotonCantidad({required this.icono, required this.color, required this.onTap});

  final IconData icono;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 32,
        height: 34,
        child: Icon(icono, color: color, size: 17),
      ),
    );
  }
}

class _OpcionRecoleccion extends StatelessWidget {
  const _OpcionRecoleccion({
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.seleccionado,
    required this.onTap,
    this.habilitado = true,
  });

  static const Color naviMorado = Color(0xFF5960A1);
  static const Color naviOscuro = Color(0xFF2B2F5E);
  static const Color fondoSuave = Color(0xFFEEF0FB);

  final String titulo;
  final String subtitulo;
  final IconData icono;
  final bool seleccionado;
  final bool habilitado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: habilitado ? 1 : 0.55,
      child: InkWell(
        onTap: habilitado ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: seleccionado ? fondoSuave : const Color(0xFFECEEF5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: seleccionado
                ? const [BoxShadow(color: Color(0x1F5960A1), blurRadius: 8, offset: Offset(0, 3))]
                : const [],
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: seleccionado ? naviMorado : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icono, color: seleccionado ? Colors.white : naviMorado, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: GoogleFonts.bricolageGrotesque(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: naviOscuro,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitulo,
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                seleccionado ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: seleccionado ? naviMorado : Colors.black26,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}