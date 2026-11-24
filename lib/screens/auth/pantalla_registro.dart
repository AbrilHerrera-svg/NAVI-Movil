import 'package:flutter/material.dart';
import 'package:navi/screens/auth/pantalla_inicio_sesion.dart';
import 'package:navi/services/servicio_autenticacion.dart';
import 'package:navi/widgets/barra_superior_autenticacion.dart';
import 'package:navi/widgets/campo_etiquetado_navi.dart';
import 'package:navi/widgets/insignia_navi.dart';
import 'package:navi/widgets/boton_primario_navi.dart';
import 'package:navi/widgets/banner_promocional_navi.dart';
import 'package:navi/widgets/logotipo_navi.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  static const Color naviMorado = Color(0xFF5960A1);

  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();

  final ServicioAutenticacion _servicioAuth = ServicioAutenticacion();

  bool _ocultarPassword = true;
  bool _aceptaTerminos = false;
  bool _cargando = false;
  String? _error;

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _crearCuenta() async {
    if (!_aceptaTerminos) {
      setState(() => _error = 'Acepta los Términos y Condiciones para continuar');
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      await _servicioAuth.registrar(
        nombre: _nombreController.text.trim(),
        email: _correoController.text.trim(),
        password: _passwordController.text,
        telefono: _telefonoController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      setState(() => _error = error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _irALogin() =>
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PantallaInicioSesion()));

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
                BarraSuperiorAutenticacion(centro: const LogotipoNavi(tamanoIcono: 26, tamanoTexto: 18)),
                const SizedBox(height: 24),
                const InsigniaNavi(texto: 'RÁPIDO Y DELICIOSO'),
                const SizedBox(height: 16),
                const Text('Crear cuenta', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text(
                  'Regístrate para ordenar tus bebidas y alimentos favoritos en minutos.',
                  style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 24),
                CampoEtiquetadoNavi(
                  etiqueta: 'Nombre completo',
                  textoGuia: 'Ej. Sofía Hernández',
                  icono: Icons.person_outline,
                  controller: _nombreController,
                ),
                const SizedBox(height: 16),
                CampoEtiquetadoNavi(
                  etiqueta: 'Correo electrónico',
                  textoGuia: 'nombre@correo.com',
                  icono: Icons.mail_outline,
                  controller: _correoController,
                  tipoTeclado: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                const Text('Teléfono celular', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: CampoEtiquetadoNavi.fondoSuave,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('🇲🇽 +52', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CampoEtiquetadoNavi(
                        etiqueta: '',
                        textoGuia: '(55) 1234-5678',
                        icono: Icons.phone_outlined,
                        controller: _telefonoController,
                        tipoTeclado: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CampoEtiquetadoNavi(
                  etiqueta: 'Contraseña',
                  textoGuia: 'Tu contraseña',
                  icono: Icons.lock_outline,
                  controller: _passwordController,
                  ocultarTexto: _ocultarPassword,
                  etiquetaFinal: const Text('Mínimo 8 caracteres', style: TextStyle(fontSize: 11, color: Colors.black45)),
                  iconoFinal: IconButton(
                    icon: Icon(_ocultarPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                    onPressed: () => setState(() => _ocultarPassword = !_ocultarPassword),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _aceptaTerminos,
                      onChanged: (valor) => setState(() => _aceptaTerminos = valor ?? false),
                      activeColor: naviMorado,
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(color: Colors.black87, fontSize: 13),
                            children: [
                              TextSpan(text: 'Acepto los '),
                              TextSpan(
                                text: 'Términos y Condiciones',
                                style: TextStyle(color: naviMorado, decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
                              ),
                              TextSpan(text: ' y el '),
                              TextSpan(
                                text: 'Aviso de Privacidad',
                                style: TextStyle(color: naviMorado, decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
                              ),
                              TextSpan(text: ' de Navi.'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_error!, style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 8),
                BotonPrimarioNavi(texto: 'Crear cuenta', cargando: _cargando, onPressed: _crearCuenta),
                const SizedBox(height: 16),
                const BannerPromocionalNavi(
                  icono: Icons.local_cafe_outlined,
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                      children: [
                        TextSpan(text: '¡Recibe '),
                        TextSpan(text: r'$50 MXN', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' de regalo en tu primer pedido de café o bocadillos!'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                EnlaceCambioAutenticacion(pregunta: '¿Ya tienes una cuenta?', accion: 'Iniciar sesión', onTap: _irALogin),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
