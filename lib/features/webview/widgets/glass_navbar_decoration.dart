import 'dart:ui';
import 'package:flutter/material.dart';

/// Warm Mocha/Taupe Brown (#8B725A) floating frosted glass capsule with specular rim.
class GlassNavbarDecoration extends StatelessWidget {
  final Widget child;

  const GlassNavbarDecoration({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58.0,
      margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 14.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 18.0,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: const Color(0xFF8B725A).withValues(alpha: 0.15),
            blurRadius: 12.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.38),
              Colors.white.withValues(alpha: 0.08),
            ],
          ),
        ),
        padding: const EdgeInsets.all(1.2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.8),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
            child: Container(
              color: const Color(0xFF8B725A).withValues(alpha: 0.88),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
