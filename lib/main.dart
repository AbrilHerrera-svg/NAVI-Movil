import 'package:flutter/material.dart';
import 'package:navi/screens/splash_screen.dart';
import 'package:navi/screens/carrito/carrito_screen.dart';
import 'package:navi/screens/auth/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NaviApp());
}

class NaviApp extends StatelessWidget {
  const NaviApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navi - Restaurante',
      debugShowCheckedModeBanner: false,
      
      
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF5722), 
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: const Color(0xFFFF5722).withValues(alpha: 0.15),
          backgroundColor: Colors.white,
          elevation: 4,
        ),
      ),

      home: const SplashScreen(),

      routes: {
        '/login': (context) => const LoginScreen(),
        '/carrito': (context) => const CarritoScreen(),
      },
    );
  }
}