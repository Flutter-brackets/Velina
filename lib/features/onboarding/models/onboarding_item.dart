import '../../../core/constants/app_strings.dart';

enum FashionArtworkType { handbag, watch, jewelry }

class OnboardingItem {
  final String title;
  final String subtitle;
  final FashionArtworkType artworkType;

  const OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.artworkType,
  });

  static const List<OnboardingItem> items = [
    OnboardingItem(
      title: AppStrings.onboarding1Title,
      subtitle: AppStrings.onboarding1Subtitle,
      artworkType: FashionArtworkType.handbag,
    ),
    OnboardingItem(
      title: AppStrings.onboarding2Title,
      subtitle: AppStrings.onboarding2Subtitle,
      artworkType: FashionArtworkType.watch,
    ),
    OnboardingItem(
      title: AppStrings.onboarding3Title,
      subtitle: AppStrings.onboarding3Subtitle,
      artworkType: FashionArtworkType.jewelry,
    ),
  ];
}
