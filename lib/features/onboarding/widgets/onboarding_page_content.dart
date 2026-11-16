import 'package:flutter/material.dart';
import '../models/onboarding_item.dart';
import 'editorial_glass_card.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPageContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EditorialGlassCard(artworkType: item.artworkType),
          const SizedBox(height: 38.0),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1E1916),
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14.0),
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6E5D4F),
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
