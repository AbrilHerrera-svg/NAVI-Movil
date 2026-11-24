import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navi/models/categoria.dart';
import 'package:navi/models/producto.dart';
import 'package:navi/screens/carrito/carrito_screen.dart';
import 'package:navi/screens/home/detalle_producto_screen.dart';
import 'package:navi/screens/perfil/perfil_screen.dart';
import 'package:navi/services/carrito_service.dart';
import 'package:navi/services/servicio_menu.dart';
import 'package:navi/widgets/barra_superior_navi.dart';
import 'package:navi/widgets/categoria_item.dart';
import 'package:navi/widgets/estado_vacio_navi.dart';
import 'package:navi/widgets/tarjeta_producto_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color naviMorado = Color(0xFF5960A1);
  static const Color fondoSuave = Color(0xFFEEF0FB);

  final ServicioMenu _servicioMenu = ServicioMenu();
  final _busquedaController = TextEditingController();

  String _categoriaSeleccionada = 'Todos';
  bool _cargando = true;
  String? _error;
  List<Producto> _productos = [];

  @override
  void initState() {
    super.initState();
    _cargarMenu();
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  Future<void> _cargarMenu() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final productos = await _servicioMenu.obtenerMenu();
      if (!mounted) return;
      setState(() {
        _productos = productos;
        _cargando = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString().replaceFirst('Exception: ', '');
        _cargando = false;
      });
    }
  }

  List<Categoria> get _categorias {
    final nombres = _productos.map((p) => p.categoria).toSet().toList()..sort();
    return [
      const Categoria('Todos', Icons.coffee),
      ...nombres.map((nombre) => Categoria(nombre, Icons.local_cafe_outlined)),
    ];
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
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: BarraSuperiorNavi(
        seccion: 'Menú',
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              Expanded(child: _construirContenido(productosFiltrados)),
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
        ),
      ),
    );
  }

  Widget _construirContenido(List<Producto> productosFiltrados) {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator(color: naviMorado));
    }

    if (_error != null) {
      return EstadoVacioNavi(
        icono: Icons.wifi_off,
        titulo: _error!.contains('No autorizado') || _error!.contains('Token')
            ? 'Inicia sesión para ver el menú'
            : 'No se pudo cargar el menú',
        subtitulo: _error,
        accion: OutlinedButton(onPressed: _cargarMenu, child: const Text('Reintentar')),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarMenu,
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
                        Text('$_saludo, $_nombreUsuario 👋', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
          if (productosFiltrados.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Todavía no hay productos en esta categoría', style: TextStyle(color: Colors.black45)),
                ),
              ),
            )
          else
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
    );
  }
}
