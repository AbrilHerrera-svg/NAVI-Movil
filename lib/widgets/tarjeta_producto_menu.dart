import 'package:flutter/material.dart';
import 'package:navi/models/producto.dart';

/// Tarjeta horizontal de producto para la pantalla de Menú: etiqueta,
/// nombre, descripción y precio a la izquierda; imagen/icono y botón de
/// agregar a la derecha.
class TarjetaProductoMenu extends StatelessWidget {
  const TarjetaProductoMenu({super.key, required this.producto, required this.onAgregar});

  static const Color naviMorado = Color(0xFF5960A1);
  static const Color fondoSuave = Color(0xFFEEF0FB);

  final Producto producto;
  final VoidCallback onAgregar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x0D0F172A), blurRadius: 3, offset: Offset(0, 1))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (producto.etiqueta.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: fondoSuave, borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      producto.etiqueta,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: naviMorado),
                    ),
                  ),
                const SizedBox(height: 6),
                Text(producto.nombre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                if (producto.descripcion.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    producto.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.3),
                  ),
                ],
                const SizedBox(height: 10),
                Text(
                  '\$${producto.precio.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: fondoSuave, borderRadius: BorderRadius.circular(10)),
                child: Icon(producto.icono, color: naviMorado, size: 32),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: onAgregar,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(color: naviMorado, shape: BoxShape.circle),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
