import 'package:flutter/material.dart';
import 'package:navi/models/producto.dart';
import 'package:navi/services/servicio_api.dart';

/// Trae el menú real desde el backend de NAVI-web (colección "menuItems" de
/// Firestore, vía GET /api/menu) y lo convierte al modelo Producto que usa
/// la UI. Requiere que el usuario tenga una sesión de Firebase Auth válida
/// (el endpoint exige token); con "Continuar como invitado" no hay token y
/// la llamada responderá 401.
class ServicioMenu {
  final ServicioApi _api = ServicioApi();

  Future<List<Producto>> obtenerMenu() async {
    final respuesta = await _api.get('/api/menu');
    final lista = (respuesta as List).cast<Map<String, dynamic>>();

    return lista
        .where((item) => item['available'] == true && item['status'] == 'Activo')
        .map(_aProducto)
        .toList();
  }

  Producto _aProducto(Map<String, dynamic> item) {
    final categoria = (item['category'] as String?)?.trim() ?? 'General';
    final prepTime = item['prepTime'] as String?;

    return Producto(
      item['name'] as String? ?? 'Producto',
      ((item['priceSingle'] as num?) ?? 0).toDouble(),
      _iconoParaCategoria(categoria),
      categoria,
      descripcion: prepTime == null || prepTime.isEmpty ? '' : 'Listo en $prepTime',
    );
  }

  IconData _iconoParaCategoria(String categoria) {
    final c = categoria.toLowerCase();
    if (c.contains('café') || c.contains('cafe') || c.contains('coffee')) return Icons.coffee;
    if (c.contains('frappé') || c.contains('frappe') || c.contains('frío') || c.contains('cold')) {
      return Icons.icecream_outlined;
    }
    if (c.contains('pan') || c.contains('bread') || c.contains('bakery')) return Icons.bakery_dining;
    if (c.contains('postre') || c.contains('dessert') || c.contains('cake')) return Icons.cake_outlined;
    if (c.contains('bebida') || c.contains('drink')) return Icons.local_drink_outlined;
    return Icons.restaurant_menu;
  }
}
