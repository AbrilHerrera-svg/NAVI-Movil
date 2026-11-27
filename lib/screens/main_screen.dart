import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navi/screens/home/home_screen.dart';
import 'package:navi/screens/pedidos/pantalla_pedidos.dart';
import 'package:navi/screens/carrito/carrito_screen.dart';
import 'package:navi/screens/perfil/perfil_screen.dart';
import 'package:navi/services/carrito_service.dart';
import 'package:navi/services/servicio_notificaciones.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key, this.indiceInicial = 0});

  final int indiceInicial;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  static const Color naviMorado = Color(0xFF5960A1);
  static const Color naviOscuro = Color(0xFF2B2F5E);
  static const Color fondoSeleccion = Color(0xFFE3E5F7);

  late int _currentIndex = widget.indiceInicial;

  final List<Widget> _pantallas = const [
    HomeScreen(),
    CarritoScreen(),
    PantallaPedidos(),
    PerfilScreen(),
  ];

  @override
  void initState() {
    super.initState();
    ServicioNotificaciones().iniciar();
    ServicioNotificaciones().alRecibirEnPrimerPlano((mensaje) {
      final notificacion = mensaje.notification;
      if (notificacion == null || !mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${notificacion.title ?? ''}\n${notificacion.body ?? ''}'.trim()),
          duration: const Duration(seconds: 4),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pantallas,
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: CarritoService(),
        builder: (context, _) {
          final totalCarrito = CarritoService().totalItems;

          return SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(color: Color(0x2E5960A1), blurRadius: 24, offset: Offset(0, 8)),
                      ],
                    ),
                    child: Row(
                      children: [
                        _construirItem(
                          indice: 0,
                          etiqueta: 'Menú',
                          icono: Icons.coffee_outlined,
                          iconoActivo: Icons.coffee,
                        ),
                        _construirItem(
                          indice: 1,
                          etiqueta: 'Carrito',
                          icono: Icons.shopping_bag_outlined,
                          iconoActivo: Icons.shopping_bag,
                          insignia: totalCarrito,
                        ),
                        _construirItem(
                          indice: 2,
                          etiqueta: 'Pedidos',
                          icono: Icons.receipt_long_outlined,
                          iconoActivo: Icons.receipt_long,
                        ),
                        _construirItem(
                          indice: 3,
                          etiqueta: 'Perfil',
                          icono: Icons.person_outline,
                          iconoActivo: Icons.person,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _construirItem({
    required int indice,
    required String etiqueta,
    required IconData icono,
    required IconData iconoActivo,
    int insignia = 0,
  }) {
    final seleccionado = _currentIndex == indice;
    final colorIcono = seleccionado ? naviMorado : naviOscuro.withValues(alpha: 0.65);

    Widget widgetIcono = Icon(seleccionado ? iconoActivo : icono, color: colorIcono, size: 24);
    if (insignia > 0) {
      widgetIcono = Badge(label: Text('$insignia'), child: widgetIcono);
    }

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _currentIndex = indice;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: seleccionado ? fondoSeleccion : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widgetIcono,
                  const SizedBox(height: 4),
                  Text(
                    etiqueta,
                    maxLines: 1,
                    style: seleccionado
                        ? GoogleFonts.bricolageGrotesque(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: naviMorado,
                          )
                        : GoogleFonts.hankenGrotesk(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}