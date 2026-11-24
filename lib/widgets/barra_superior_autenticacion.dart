import 'package:flutter/material.dart';

/// Barra superior de las pantallas de auth: botón de regreso a la izquierda
/// y un contenido (insignia/logo) centrado.
class BarraSuperiorAutenticacion extends StatelessWidget {
  const BarraSuperiorAutenticacion({super.key, required this.centro});

  static const Color fondoSuave = Color(0xFFEEF0FB);

  final Widget centro;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          style: IconButton.styleFrom(backgroundColor: fondoSuave),
        ),
        Expanded(child: Center(child: centro)),
        const SizedBox(width: 48),
      ],
    );
  }
}

/// Línea inferior tipo "¿Ya tienes una cuenta? Iniciar sesión".
class EnlaceCambioAutenticacion extends StatelessWidget {
  const EnlaceCambioAutenticacion({super.key, required this.pregunta, required this.accion, required this.onTap});

  static const Color naviMorado = Color(0xFF5960A1);

  final String pregunta;
  final String accion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Text.rich(
          TextSpan(
            style: const TextStyle(color: Colors.black54, fontSize: 14),
            children: [
              TextSpan(text: '$pregunta '),
              TextSpan(text: accion, style: const TextStyle(color: naviMorado, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
