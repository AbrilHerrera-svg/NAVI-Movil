import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navi/models/pedido.dart';
import 'package:navi/services/servicio_pedidos.dart';
import 'package:navi/widgets/barra_superior_navi.dart';
import 'package:navi/widgets/estado_vacio_navi.dart';
import 'package:navi/widgets/tarjeta_pedido_navi.dart';

/// Mockup 9: seguimiento de pedidos reales del cliente (GET
/// /api/orders/mine), con línea de tiempo por estado. Se actualiza sola
/// cada 20s mientras la pantalla está abierta, porque el cliente de
/// Firestore está bloqueado y solo el backend puede dar el estado al día.
class PantallaPedidos extends StatefulWidget {
  const PantallaPedidos({super.key});

  @override
  State<PantallaPedidos> createState() => _PantallaPedidosState();
}

class _PantallaPedidosState extends State<PantallaPedidos> {
  static const Color _naviCafe = Color(0xFFAC8572);
  static const Color _naviOscuro = Color(0xFF2B2F5E);

  final ServicioPedidos _servicioPedidos = ServicioPedidos();

  bool _cargando = true;
  String? _error;
  List<Pedido> _pedidos = [];
  Timer? _temporizador;

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
    _temporizador = Timer.periodic(const Duration(seconds: 20), (_) => _cargarPedidos(mostrarCarga: false));
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    super.dispose();
  }

  Future<void> _cargarPedidos({bool mostrarCarga = true}) async {
    if (mostrarCarga) {
      setState(() {
        _cargando = true;
        _error = null;
      });
    }

    try {
      final pedidos = await _servicioPedidos.misPedidos();
      if (!mounted) return;
      setState(() {
        _pedidos = pedidos;
        _cargando = false;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString().replaceFirst('Exception: ', '');
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: const BarraSuperiorNavi(seccion: 'Pedidos'),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: _construirContenido(),
        ),
      ),
    );
  }

  Widget _construirContenido() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF5960A1)));
    }

    if (_error != null) {
      return EstadoVacioNavi(
        icono: Icons.wifi_off,
        titulo: _error!.contains('No autorizado') || _error!.contains('Token')
            ? 'Inicia sesión para ver tus pedidos'
            : 'No se pudieron cargar tus pedidos',
        subtitulo: _error,
        accion: OutlinedButton(onPressed: _cargarPedidos, child: const Text('Reintentar')),
      );
    }

    if (_pedidos.isEmpty) {
      return _construirVacio();
    }

    return RefreshIndicator(
      onRefresh: _cargarPedidos,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: _pedidos.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return _construirEncabezado();
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TarjetaPedidoNavi(pedido: _pedidos[index - 1], variante: index - 1),
          );
        },
      ),
    );
  }

  Widget _construirEncabezado() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SEGUIMIENTO',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.4,
              color: _naviCafe,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Tus pedidos',
            style: GoogleFonts.bricolageGrotesque(
              fontSize: 44,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              height: 1.05,
              color: _naviOscuro,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _pedidos.length == 1 ? '1 pedido, se actualiza solo' : '${_pedidos.length} pedidos, se actualizan solos',
            style: GoogleFonts.hankenGrotesk(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _construirVacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: Color(0xFFEEF0FB),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Color(0x335960A1), blurRadius: 20, offset: Offset(0, 8))],
              ),
              child: const Icon(Icons.receipt_long_outlined, size: 48, color: Color(0xFF5960A1)),
            ),
            const SizedBox(height: 24),
            Text(
              'Todavía no tienes pedidos',
              textAlign: TextAlign.center,
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
                height: 1.1,
                color: _naviOscuro,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cuando hagas tu primer pedido, aquí verás su estado y tu historial.',
              textAlign: TextAlign.center,
              style: GoogleFonts.hankenGrotesk(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}