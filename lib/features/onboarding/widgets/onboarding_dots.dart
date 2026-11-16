import 'package:flutter/material.dart';

class OnboardingDots extends StatelessWidget {
  final int count;
  final int activeIndex;

  const OnboardingDots({
    super.key,
    required this.count,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: isActive ? 24.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF8B725A) : const Color(0xFFD8CEC2),
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      }),
    );
  }
}
