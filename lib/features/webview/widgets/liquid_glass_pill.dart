import 'package:flutter/material.dart';

/// Specular liquid glass pill indicator with smooth stretch morphing and spring physics.
class LiquidGlassPill extends StatelessWidget {
  final double left;
  final double width;
  final bool isDragging;

  const LiquidGlassPill({
    super.key,
    required this.left,
    required this.width,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: isDragging ? Duration.zero : const Duration(milliseconds: 280),
      curve: Curves.easeOutBack,
      left: left,
      top: 5.0,
      width: width,
      height: 46.0,
      child: Transform.scale(
        scaleX: isDragging ? 1.08 : 1.0,
        scaleY: isDragging ? 0.94 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.70),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.12),
                blurRadius: 8.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
