import 'package:flutter/material.dart';

/// Pill pequeño con icono + texto, usado como insignia arriba de los
/// formularios de auth ("RÁPIDO Y DELICIOSO", "PRE-ORDEN EXPRESS", etc.).
class InsigniaNavi extends StatelessWidget {
  const InsigniaNavi({super.key, required this.texto, this.icono = Icons.bolt});

  static const Color naviMorado = Color(0xFF5960A1);
  static const Color fondoSuave = Color(0xFFEEF0FB);

  final String texto;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: fondoSuave, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 14, color: naviMorado),
          const SizedBox(width: 4),
          Text(texto, style: const TextStyle(color: naviMorado, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.4)),
        ],
      ),
    );
  }
}
