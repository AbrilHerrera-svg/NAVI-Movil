import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color naviMorado = Color(0xFF5960A1);
  static const Color naviCafe = Color(0xFFAC8572);

  bool _esRegistro = false;
  bool _ocultar = true;

  Widget _etiqueta(String texto) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Text(texto, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      );

  InputDecoration _decoracion(String hint, Widget icono) => InputDecoration(
        hintText: hint,
        suffixIcon: icono,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );

  void _entrar() => Navigator.pushReplacementNamed(context, '/home');

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
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: naviMorado,
                    child: Icon(Icons.rocket_launch_outlined, color: Colors.white),
                  ),
                  title: Text.rich(
                    TextSpan(
                      style: TextStyle(fontWeight: FontWeight.w900, color: naviMorado),
                      children: [
                        TextSpan(text: 'N'),
                        TextSpan(text: 'A', style: TextStyle(color: naviCafe)),
                        TextSpan(text: 'VI'),
                      ],
                    ),
                  ),
                  subtitle: Text('Pide y reserva desde tu celular'),
                ),
                const Divider(height: 32),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('Iniciar sesión')),
                    ButtonSegment(value: true, label: Text('Crear cuenta')),
                  ],
                  selected: {_esRegistro},
                  showSelectedIcon: false,
                  onSelectionChanged: (valor) => setState(() => _esRegistro = valor.first),
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: naviMorado,
                    selectedForegroundColor: Colors.white,
                  ),
                ),
                if (_esRegistro) ...[
                  _etiqueta('NOMBRE'),
                  TextField(decoration: _decoracion('Tu nombre', const Icon(Icons.person_outline))),
                ],
                _etiqueta('CORREO ELECTRÓNICO'),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: _decoracion('tucorreo@ejemplo.com', const Icon(Icons.mail_outline)),
                ),
                _etiqueta('CONTRASEÑA'),
                TextField(
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
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _entrar,
                  style: FilledButton.styleFrom(
                    backgroundColor: naviMorado,
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(_esRegistro ? 'Crear cuenta' : 'Entrar'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _entrar,
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