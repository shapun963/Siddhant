import 'package:flutter/material.dart';

class GradientMask extends StatelessWidget {
  const GradientMask(
      {super.key,required this.child,
        required this.colors,
      });

  final Widget? child;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(colors: colors).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: child,
    );
  }
}