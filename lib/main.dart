import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
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
          seedColor: const Color(0xFF5960A1),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF8FF),
        textTheme: GoogleFonts.interTextTheme().copyWith(
          displayLarge: GoogleFonts.montserrat(fontWeight: FontWeight.w900),
          displayMedium: GoogleFonts.montserrat(fontWeight: FontWeight.w900),
          displaySmall: GoogleFonts.montserrat(fontWeight: FontWeight.w800),
          headlineLarge: GoogleFonts.montserrat(fontWeight: FontWeight.w800),
          headlineMedium: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
          headlineSmall: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
          titleLarge: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
          titleMedium: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.montserrat(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: const Color(0xFF5960A1).withValues(alpha: 0.15),
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