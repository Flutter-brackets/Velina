import 'dart:ui';
import 'package:flutter/material.dart';
import 'luxury_medallion.dart';

class LuxuryPageLoader extends StatelessWidget {
  final bool isLoading;
  final double progress;

  const LuxuryPageLoader({
    super.key,
    required this.isLoading,
    this.progress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !isLoading,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          opacity: isLoading ? 1.0 : 0.0,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
              child: Container(
                color: const Color(0xFFFAF6F0).withValues(alpha: 0.35),
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 76.0,
                  height: 76.0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 76.0,
                        height: 76.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          strokeCap: StrokeCap.round,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF8B725A),
                          ),
                          backgroundColor: Color(0x2EC5A880),
                        ),
                      ),
                      LuxuryMedallion(),
                    ],
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
