import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navi/models/producto.dart';

/// Tarjeta compacta de producto para la pantalla de Menú: etiqueta,
/// nombre, descripción y precio a la izquierda; icono decorado y botón
/// de agregar alineados a la derecha.
class TarjetaProductoMenu extends StatelessWidget {
  const TarjetaProductoMenu({
    super.key,
    required this.producto,
    required this.onAgregar,
    this.variante = 0,
  });

  static const Color naviMorado = Color(0xFF5960A1);
  static const Color naviCafe = Color(0xFFAC8572);
  static const Color naviOscuro = Color(0xFF2B2F5E);

  // fondo, texto principal, texto secundario, acento (precio/botón)
  static const List<List<Color>> _paletas = [
    [Color(0xFF5960A1), Colors.white, Color(0xFFE3E5F7), Color(0xFFF3E8E1)],
    [Color(0xFFF3E8E1), Color(0xFF2B2F5E), Color(0xFF7A5C4B), Color(0xFFAC8572)],
    [Color(0xFF2B2F5E), Colors.white, Color(0xFFD9DBF2), Color(0xFFE3C7B6)],
    [Color(0xFFD9DCF5), Color(0xFF2B2F5E), Color(0xFF4A4F8C), Color(0xFF5960A1)],
  ];

  final Producto producto;
  final VoidCallback onAgregar;
  final int variante;

  @override
  Widget build(BuildContext context) {
    final paleta = _paletas[variante % _paletas.length];
    final fondo = paleta[0];
    final textoPrincipal = paleta[1];
    final textoSecundario = paleta[2];
    final acento = paleta[3];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: fondo.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fila superior: Textos a la izquierda + Icono pequeño a la derecha
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (producto.etiqueta.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: textoSecundario.withValues(alpha: 0.8),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          producto.etiqueta,
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: textoSecundario,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    Text(
                      producto.nombre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        height: 1.1,
                        color: textoPrincipal,
                      ),
                    ),
                    if (producto.descripcion.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        producto.descripcion,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: textoSecundario,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Contenedor del icono casi del tamaño del botón "+"
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      textoPrincipal.withValues(alpha: 0.24),
                      textoPrincipal.withValues(alpha: 0.10),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: textoPrincipal.withValues(alpha: 0.22),
                    width: 1,
                  ),
                ),
                child: Icon(
                  producto.icono,
                  color: textoPrincipal,
                  size: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Fila inferior: Precio a la izquierda + Botón "+" a la derecha
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '\$${producto.precio.toStringAsFixed(2)}',
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: acento,
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onAgregar,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: textoPrincipal,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.add_rounded, color: fondo, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}