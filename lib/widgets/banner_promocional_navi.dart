import 'package:flutter/material.dart';

/// Banner con fondo suave + icono, usado para los avisos promocionales de
/// las pantallas de auth ("Recibe $50 MXN...", "Ahorra hasta 15 minutos...").
class BannerPromocionalNavi extends StatelessWidget {
  const BannerPromocionalNavi({super.key, required this.icono, required this.child});

  static const Color naviMorado = Color(0xFF5960A1);
  static const Color fondoSuave = Color(0xFFEEF0FB);

  final IconData icono;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: fondoSuave, borderRadius: BorderRadius.circular(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: naviMorado),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}
