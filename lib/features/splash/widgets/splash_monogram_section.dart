import 'package:flutter/material.dart';

/// Animated luxury logo section for Velina splash screen.
class SplashMonogramSection extends StatelessWidget {
  final AnimationController controller;

  const SplashMonogramSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final scaleAnim = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
      ),
    );
    final fadeAnim = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.50, curve: Curves.easeIn),
    );
    final haloAnim = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.60, curve: Curves.easeOut),
    );
    final dividerAnim = Tween<double>(begin: 0.0, end: 64.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.40, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: haloAnim.value * 0.14,
                  child: Container(
                    width: 260.0,
                    height: 260.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Color(0xFFC5A880), Colors.transparent],
                      ),
                    ),
                  ),
                ),
                Transform.scale(
                  scale: scaleAnim.value,
                  child: Opacity(
                    opacity: fadeAnim.value,
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFAF6F0),
                        BlendMode.multiply,
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 230.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Container(
              width: dividerAnim.value,
              height: 1.2,
              decoration: BoxDecoration(
                color: const Color(0xFF8B725A).withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(1.0),
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
