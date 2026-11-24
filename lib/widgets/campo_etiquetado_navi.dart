import 'package:flutter/material.dart';

/// Campo de texto con su etiqueta arriba, con el estilo de fondo suave que
/// usan las pantallas de autenticación de NAVI.
class CampoEtiquetadoNavi extends StatelessWidget {
  const CampoEtiquetadoNavi({
    super.key,
    required this.etiqueta,
    required this.textoGuia,
    required this.icono,
    this.controller,
    this.etiquetaFinal,
    this.ocultarTexto = false,
    this.tipoTeclado,
    this.iconoFinal,
  });

  static const Color fondoSuave = Color(0xFFEEF0FB);

  final String etiqueta;
  final String textoGuia;
  final IconData icono;
  final TextEditingController? controller;
  final Widget? etiquetaFinal;
  final bool ocultarTexto;
  final TextInputType? tipoTeclado;
  final Widget? iconoFinal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(etiqueta, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ?etiquetaFinal,
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: ocultarTexto,
          keyboardType: tipoTeclado,
          decoration: InputDecoration(
            hintText: textoGuia,
            prefixIcon: Icon(icono, color: Colors.black45, size: 20),
            suffixIcon: iconoFinal,
            filled: true,
            fillColor: fondoSuave,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }
}
