import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  static const Color naviOscuro = Color(0xFF2B2F5E);
  static const Color grisSuave = Color(0xFFECEEF5);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? naviMorado : grisSuave,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? const [BoxShadow(color: Color(0x335960A1), blurRadius: 8, offset: Offset(0, 3))]
              : const [],
        ),
        child: Text(
          categoria.nombre,
          maxLines: 1,
          style: GoogleFonts.bricolageGrotesque(
            color: isSelected ? Colors.white : naviOscuro,
            fontWeight: FontWeight.w700,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}