import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navi/models/pedido.dart';

/// Tarjeta de un pedido con su línea de tiempo de estado, reutilizada en
/// Pedidos (lista completa) y Perfil (historial reciente). El punto del
/// estado actual da pequeños rebotes y brilla un poco más en cada uno.
class TarjetaPedidoNavi extends StatelessWidget {
  const TarjetaPedidoNavi({super.key, required this.pedido, this.variante = 0});

  static const Color naviMorado = Color(0xFF5960A1);

  // fondo, texto principal, texto secundario, acento (mismas variantes del menú)
  static const List<List<Color>> _paletas = [
    [Color(0xFF5960A1), Colors.white, Color(0xFFE3E5F7), Color(0xFFF3E8E1)],
    [Color(0xFFF3E8E1), Color(0xFF2B2F5E), Color(0xFF7A5C4B), Color(0xFFAC8572)],
    [Color(0xFF2B2F5E), Colors.white, Color(0xFFD9DBF2), Color(0xFFE3C7B6)],
    [Color(0xFFD9DCF5), Color(0xFF2B2F5E), Color(0xFF4A4F8C), Color(0xFF5960A1)],
  ];

  final Pedido pedido;
  final int variante;

  @override
  Widget build(BuildContext context) {
    final paleta = _paletas[variante % _paletas.length];
    final fondo = paleta[0];
    final textoPrincipal = paleta[1];
    final textoSecundario = paleta[2];
    final acento = paleta[3];

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(color: fondo.withValues(alpha: 0.4), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: textoSecundario, width: 1.2),
            ),
            child: Text(
              pedido.estado,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textoSecundario,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  pedido.folio.isEmpty ? 'Pedido' : 'Pedido ${pedido.folio}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                    height: 1.05,
                    color: textoPrincipal,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\$${pedido.total.toStringAsFixed(2)}',
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: acento,
                ),
              ),
            ],
          ),
          if (pedido.resumenProductos.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              pedido.resumenProductos,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: textoSecundario,
                height: 1.35,
              ),
            ),
          ],
          const SizedBox(height: 26),
          _LineaDeTiempoPedido(
            estado: pedido.estado,
            textoPrincipal: textoPrincipal,
            textoSecundario: textoSecundario,
            acento: acento,
          ),
        ],
      ),
    );
  }
}

class _LineaDeTiempoPedido extends StatelessWidget {
  const _LineaDeTiempoPedido({
    required this.estado,
    required this.textoPrincipal,
    required this.textoSecundario,
    required this.acento,
  });

  static const List<String> _pasos = ['Nuevo', 'En preparación', 'Listo', 'Recogido'];
  static const double _tamanoCaja = 20;

  final String estado;
  final Color textoPrincipal;
  final Color textoSecundario;
  final Color acento;

  @override
  Widget build(BuildContext context) {
    if (estado == 'Cancelado') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Pedido cancelado',
              style: GoogleFonts.bricolageGrotesque(
                color: Colors.redAccent,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    final indiceActual = _pasos.indexOf(estado);
    final apagado = textoPrincipal.withValues(alpha: 0.28);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _pasos.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 3,
                margin: const EdgeInsets.only(top: (_tamanoCaja - 3) / 2),
                decoration: BoxDecoration(
                  color: i <= indiceActual ? textoPrincipal : apagado,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          Column(
            children: [
              SizedBox(
                width: _tamanoCaja,
                height: _tamanoCaja,
                child: Center(
                  child: i == indiceActual
                      ? _PuntoEstado(
                          // Rebota solo mientras el pedido sigue en camino.
                          rebotar: i < _pasos.length - 1,
                          color: acento,
                        )
                      : Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i < indiceActual ? textoPrincipal : apagado,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _pasos[i],
                textAlign: TextAlign.center,
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 11,
                  fontWeight: i == indiceActual ? FontWeight.w800 : FontWeight.w500,
                  color: i <= indiceActual ? textoPrincipal : textoSecundario.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Punto del estado actual: da 3 rebotes pequeños (cada uno un poco más
/// bajo) y en cada rebote su brillo es más fuerte; luego descansa y repite.
class _PuntoEstado extends StatefulWidget {
  const _PuntoEstado({required this.rebotar, required this.color});

  final bool rebotar;
  final Color color;

  @override
  State<_PuntoEstado> createState() => _PuntoEstadoState();
}

class _PuntoEstadoState extends State<_PuntoEstado> with SingleTickerProviderStateMixin {
  static const List<double> _alturas = [11, 8, 5];
  static const List<double> _brillos = [0.4, 0.7, 1.0];
  static const double _brilloBase = 0.2;

  late final AnimationController _controlador = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );

  @override
  void initState() {
    super.initState();
    if (widget.rebotar) _controlador.repeat();
  }

  @override
  void didUpdateWidget(covariant _PuntoEstado anterior) {
    super.didUpdateWidget(anterior);
    if (widget.rebotar && !_controlador.isAnimating) {
      _controlador.repeat();
    } else if (!widget.rebotar && _controlador.isAnimating) {
      _controlador.stop();
      _controlador.value = 0;
    }
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controlador,
      builder: (context, _) {
        final t = _controlador.value;
        double alto = 0;
        double brillo = _brilloBase;

        // Los 3 rebotes ocupan el 60% del ciclo; el resto es descanso.
        if (widget.rebotar && t < 0.6) {
          final k = (t / 0.2).floor().clamp(0, 2);
          final local = (t - k * 0.2) / 0.2;
          final salto = math.sin(math.pi * local);
          alto = salto * _alturas[k];
          brillo = _brilloBase + (_brillos[k] - _brilloBase) * salto;
        }

        return Transform.translate(
          offset: Offset(0, -alto),
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: brillo),
                  blurRadius: 6 + 20 * brillo,
                  spreadRadius: 1 + 6 * brillo,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}