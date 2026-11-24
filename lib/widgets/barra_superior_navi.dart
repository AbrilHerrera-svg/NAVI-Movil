import 'package:flutter/material.dart';
import 'package:navi/widgets/logotipo_navi.dart';

/// AppBar con el logo de NAVI + el nombre de la sección (ej. "| Menú"),
/// igual en todas las pantallas principales del nav bar.
class BarraSuperiorNavi extends StatelessWidget implements PreferredSizeWidget {
  const BarraSuperiorNavi({
    super.key,
    required this.seccion,
    this.actions,
    this.automaticallyImplyLeading = false,
  });

  final String seccion;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: automaticallyImplyLeading,
      titleSpacing: 16,
      title: Row(
        children: [
          const LogotipoNavi(tamanoIcono: 28, tamanoTexto: 18),
          const SizedBox(width: 8),
          Text('| $seccion', style: const TextStyle(fontSize: 14, color: Colors.black45)),
        ],
      ),
      actions: actions,
    );
  }
}
