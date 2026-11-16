import 'package:flutter/material.dart';

/// Reusable luxury boutique button with rounded pill geometry and subtle shadow.
class LuxuryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;

  const LuxuryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 52.0,
    this.icon,
    this.backgroundColor = const Color(0xFF8B725A),
    this.textColor = Colors.white,
    this.borderRadius = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 3.0,
          shadowColor: backgroundColor.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: textColor,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8.0),
              Icon(icon, size: 20.0, color: textColor),
            ],
          ],
        ),
      ),
    );
  }
}
