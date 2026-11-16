import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/privacy_policy_sheet.dart';

class OnboardingHeader extends StatelessWidget {
  final VoidCallback onSkip;

  const OnboardingHeader({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/app_icon.png', width: 32.0, height: 32.0, color: const Color(0xFF1E1916), fit: BoxFit.contain),
              const SizedBox(width: 8.0),
              IconButton(
                icon: const Icon(Icons.privacy_tip_outlined, size: 21.0, color: Color(0xFF8B725A)),
                tooltip: 'سياسة الخصوصية',
                padding: const EdgeInsets.all(6.0),
                constraints: const BoxConstraints(),
                onPressed: () => PrivacyPolicySheet.show(context),
              ),
            ],
          ),
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF8B725A),
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
            ),
            child: const Text(
              AppStrings.skip,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, letterSpacing: 1.0),
            ),
          ),
        ],
      ),
    );
  }
}
