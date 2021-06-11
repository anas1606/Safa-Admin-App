import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  GradientIcon(
    this.icon, {
    @required this.gradient,
    @required this.size,
  });

  final Widget icon;
  final Gradient gradient;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(bounds);
      },
      child: icon,
    );
  }
}
