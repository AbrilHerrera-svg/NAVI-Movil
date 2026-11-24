import 'package:flutter/material.dart';

class Producto {
  final String nombre;
  final double precio;
  final IconData icono;
  final String categoria;
  final String descripcion;
  final String etiqueta;

  const Producto(
    this.nombre,
    this.precio,
    this.icono,
    this.categoria, {
    this.descripcion = '',
    this.etiqueta = '',
  });
}

