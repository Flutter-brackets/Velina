import 'package:flutter/material.dart';

class NavCartIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int count;

  const NavCartIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, size: 21.0, color: color),
        if (count > 0)
          Positioned(
            top: -4.0,
            right: -8.0,
            child: Container(
              constraints: const BoxConstraints(minWidth: 15.0, minHeight: 15.0),
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
              decoration: const BoxDecoration(
                color: Color(0xFFD93829),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                count > 99 ? '99+' : '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
