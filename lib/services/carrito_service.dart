import 'package:flutter/material.dart';
import 'package:navi/models/item.carrito.dart';
import 'package:navi/models/producto.dart';

class CarritoService extends ChangeNotifier {
  static final CarritoService _instancia = CarritoService._interno();

  factory CarritoService() => _instancia;

  CarritoService._interno();

  final List<ItemCarrito> _items = [];

  List<ItemCarrito> get items => List.unmodifiable(_items);

  int get totalItems => _items.fold(0, (suma, item) => suma + item.cantidad);

  double get totalPrecio => _items.fold(0.0, (suma, item) => suma + item.subtotal);

  void agregar(Producto producto) {
    final index = _items.indexWhere((item) => item.producto.nombre == producto.nombre);
    if (index >= 0) {
      _items[index].cantidad++;
    } else {
      _items.add(ItemCarrito(producto: producto));
    }
    notifyListeners();
  }

  void quitar(Producto producto) {
    final index = _items.indexWhere((item) => item.producto.nombre == producto.nombre);
    if (index < 0) return;

    if (_items[index].cantidad > 1) {
      _items[index].cantidad--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void limpiar() {
    _items.clear();
    notifyListeners();
  }
}
