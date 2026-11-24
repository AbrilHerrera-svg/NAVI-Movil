import 'dart:async';

import 'package:flutter/material.dart';
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
      return const EstadoVacioNavi(
        icono: Icons.receipt_long_outlined,
        titulo: 'Todavía no tienes pedidos',
        subtitulo: 'Cuando hagas tu primer pedido, aquí verás su estado y tu historial.',
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarPedidos,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _pedidos.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => TarjetaPedidoNavi(pedido: _pedidos[index]),
      ),
    );
  }
}
