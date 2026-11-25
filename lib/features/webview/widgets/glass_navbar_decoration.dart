import 'package:flutter/material.dart';

/// Warm Mocha/Taupe Brown (#8B725A) floating luxury capsule without blur filter for 60/120fps.
class GlassNavbarDecoration extends StatelessWidget {
  final Widget child;

  const GlassNavbarDecoration({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        height: 58.0,
        margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 14.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 16.0,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: const Color(0xFF8B725A).withValues(alpha: 0.20),
              blurRadius: 10.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.0),
            color: const Color(0xFF8B725A).withValues(alpha: 0.94),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.24),
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
