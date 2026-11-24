import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navi/models/categoria.dart';
import 'package:navi/models/producto.dart';
import 'package:navi/screens/carrito/carrito_screen.dart';
import 'package:navi/screens/home/detalle_producto_screen.dart';
import 'package:navi/screens/perfil/perfil_screen.dart';
import 'package:navi/services/carrito_service.dart';
import 'package:navi/widgets/categoria_item.dart';
import 'package:navi/widgets/logotipo_navi.dart';
import 'package:navi/widgets/tarjeta_producto_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color naviMorado = Color(0xFF5960A1);
  static const Color fondoSuave = Color(0xFFEEF0FB);

  String _categoriaSeleccionada = 'Todos';
  final _busquedaController = TextEditingController();

  final List<Categoria> _categorias = const [
    Categoria('Todos', Icons.coffee),
    Categoria('Café Caliente', Icons.coffee_maker),
    Categoria('Cold Brew & Frappés', Icons.icecream_outlined),
    Categoria('Panadería', Icons.bakery_dining),
    Categoria('Brunch', Icons.egg_outlined),
  ];

  final List<Producto> _productos = const [
    Producto(
      'Cappuccino Artesanal',
      75.0,
      Icons.coffee,
      'Café Caliente',
      descripcion: 'Espresso doble con leche texturizada y arte latte',
      etiqueta: 'Destacado',
    ),
    Producto(
      'Cold Brew Especial',
      85.0,
      Icons.icecream_outlined,
      'Cold Brew & Frappés',
      descripcion: 'Extracción en frío durante 18 horas, perfil frutal y refrescante',
      etiqueta: '18h Brew',
    ),
    Producto(
      'Croissant Francés Mantequilla',
      65.0,
      Icons.bakery_dining,
      'Panadería',
      descripcion: 'Hojaldre crujiente horneado esta mañana con pura mantequilla',
      etiqueta: 'Recién Horneado',
    ),
    Producto(
      'Avocado Toast & Huevo',
      145.0,
      Icons.egg_outlined,
      'Brunch',
      descripcion: 'Pan de masa madre, aguacate triturado, brotes frescos y flor de sal',
      etiqueta: 'Favorito Brunch',
    ),
  ];

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  String get _saludo {
    final hora = DateTime.now().hour;
    if (hora < 12) return 'Buenos días';
    if (hora < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  String get _nombreUsuario {
    final nombre = FirebaseAuth.instance.currentUser?.displayName;
    if (nombre == null || nombre.trim().isEmpty) return 'invitado';
    return nombre.trim().split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    final productosFiltrados = _categoriaSeleccionada == 'Todos'
        ? _productos
        : _productos.where((p) => p.categoria == _categoriaSeleccionada).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 16,
        title: Row(
          children: [
            const LogotipoNavi(tamanoIcono: 28, tamanoTexto: 18),
            const SizedBox(width: 8),
            const Text('| Menú', style: TextStyle(fontSize: 14, color: Colors.black45)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PerfilScreen())),
            icon: const CircleAvatar(
              radius: 16,
              backgroundColor: naviMorado,
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$_saludo, $_nombreUsuario 👋',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: naviMorado),
                            const SizedBox(width: 4),
                            const Text('Sucursal Roma Norte', style: TextStyle(fontSize: 13, color: naviMorado)),
                            const Icon(Icons.keyboard_arrow_down, size: 16, color: naviMorado),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListenableBuilder(
                    listenable: CarritoService(),
                    builder: (context, _) {
                      final total = CarritoService().totalItems;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(color: fondoSuave, borderRadius: BorderRadius.circular(12)),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.shopping_bag_outlined, color: naviMorado),
                              onPressed: () =>
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CarritoScreen())),
                            ),
                          ),
                          if (total > 0)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: naviMorado, shape: BoxShape.circle),
                                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                                child: Text('$total',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                controller: _busquedaController,
                decoration: InputDecoration(
                  hintText: 'Buscar cafés, matcha, panadería...',
                  prefixIcon: const Icon(Icons.search, color: Colors.black45),
                  suffixIcon: const Icon(Icons.tune, color: Colors.black45),
                  filled: true,
                  fillColor: fondoSuave,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: _categorias.length,
                itemBuilder: (context, index) {
                  final cat = _categorias[index];
                  return CategoriaItem(
                    categoria: cat,
                    isSelected: cat.nombre == _categoriaSeleccionada,
                    onTap: () => setState(() => _categoriaSeleccionada = cat.nombre),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(color: fondoSuave, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, size: 16, color: naviMorado),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                          children: [
                            TextSpan(text: 'Tiempo estimado de retiro: '),
                            TextSpan(text: '6-9 min', style: TextStyle(fontWeight: FontWeight.bold, color: naviMorado)),
                          ],
                        ),
                      ),
                    ),
                    const Text('Roma Norte', style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
            sliver: SliverList.separated(
              itemCount: productosFiltrados.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final prod = productosFiltrados[index];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetalleProductoScreen(producto: prod))),
                  child: TarjetaProductoMenu(
                    producto: prod,
                    onAgregar: () {
                      CarritoService().agregar(prod);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${prod.nombre} agregado al carrito')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
            ),
          ),
          ListenableBuilder(
            listenable: CarritoService(),
            builder: (context, _) {
              final carrito = CarritoService();
              if (carrito.totalItems == 0) return const SizedBox.shrink();

              return Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: BoxDecoration(
                  color: fondoSuave,
                  boxShadow: const [BoxShadow(color: Color(0x1A5960A1), blurRadius: 12, offset: Offset(0, -2))],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(color: naviMorado, shape: BoxShape.circle),
                        child: const Icon(Icons.shopping_bag, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${carrito.totalItems} productos en orden', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                            Text('\$${carrito.totalPrecio.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: naviMorado, fontSize: 16)),
                          ],
                        ),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CarritoScreen())),
                        style: FilledButton.styleFrom(
                          backgroundColor: naviMorado,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Text('Ver carrito'), SizedBox(width: 6), Icon(Icons.arrow_forward, size: 16)],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
