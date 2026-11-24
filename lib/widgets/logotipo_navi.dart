import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Logo + palabra "NAVI" tal como aparece en NAVI-web (Sidebar/LoginForm):
/// el cohete sin fondo, en su color morado natural, junto a la palabra con
/// la "A" en café y el resto en morado.
class LogotipoNavi extends StatelessWidget {
  const LogotipoNavi({super.key, this.tamanoIcono = 32, this.tamanoTexto = 22});

  static const Color naviMorado = Color(0xFF5960A1);
  static const Color naviCafe = Color(0xFFAC8572);

  final double tamanoIcono;
  final double tamanoTexto;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/images/navi-cohete.svg', width: tamanoIcono, height: tamanoIcono),
        const SizedBox(width: 8),
        Text.rich(
          TextSpan(
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: tamanoTexto, letterSpacing: 0.5),
            children: const [
              TextSpan(text: 'N', style: TextStyle(color: naviMorado)),
              TextSpan(text: 'A', style: TextStyle(color: naviCafe)),
              TextSpan(text: 'VI', style: TextStyle(color: naviMorado)),
            ],
          ),
        ),
      ],
    );
  }
}
