import 'package:flutter/material.dart';
import 'package:navi/screens/home/home_screen.dart';
import 'package:navi/screens/pedidos/pantalla_pedidos.dart';
import 'package:navi/screens/carrito/carrito_screen.dart';
import 'package:navi/screens/perfil/perfil_screen.dart';
import 'package:navi/services/carrito_service.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key, this.indiceInicial = 0});

  final int indiceInicial;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex = widget.indiceInicial;

  final List<Widget> _pantallas = const [
    HomeScreen(),
    CarritoScreen(),
    PantallaPedidos(),
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
                icon: Icon(Icons.coffee_outlined),
                selectedIcon: Icon(Icons.coffee),
                label: 'Menú',
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
                label: 'Carrito',
              ),
              const NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: 'Pedidos',
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
