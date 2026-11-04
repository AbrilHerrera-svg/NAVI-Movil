import 'package:flutter/material.dart';
import 'package:navi/models/producto.dart';
import 'package:navi/services/carrito_service.dart';

class DetalleProductoScreen extends StatelessWidget {
  final Producto producto;

  const DetalleProductoScreen({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(producto.nombre)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                producto.icono,
                size: 120,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              producto.nombre,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              producto.categoria,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              '\$${producto.precio.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  CarritoService().agregar(producto);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${producto.nombre} agregado al carrito')),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Agregar al carrito'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
