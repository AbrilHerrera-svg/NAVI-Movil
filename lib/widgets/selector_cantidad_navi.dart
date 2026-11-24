import 'package:flutter/material.dart';

/// Stepper de cantidad (– N +) en un pill morado claro, reutilizado en el
/// detalle de producto y en el carrito.
class SelectorCantidadNavi extends StatelessWidget {
  const SelectorCantidadNavi({
    super.key,
    required this.cantidad,
    required this.onDecrementar,
    required this.onIncrementar,
  });

  static const Color naviMorado = Color(0xFF5960A1);
  static const Color fondoSuave = Color(0xFFEEF0FB);

  final int cantidad;
  final VoidCallback onDecrementar;
  final VoidCallback onIncrementar;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: fondoSuave, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onDecrementar,
            icon: const Icon(Icons.remove, color: naviMorado, size: 18),
          ),
          SizedBox(
            width: 24,
            child: Text(
              '$cantidad',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          IconButton(
            onPressed: onIncrementar,
            icon: const Icon(Icons.add, color: naviMorado, size: 18),
          ),
        ],
      ),
    );
  }
}
