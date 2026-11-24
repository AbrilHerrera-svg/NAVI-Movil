import 'package:flutter/material.dart';

/// Tarjeta seleccionable tipo radio (icono + título + subtítulo), usada para
/// elegir horario de recolección y método de pago.
class OpcionSeleccionableNavi extends StatelessWidget {
  const OpcionSeleccionableNavi({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.seleccionado,
    required this.onTap,
    this.habilitado = true,
  });

  static const Color naviMorado = Color(0xFF5960A1);
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
      opacity: habilitado ? 1 : 0.5,
      child: InkWell(
        onTap: habilitado ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: seleccionado ? fondoSuave : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: seleccionado ? naviMorado : const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Icon(icono, color: naviMorado, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(subtitulo, style: const TextStyle(fontSize: 12, color: Colors.black54)),
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
