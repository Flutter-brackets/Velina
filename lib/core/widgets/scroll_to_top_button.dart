import 'package:flutter/material.dart';

/// Native circular white Scroll-to-Top floating button with smooth fade/scale.
class ScrollToTopButton extends StatelessWidget {
  final bool visible;
  final VoidCallback onPressed;

  const ScrollToTopButton({
    super.key,
    required this.visible,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: IgnorePointer(
          ignoring: !visible,
          child: SizedBox(
            width: 44.0,
            height: 44.0,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 6.0,
              shadowColor: Colors.black.withValues(alpha: 0.40),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onPressed,
                child: const Center(
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    size: 22.0,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
