import 'package:flutter/material.dart';

void drawHandbag(Canvas canvas, Size size, Paint stroke, Paint fill, Paint accent) {
  final w = size.width, h = size.height;
  final body = Path()
    ..moveTo(w * 0.22, h * 0.44)
    ..lineTo(w * 0.78, h * 0.44)
    ..lineTo(w * 0.86, h * 0.84)
    ..quadraticBezierTo(w * 0.86, h * 0.88, w * 0.80, h * 0.88)
    ..lineTo(w * 0.20, h * 0.88)
    ..quadraticBezierTo(w * 0.14, h * 0.88, w * 0.14, h * 0.84)
    ..close();
  canvas.drawPath(body, fill);
  canvas.drawPath(body, stroke);

  final handle = Path()
    ..moveTo(w * 0.35, h * 0.44)
    ..cubicTo(w * 0.35, h * 0.16, w * 0.65, h * 0.16, w * 0.65, h * 0.44);
  canvas.drawPath(handle, stroke);

  final flap = Path()
    ..moveTo(w * 0.28, h * 0.44)
    ..lineTo(w * 0.72, h * 0.44)
    ..lineTo(w * 0.64, h * 0.64)
    ..lineTo(w * 0.36, h * 0.64)
    ..close();
  canvas.drawPath(flap, stroke);

  canvas.drawCircle(
    Offset(w * 0.50, h * 0.64),
    3.5,
    Paint()..color = const Color(0xFFC5A880)..style = PaintingStyle.fill,
  );
}
