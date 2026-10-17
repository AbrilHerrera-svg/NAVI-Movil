//snake case. Productos_Nuevos_
//Pascal Case.  Main.  ProductosNuevos
//camelCase nombreCompletoEstudiante
import 'package:flutter/material.dart';
import 'package:navi/screens/home/home_screen.dart';
import 'package:navi/screens/carrito/carrito_screen.dart';
import 'package:navi/screens/reservaciones/reservacion_screen.dart';
import 'package:navi/screens/perfil/perfil_screen.dart';
import 'package:navi/services/carrito_service.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pantallas = const [
    HomeScreen(),
    ReservacionScreen(),
    CarritoScreen(),
    PerfilScreen(),
  ];

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

          return NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.restaurant_menu_outlined),
                selectedIcon: Icon(Icons.restaurant_menu),
                label: 'Menú',
              ),
              const NavigationDestination(
                icon: Icon(Icons.calendar_today_outlined),
                selectedIcon: Icon(Icons.calendar_today),
                label: 'Reservas',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: totalCarrito > 0,
                  label: Text('$totalCarrito'),
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: totalCarrito > 0,
                  label: Text('$totalCarrito'),
                  child: const Icon(Icons.shopping_bag),
                ),
                label: 'Pedido',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          );
        },
      ),
    );
  }
}