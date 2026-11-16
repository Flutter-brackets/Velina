import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/luxury_button.dart';

class OfflineScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const OfflineScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBackground,
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90.0,
              height: 90.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.darkCharcoal,
                border: Border.all(color: AppColors.luxuryGold, width: 1.5),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 42.0,
                color: AppColors.luxuryGold,
              ),
            ),
            const SizedBox(height: 32.0),
            const Text(
              AppStrings.offlineMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.pureWhite,
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              'يرجى التأكد من اتصالك بالشبكة للمتابعة',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.pureWhite.withAlpha(178),
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 36.0),
            LuxuryButton(
              label: AppStrings.retry,
              icon: Icons.refresh_rounded,
              width: 200.0,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
