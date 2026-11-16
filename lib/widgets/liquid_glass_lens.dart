import 'package:flutter/material.dart';

/// Specular liquid glass lens indicator with dynamic morphing scale.
class LiquidGlassLens extends StatelessWidget {
  final double left;
  final double width;
  final bool active;

  const LiquidGlassLens({
    super.key,
    required this.left,
    required this.width,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      width: width,
      height: 48.0,
      child: Transform.scale(
        scaleX: active ? 1.08 : 1.0,
        scaleY: active ? 1.16 : 1.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: active ? 0.24 : 0.16),
                const Color(0xFFC5A880).withValues(alpha: active ? 0.28 : 0.18),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: active ? 0.60 : 0.40),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC5A880).withValues(
                  alpha: active ? 0.35 : 0.20,
                ),
                blurRadius: 12.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
