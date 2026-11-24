import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Logo + palabra "NAVI" tal como aparece en NAVI-web (Sidebar/LoginForm):
/// el cohete sin fondo, en su color morado natural, junto al wordmark con
/// la "A" en café y el resto en morado.
class NaviWordmark extends StatelessWidget {
  const NaviWordmark({super.key, this.iconSize = 32, this.fontSize = 22});

  static const Color naviMorado = Color(0xFF5960A1);
  static const Color naviCafe = Color(0xFFAC8572);

  final double iconSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/images/navi-cohete.svg', width: iconSize, height: iconSize),
        const SizedBox(width: 8),
        Text.rich(
          TextSpan(
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: fontSize, letterSpacing: -0.2),
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
