import 'package:flutter/material.dart';
import 'package:navi/models/pedido.dart';
import 'package:navi/screens/auth/pantalla_inicio_sesion.dart';
import 'package:navi/screens/main_screen.dart';
import 'package:navi/services/servicio_autenticacion.dart';
import 'package:navi/services/servicio_pedidos.dart';
import 'package:navi/widgets/barra_superior_navi.dart';
import 'package:navi/widgets/campo_etiquetado_navi.dart';
import 'package:navi/widgets/estado_vacio_navi.dart';
import 'package:navi/widgets/insignia_navi.dart';
import 'package:navi/widgets/tarjeta_pedido_navi.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  static const Color naviMorado = Color(0xFF5960A1);
  static const Color fondoSuave = Color(0xFFEEF0FB);

  final ServicioAutenticacion _servicioAuth = ServicioAutenticacion();
  final ServicioPedidos _servicioPedidos = ServicioPedidos();

  bool _cargando = true;
  String? _error;
  PerfilNavi? _perfil;
  List<Pedido> _pedidosRecientes = [];

  @override
  void initState() {
    super.initState();
    _cargarTodo();
  }

  Future<void> _cargarTodo() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final perfil = await _servicioAuth.obtenerPerfil();
      List<Pedido> pedidos = [];
      try {
        pedidos = (await _servicioPedidos.misPedidos()).take(3).toList();
      } catch (_) {
        // El historial es secundario; si falla, el resto del perfil se muestra igual.
      }

      if (!mounted) return;
      setState(() {
        _perfil = perfil;
        _pedidosRecientes = pedidos;
        _cargando = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString().replaceFirst('Exception: ', '');
        _cargando = false;
      });
    }
  }

  Future<void> _editarInformacion() async {
    final perfil = _perfil;
    if (perfil == null) return;

    final nombreController = TextEditingController(text: perfil.name);
    final telefonoController = TextEditingController(text: perfil.phone);

    final guardar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar información'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CampoEtiquetadoNavi(etiqueta: 'Nombre', textoGuia: 'Tu nombre', icono: Icons.person_outline, controller: nombreController),
            const SizedBox(height: 16),
            CampoEtiquetadoNavi(
              etiqueta: 'Teléfono',
              textoGuia: 'Tu teléfono',
              icono: Icons.phone_outlined,
              controller: telefonoController,
              tipoTeclado: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Guardar')),
        ],
      ),
    );

    if (guardar != true || !mounted) return;

    try {
      final actualizado = await _servicioAuth.actualizarPerfil(
        nombre: nombreController.text.trim(),
        telefono: telefonoController.text.trim(),
      );
      if (!mounted) return;
      setState(() => _perfil = actualizado);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Información actualizada')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo actualizar: ${error.toString().replaceFirst('Exception: ', '')}')),
      );
    }
  }

  Future<void> _cambiarContrasena() async {
    final perfil = _perfil;
    if (perfil == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar contraseña'),
        content: Text('Te enviaremos un correo a ${perfil.email} con instrucciones para cambiar tu contraseña.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Enviar correo')),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    try {
      await _servicioAuth.enviarCorreoDeRecuperacion(perfil.email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Revisa tu correo para continuar')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo enviar el correo: ${error.toString().replaceFirst('Exception: ', '')}')),
      );
    }
  }

  Future<void> _cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que quieres cerrar tu sesión?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Cerrar sesión')),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    await _servicioAuth.cerrarSesion();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const PantallaInicioSesion()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: const BarraSuperiorNavi(seccion: 'Perfil'),
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
      return const Center(child: CircularProgressIndicator(color: naviMorado));
    }

    if (_error != null || _perfil == null) {
      return EstadoVacioNavi(
        icono: Icons.wifi_off,
        titulo: _error != null && (_error!.contains('No autorizado') || _error!.contains('Token'))
            ? 'Inicia sesión para ver tu perfil'
            : 'No se pudo cargar tu perfil',
        subtitulo: _error,
        accion: OutlinedButton(onPressed: _cargarTodo, child: const Text('Reintentar')),
      );
    }

    final perfil = _perfil!;
    final inicial = perfil.name.isNotEmpty ? perfil.name[0].toUpperCase() : '?';

    return RefreshIndicator(
      onRefresh: _cargarTodo,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: naviMorado,
                  child: Text(inicial, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                Text(perfil.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                InsigniaNavi(texto: perfil.role.toUpperCase(), icono: Icons.verified_outlined),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: fondoSuave, borderRadius: BorderRadius.circular(16)),
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, color: naviMorado),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Navi Explorer', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        'Acumula puntos con cada compra · Próximamente',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Mi cuenta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextButton.icon(
                onPressed: _editarInformacion,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Editar'),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _FilaCuenta(icono: Icons.person_outline, etiqueta: 'Nombre', valor: perfil.name),
                const Divider(height: 1),
                _FilaCuenta(icono: Icons.mail_outline, etiqueta: 'Correo', valor: perfil.email),
                const Divider(height: 1),
                _FilaCuenta(icono: Icons.phone_outlined, etiqueta: 'Teléfono', valor: perfil.phone.isEmpty ? 'Sin registrar' : perfil.phone),
                const Divider(height: 1),
                InkWell(
                  onTap: _cambiarContrasena,
                  child: const _FilaCuenta(icono: Icons.lock_outline, etiqueta: 'Contraseña', valor: 'Cambiar', esAccion: true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Historial de pedidos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          if (_pedidosRecientes.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Todavía no tienes pedidos.', style: TextStyle(color: Colors.black45)),
            )
          else
            for (final pedido in _pedidosRecientes) ...[
              TarjetaPedidoNavi(pedido: pedido),
              const SizedBox(height: 12),
            ],
          OutlinedButton(
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const MainNavigationScreen(indiceInicial: 2)),
              (route) => false,
            ),
            child: const Text('Ver todos mis pedidos'),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _cerrarSesion,
              style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent, side: const BorderSide(color: Colors.redAccent)),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaCuenta extends StatelessWidget {
  const _FilaCuenta({required this.icono, required this.etiqueta, required this.valor, this.esAccion = false});

  static const Color naviMorado = Color(0xFF5960A1);

  final IconData icono;
  final String etiqueta;
  final String valor;
  final bool esAccion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icono, size: 20, color: Colors.black45),
          const SizedBox(width: 12),
          Expanded(child: Text(etiqueta, style: const TextStyle(fontSize: 14))),
          Text(
            valor,
            style: TextStyle(fontSize: 14, color: esAccion ? naviMorado : Colors.black54, fontWeight: esAccion ? FontWeight.bold : FontWeight.normal),
          ),
          if (esAccion) ...[const SizedBox(width: 4), const Icon(Icons.chevron_right, size: 18, color: naviMorado)],
        ],
      ),
    );
  }
}
