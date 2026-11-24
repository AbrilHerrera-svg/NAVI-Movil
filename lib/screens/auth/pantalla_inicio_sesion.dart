import 'package:flutter/material.dart';
import 'package:navi/screens/auth/pantalla_registro.dart';
import 'package:navi/services/servicio_autenticacion.dart';
import 'package:navi/widgets/barra_superior_autenticacion.dart';
import 'package:navi/widgets/campo_etiquetado_navi.dart';
import 'package:navi/widgets/insignia_navi.dart';
import 'package:navi/widgets/boton_primario_navi.dart';
import 'package:navi/widgets/banner_promocional_navi.dart';
import 'package:navi/widgets/logotipo_navi.dart';

class PantallaInicioSesion extends StatefulWidget {
  const PantallaInicioSesion({super.key});

  @override
  State<PantallaInicioSesion> createState() => _PantallaInicioSesionState();
}

class _PantallaInicioSesionState extends State<PantallaInicioSesion> {
  static const Color naviMorado = Color(0xFF5960A1);

  final ServicioAutenticacion _servicioAuth = ServicioAutenticacion();

  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _ocultar = true;
  bool _cargando = false;
  String? _error;

  @override
  void dispose() {
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      await _servicioAuth.iniciarSesion(email: _correoController.text.trim(), password: _passwordController.text);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      setState(() => _error = error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _continuarComoInvitado() => Navigator.pushReplacementNamed(context, '/home');

  void _irARegistro() =>
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PantallaRegistro()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                const BarraSuperiorAutenticacion(centro: InsigniaNavi(texto: 'PRE-ORDEN EXPRESS', icono: Icons.circle)),
                const SizedBox(height: 24),
                const Center(child: LogotipoNavi(tamanoIcono: 48, tamanoTexto: 26)),
                const SizedBox(height: 8),
                const Text('¡Hola de nuevo!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: naviMorado)),
                const SizedBox(height: 8),
                const Text(
                  'Ingresa a tu cuenta para ordenar y ver tus pedidos',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 28),
                CampoEtiquetadoNavi(
                  etiqueta: 'Correo electrónico',
                  textoGuia: 'tu@correo.com',
                  icono: Icons.mail_outline,
                  controller: _correoController,
                  tipoTeclado: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                CampoEtiquetadoNavi(
                  etiqueta: 'Contraseña',
                  textoGuia: 'Tu contraseña',
                  icono: Icons.lock_outline,
                  controller: _passwordController,
                  ocultarTexto: _ocultar,
                  etiquetaFinal: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                    child: const Text('¿Olvidaste tu contraseña?',
                        style: TextStyle(color: naviMorado, fontSize: 12, decoration: TextDecoration.underline)),
                  ),
                  iconoFinal: IconButton(
                    icon: Icon(_ocultar ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                    onPressed: () => setState(() => _ocultar = !_ocultar),
                  ),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(_error!, style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 20),
                BotonPrimarioNavi(texto: 'Iniciar sesión', cargando: _cargando, onPressed: _iniciarSesion),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('O INGRESA CON', style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _cargando
                        ? null
                        : () => setState(() => _error = 'Inicio de sesión con Google próximamente'),
                    icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.red),
                    label: const Text('Google', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(14),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const BannerPromocionalNavi(
                  icono: Icons.bolt,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ahorra hasta 15 minutos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('Tus bebidas y snacks te esperan listos en la barra.', style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _cargando ? null : _continuarComoInvitado,
                  child: const Text('Continuar como invitado', style: TextStyle(color: Colors.black45)),
                ),
                EnlaceCambioAutenticacion(pregunta: '¿No tienes cuenta?', accion: 'Regístrate gratis', onTap: _irARegistro),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
