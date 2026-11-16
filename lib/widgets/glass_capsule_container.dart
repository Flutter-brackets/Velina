import 'dart:ui';
import 'package:flutter/material.dart';

/// Frosted obsidian glass capsule with specular gradient rim and ambient shadows.
class GlassCapsuleContainer extends StatelessWidget {
  final Widget child;

  const GlassCapsuleContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.32),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.50),
            blurRadius: 28.0,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFFC5A880).withValues(alpha: 0.08),
            blurRadius: 18.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(38.8),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22.0, sigmaY: 22.0),
            child: Container(
              color: const Color(0xFF0D0D0D).withValues(alpha: 0.68),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
