import 'package:flutter/material.dart';

/// Botón primario morado con icono de flecha y estado de carga, compartido
/// entre las pantallas de registro e inicio de sesión.
class BotonPrimarioNavi extends StatelessWidget {
  const BotonPrimarioNavi({super.key, required this.texto, required this.cargando, required this.onPressed});

  static const Color naviMorado = Color(0xFF5960A1);

  final String texto;
  final bool cargando;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: cargando ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: naviMorado,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: cargando
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(texto, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
      ),
    );
  }
}
