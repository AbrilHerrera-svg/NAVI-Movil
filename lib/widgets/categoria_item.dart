import 'package:flutter/material.dart';
import 'package:navi/models/categoria.dart';

class CategoriaItem extends StatelessWidget {
  final Categoria categoria;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoriaItem({
    super.key,
    required this.categoria,
    required this.isSelected,
    required this.onTap,
  });

  static const Color naviMorado = Color(0xFF5960A1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? naviMorado : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? naviMorado : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const SizedBox(
                width: 6,
                height: 6,
                child: DecoratedBox(decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              categoria.nombre,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
