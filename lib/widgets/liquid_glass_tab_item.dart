import 'package:flutter/material.dart';

/// Single visual tab item inside the liquid glass navigation bar.
class LiquidGlassTabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const LiquidGlassTabItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFC5A880);
    final color = isSelected ? gold : Colors.white.withValues(alpha: 0.75);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: isSelected ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Icon(icon, size: 22.0, color: color),
          ),
          const SizedBox(height: 3.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tab metadata descriptor.
class LiquidTabConfig {
  final IconData icon;
  final String label;
  const LiquidTabConfig(this.icon, this.label);
}
