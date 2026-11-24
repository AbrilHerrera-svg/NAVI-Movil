import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navi/screens/auth/pantalla_registro.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color primaryColor = Color(0xFF5960A1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              Container(
                width: 160,
                height: 160,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(28),
                child: SvgPicture.asset(
                  'assets/images/navi-cohete.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ), 
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ), // BoxDecoration
                child: const Text(
                  'EST. 2025',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ), 
                ), 
              ),
              const SizedBox(height: 24),
              const Text(
                'NAVI',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tú café sin esperas.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Móvil · Pedidos Express',
                      style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 4),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PantallaRegistro(),
                      ),
                    ); // Navigator.pushReplacement
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ), 
                  ), // ElevatedButton.styleFrom
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Comenzar',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ], // Row
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Versión v1.0 · Acceso público y membresías',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),
            ], // Column
          ),
        ),
      ),
    );
  }
}