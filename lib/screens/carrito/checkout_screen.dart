import 'package:flutter/material.dart';
import 'package:navi/services/carrito_service.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final carrito = CarritoService();

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total a pagar: \$${carrito.totalPrecio.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  carrito.limpiar();
                  Navigator.popUntil(context, (route) => route.isFirst);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pedido confirmado con éxito')),
                  );
                },
                child: const Text('Confirmar y Pagar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
