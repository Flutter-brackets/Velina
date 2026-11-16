import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// Legacy splash logo component kept for modular backwards compatibility.
class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50.0,
          height: 1.5,
          color: AppColors.luxuryGold,
          margin: const EdgeInsets.only(bottom: 24.0),
        ),
        const Text(
          AppStrings.appTitle,
          style: TextStyle(
            color: AppColors.luxuryGold,
            fontSize: 42.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 8.0,
          ),
        ),
        const SizedBox(height: 10.0),
        const Text(
          AppStrings.appSubtitle,
          style: TextStyle(
            color: AppColors.darkCharcoal,
            fontSize: 11.0,
            fontWeight: FontWeight.w400,
            letterSpacing: 4.5,
          ),
        ),
        Container(
          width: 50.0,
          height: 1.5,
          color: AppColors.luxuryGold,
          margin: const EdgeInsets.only(top: 24.0),
        ),
      ],
    );
  }
}
