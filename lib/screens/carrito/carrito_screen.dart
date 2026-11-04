import 'package:flutter/material.dart';
import 'package:navi/screens/carrito/checkout_screen.dart';
import 'package:navi/services/carrito_service.dart';

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final carrito = CarritoService();

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Pedido')),
      body: ListenableBuilder(
        listenable: carrito,
        builder: (context, _) {
          if (carrito.items.isEmpty) {
            return const Center(
              child: Text(
                'Tu carrito está vacío',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: carrito.items.length,
                  itemBuilder: (context, index) {
                    final item = carrito.items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(item.producto.icono, size: 36),
                        title: Text(item.producto.nombre),
                        subtitle: Text('\$${item.producto.precio.toStringAsFixed(2)} c/u'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => carrito.quitar(item.producto),
                            ),
                            Text('${item.cantidad}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => carrito.agregar(item.producto),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          '\$${carrito.totalPrecio.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                          );
                        },
                        child: const Text('Proceder al pago'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
