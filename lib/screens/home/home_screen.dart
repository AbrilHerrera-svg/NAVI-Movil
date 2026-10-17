import 'package:flutter/material.dart';
import 'package:navi/models/categoria.dart';
import 'package:navi/models/producto.dart';
import 'package:navi/widgets/categoria_item.dart';
import 'package:navi/widgets/producto_card.dart';
import 'package:navi/screens/home/detalle_producto_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _categoriaSeleccionada = 'Todos';
  int _tipoServicio = 0; // 0: Pickup, 1: En Restaurante

  final List<Categoria> _categorias = const [
    Categoria('Todos', Icons.fastfood),
    Categoria('Entradas', Icons.tapas),
    Categoria('Platos Fuertes', Icons.dinner_dining),
    Categoria('Bebidas', Icons.local_drink),
    Categoria('Postres', Icons.cake),
  ];

  final List<Producto> _productos = const [
    Producto('Hamburguesa Especial',  145.0,  Icons.lunch_dining,  'Platos Fuertes'),
    Producto('Papas Rústicas',  65.0,  Icons.fastfood,  'Entradas'),
    Producto('Refresco 500ml',  35.0,  Icons.local_drink,  'Bebidas'),
    Producto('Flan Casero', 50.0,Icons.cake,'Postres'),
  ];

  @override
  Widget build(BuildContext context) {
    final productosFiltrados = _categoriaSeleccionada == 'Todos'
        ? _productos
        : _productos.where((p) => p.categoria == _categoriaSeleccionada).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text('Restaurante Navi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Sucursal Principal', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Selector de modo de pedido (Pickup / Reserva)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('Pickup / Llevar'), icon: Icon(Icons.shopping_bag)),
                  ButtonSegment(value: 1, label: Text('Consumir ahí'), icon: Icon(Icons.table_restaurant)),
                ],
                selected: {_tipoServicio},
                onSelectionChanged: (val) {
                  setState(() => _tipoServicio = val.first);
                },
              ),
            ),
          ),

          // 2. Barra horizontal de Categorías
          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _categorias.length,
                itemBuilder: (context, index) {
                  final cat = _categorias[index];
                  return CategoriaItem(
                    categoria: cat,
                    isSelected: cat.nombre == _categoriaSeleccionada,
                    onTap: () {
                      setState(() {
                        _categoriaSeleccionada = cat.nombre;
                      });
                    },
                  );
                },
              ),
            ),
          ),

          // 3. Grid con las tarjetas de productos
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.78,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final prod = productosFiltrados[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalleProductoScreen(producto: prod),
                        ),
                      );
                    },
                    child: ProductoCard(
                      producto: prod,
                      onAgregar: () {
                        // Agregar al carrito
                      },
                    ),
                  );
                },
                childCount: productosFiltrados.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}