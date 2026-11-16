import 'package:flutter/material.dart';

class LuxuryMedallion extends StatelessWidget {
  final double size;
  const LuxuryMedallion({super.key, this.size = 70.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFFAF6F0)],
        ),
        border: Border.all(color: const Color(0xFFE6DACB), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B725A).withValues(alpha: 0.12),
            blurRadius: 18.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Image.asset(
            'assets/images/app_icon.png',
            color: const Color(0xFF1E1916),
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Center(
              child: Text(
                'VB',
                style: TextStyle(
                  color: Color(0xFF1E1916),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
