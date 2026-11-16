import 'dart:math' as math;
import 'package:flutter/material.dart';

void drawWatch(Canvas canvas, Offset c, Paint stroke, Paint fill, Paint accent) {
  final topBand = Rect.fromCenter(center: Offset(c.dx, c.dy - 42.0), width: 22.0, height: 28.0);
  final btmBand = Rect.fromCenter(center: Offset(c.dx, c.dy + 42.0), width: 22.0, height: 28.0);
  canvas.drawRect(topBand, fill);
  canvas.drawRect(btmBand, fill);
  canvas.drawRect(topBand, stroke);
  canvas.drawRect(btmBand, stroke);
  canvas.drawCircle(c, 34.0, fill);
  canvas.drawCircle(c, 34.0, stroke);
  canvas.drawCircle(c, 29.0, accent);

  for (int i = 0; i < 12; i++) {
    final a = i * (math.pi / 6);
    canvas.drawLine(
      Offset(c.dx + 23.0 * math.cos(a), c.dy + 23.0 * math.sin(a)),
      Offset(c.dx + 27.0 * math.cos(a), c.dy + 27.0 * math.sin(a)),
      accent,
    );
  }
  canvas.drawLine(c, Offset(c.dx - 8.0, c.dy - 12.0), stroke);
  canvas.drawLine(c, Offset(c.dx + 12.0, c.dy - 4.0), stroke);
  canvas.drawCircle(c, 2.5, Paint()..color = const Color(0xFFC5A880)..style = PaintingStyle.fill);
}

void drawJewelry(Canvas canvas, Offset c, Paint stroke, Paint fill, Paint accent) {
  final left = RRect.fromRectAndRadius(
    Rect.fromCenter(center: Offset(c.dx - 26.0, c.dy + 2.0), width: 38.0, height: 28.0),
    const Radius.circular(12.0),
  );
  final right = RRect.fromRectAndRadius(
    Rect.fromCenter(center: Offset(c.dx + 26.0, c.dy + 2.0), width: 38.0, height: 28.0),
    const Radius.circular(12.0),
  );
  canvas.drawRRect(left, fill);
  canvas.drawRRect(right, fill);
  canvas.drawRRect(left, stroke);
  canvas.drawRRect(right, stroke);
  canvas.drawLine(Offset(c.dx - 7.0, c.dy - 2.0), Offset(c.dx + 7.0, c.dy - 2.0), stroke);
  drawSparkle(canvas, Offset(c.dx - 38.0, c.dy - 32.0), 12.0);
  drawSparkle(canvas, Offset(c.dx + 38.0, c.dy - 26.0), 16.0);
  drawSparkle(canvas, Offset(c.dx + 12.0, c.dy + 34.0), 9.0);
}

void drawSparkle(Canvas canvas, Offset p, double r) {
  final pth = Path()
    ..moveTo(p.dx, p.dy - r)
    ..quadraticBezierTo(p.dx, p.dy, p.dx + r, p.dy)
    ..quadraticBezierTo(p.dx, p.dy, p.dx, p.dy + r)
    ..quadraticBezierTo(p.dx, p.dy, p.dx - r, p.dy)
    ..quadraticBezierTo(p.dx, p.dy, p.dx, p.dy - r);
  canvas.drawPath(pth, Paint()..color = const Color(0xFFC5A880)..style = PaintingStyle.fill);
}
