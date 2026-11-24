import 'package:flutter/material.dart';
import 'package:navi/models/producto.dart';
import 'package:navi/services/carrito_service.dart';
import 'package:navi/widgets/boton_primario_navi.dart';
import 'package:navi/widgets/insignia_navi.dart';
import 'package:navi/widgets/selector_cantidad_navi.dart';

class DetalleProductoScreen extends StatefulWidget {
  final Producto producto;

  const DetalleProductoScreen({super.key, required this.producto});

  @override
  State<DetalleProductoScreen> createState() => _DetalleProductoScreenState();
}

class _DetalleProductoScreenState extends State<DetalleProductoScreen> {
  static const Color naviMorado = Color(0xFF5960A1);
  static const Color fondoSuave = Color(0xFFEEF0FB);

  int _cantidad = 1;

  void _cambiarCantidad(int delta) {
    setState(() => _cantidad = (_cantidad + delta).clamp(1, 20));
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
    final total = producto.precio * _cantidad;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 220,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: fondoSuave,
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                            ),
                            child: Icon(producto.icono, size: 96, color: naviMorado),
                          ),
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: const Icon(Icons.arrow_back, size: 20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (producto.etiqueta.isNotEmpty) ...[
                              InsigniaNavi(texto: producto.etiqueta),
                              const SizedBox(height: 12),
                            ],
                            Text(
                              producto.nombre,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              producto.categoria,
                              style: const TextStyle(fontSize: 13, color: naviMorado, fontWeight: FontWeight.w600),
                            ),
                            if (producto.descripcion.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                producto.descripcion,
                                style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
                              ),
                            ],
                            const SizedBox(height: 20),
                            const Divider(height: 1),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Cantidad', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                SelectorCantidadNavi(
                                  cantidad: _cantidad,
                                  onDecrementar: () => _cambiarCantidad(-1),
                                  onIncrementar: () => _cambiarCantidad(1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Color(0x1A5960A1), blurRadius: 12, offset: Offset(0, -2))],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total', style: TextStyle(fontSize: 12, color: Colors.black54)),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: naviMorado, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: BotonPrimarioNavi(
                          texto: 'Agregar al carrito',
                          cargando: false,
                          onPressed: () {
                            CarritoService().agregar(producto, cantidad: _cantidad);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${producto.nombre} agregado al carrito')),
                            );
                            Navigator.pop(context);
                          },
                        ),
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
