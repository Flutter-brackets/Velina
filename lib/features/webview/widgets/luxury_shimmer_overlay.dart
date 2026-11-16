import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class LuxuryShimmerOverlay extends StatefulWidget {
  final bool isLoading;
  final double progress;

  const LuxuryShimmerOverlay({
    super.key,
    required this.isLoading,
    required this.progress,
  });

  @override
  State<LuxuryShimmerOverlay> createState() => _LuxuryShimmerOverlayState();
}

class _LuxuryShimmerOverlayState extends State<LuxuryShimmerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.isLoading,
      child: AnimatedOpacity(
        opacity: widget.isLoading ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 350),
        child: Container(
          color: const Color(0xFFFAF6F0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    final val = _shimmerController.value;
                    return ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment(-1.0 + 2.0 * val, -0.3),
                          end: Alignment(1.0 + 2.0 * val, 0.3),
                          colors: const [
                            Color(0xFF1E1916),
                            Color(0xFF8B725A),
                            Color(0xFF1E1916),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ).createShader(bounds);
                      },
                      child: const Text(
                        AppStrings.appTitle,
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 6.0,
                          color: Color(0xFF1E1916),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: 140.0,
                  child: LinearProgressIndicator(
                    value: widget.progress > 0 ? widget.progress : null,
                    backgroundColor: const Color(0xFFE6DACB),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF8B725A),
                    ),
                    minHeight: 2.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
