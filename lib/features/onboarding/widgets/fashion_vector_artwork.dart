import 'package:flutter/material.dart';
import '../models/onboarding_item.dart';
import 'fashion_artwork_painter.dart';

class FashionVectorArtwork extends StatelessWidget {
  final FashionArtworkType type;
  final double size;

  const FashionVectorArtwork({
    super.key,
    required this.type,
    this.size = 140.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: FashionArtworkPainter(type));
  }
}
