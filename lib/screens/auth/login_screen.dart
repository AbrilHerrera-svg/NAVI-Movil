import 'package:flutter/material.dart';
import 'package:navi/services/auth_service.dart';
import 'package:navi/widgets/navi_wordmark.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color naviMorado = Color(0xFF5960A1);
  static const Color naviCafe = Color(0xFFAC8572);

  final AuthService _authService = AuthService();

  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _telefonoController = TextEditingController();

  bool _esRegistro = false;
  bool _ocultar = true;
  bool _cargando = false;
  String? _error;

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Widget _etiqueta(String texto) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Text(texto, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      );

  InputDecoration _decoracion(String hint, Widget icono) => InputDecoration(
        hintText: hint,
        suffixIcon: icono,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );

  Future<void> _entrar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      if (_esRegistro) {
        await _authService.registrar(
          nombre: _nombreController.text.trim(),
          email: _correoController.text.trim(),
          password: _passwordController.text,
          telefono: _telefonoController.text.trim(),
        );
      } else {
        await _authService.iniciarSesion(
          email: _correoController.text.trim(),
          password: _passwordController.text,
        );
      }

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      setState(() => _error = error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _entrarComoInvitado() => Navigator.pushReplacementNamed(context, '/home');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(_esRegistro ? 'Crear cuenta' : 'Iniciar sesión')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const NaviWordmark(),
                const SizedBox(height: 8),
                const Text(
                  'Pide y reserva desde tu celular',
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const Divider(height: 32),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('Iniciar sesión')),
                    ButtonSegment(value: true, label: Text('Crear cuenta')),
                  ],
                  selected: {_esRegistro},
                  showSelectedIcon: false,
                  onSelectionChanged: (valor) => setState(() {
                    _esRegistro = valor.first;
                    _error = null;
                  }),
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: naviMorado,
                    selectedForegroundColor: Colors.white,
                  ),
                ),
                if (_esRegistro) ...[
                  _etiqueta('NOMBRE'),
                  TextField(
                    controller: _nombreController,
                    decoration: _decoracion('Tu nombre', const Icon(Icons.person_outline)),
                  ),
                  _etiqueta('TELÉFONO (OPCIONAL)'),
                  TextField(
                    controller: _telefonoController,
                    keyboardType: TextInputType.phone,
                    decoration: _decoracion('10 dígitos', const Icon(Icons.phone_outlined)),
                  ),
                ],
                _etiqueta('CORREO ELECTRÓNICO'),
                TextField(
                  controller: _correoController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _decoracion('tucorreo@ejemplo.com', const Icon(Icons.mail_outline)),
                ),
                _etiqueta('CONTRASEÑA'),
                TextField(
                  controller: _passwordController,
                  obscureText: _ocultar,
                  decoration: _decoracion(
                    'Tu contraseña',
                    IconButton(
                      icon: Icon(_ocultar ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      onPressed: () => setState(() => _ocultar = !_ocultar),
                    ),
                  ),
                ),
                if (!_esRegistro)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: naviMorado, decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(_error!, style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _cargando ? null : _entrar,
                  style: FilledButton.styleFrom(
                    backgroundColor: naviMorado,
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _cargando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(_esRegistro ? 'Crear cuenta' : 'Entrar'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _cargando ? null : _entrarComoInvitado,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: naviCafe,
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Continuar como invitado'),
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, size: 14, color: Colors.black38),
                    SizedBox(width: 4),
                    Text('Tus datos están protegidos', style: TextStyle(fontSize: 12, color: Colors.black38)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
