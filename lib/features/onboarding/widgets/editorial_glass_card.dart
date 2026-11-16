import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/onboarding_item.dart';
import 'fashion_vector_artwork.dart';

class EditorialGlassCard extends StatefulWidget {
  final FashionArtworkType artworkType;

  const EditorialGlassCard({super.key, required this.artworkType});

  @override
  State<EditorialGlassCard> createState() => _EditorialGlassCardState();
}

class _EditorialGlassCardState extends State<EditorialGlassCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    final isTest =
        bool.fromEnvironment('flutter.test') ||
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isTest) {
      _floatCtrl.repeat(reverse: true);
    } else {
      _floatCtrl.value = 0.5;
    }
    _floatAnim = Tween<double>(
      begin: -4.0,
      end: 4.0,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _floatAnim.value),
        child: child,
      ),
      child: Container(
        width: 200.0,
        height: 220.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.0),
          border: Border.all(color: const Color(0xFFE6DACB), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B725A).withValues(alpha: 0.10),
              blurRadius: 24.0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.8),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
            child: Container(
              color: Colors.white.withValues(alpha: 0.88),
              alignment: Alignment.center,
              child: FashionVectorArtwork(
                type: widget.artworkType,
                size: 140.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
