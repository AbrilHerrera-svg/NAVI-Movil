import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:navi/firebase_options.dart';
import 'package:navi/screens/splash_screen.dart';
import 'package:navi/screens/carrito/carrito_screen.dart';
import 'package:navi/screens/auth/pantalla_inicio_sesion.dart';
import 'package:navi/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        '/login': (context) => const PantallaInicioSesion(),
        '/home': (context) => const MainNavigationScreen(),
        '/carrito': (context) => const CarritoScreen(),
      },
    );
  }
}