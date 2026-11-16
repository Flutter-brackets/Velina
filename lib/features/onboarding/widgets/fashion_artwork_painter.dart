import 'package:flutter/material.dart';
import '../models/onboarding_item.dart';
import 'handbag_drawer.dart';
import 'watch_jewelry_drawer.dart';

class FashionArtworkPainter extends CustomPainter {
  final FashionArtworkType type;
  FashionArtworkPainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    const espresso = Color(0xFF1E1916);
    const mocha = Color(0xFF8B725A);
    final stroke = Paint()
      ..color = espresso
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = mocha.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    final accent = Paint()
      ..color = mocha
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final center = Offset(size.width / 2, size.height / 2);

    switch (type) {
      case FashionArtworkType.handbag:
        drawHandbag(canvas, size, stroke, fill, accent);
      case FashionArtworkType.watch:
        drawWatch(canvas, center, stroke, fill, accent);
      case FashionArtworkType.jewelry:
        drawJewelry(canvas, center, stroke, fill, accent);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
