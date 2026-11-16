import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/luxury_button.dart';
import '../../core/widgets/powered_by_hout.dart';
import '../webview/main_webview_screen.dart';
import 'models/onboarding_item.dart';
import 'widgets/onboarding_dots.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_legal_notice.dart';
import 'widgets/onboarding_page_content.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onFinished;
  const OnboardingScreen({super.key, this.onFinished});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isNavigating = false;

  void _finishOnboarding() {
    if (_isNavigating) return;
    _isNavigating = true;
    SharedPreferences.getInstance().then((p) => p.setBool(AppStrings.keyOnboardingCompleted, true));
    if (widget.onFinished != null) return widget.onFinished!();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, a, _) => const MainWebViewScreen(),
        transitionsBuilder: (context, a, _, child) => FadeTransition(opacity: a, child: child),
      ),
    );
  }

  void _onNext() => _currentIndex < OnboardingItem.items.length - 1
      ? _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut)
      : _finishOnboarding();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildWatermark() => Positioned(
    top: -40.0,
    right: -40.0,
    child: Opacity(
      opacity: 0.04,
      child: Image.asset('assets/images/app_icon.png', width: 320.0, height: 320.0, color: const Color(0xFF8B725A)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final isLast = _currentIndex == OnboardingItem.items.length - 1;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFAF6F0), Color(0xFFF3EAE0)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildWatermark(),
              Column(
                children: [
                  OnboardingHeader(onSkip: _finishOnboarding),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: OnboardingItem.items.length,
                      onPageChanged: (i) => setState(() => _currentIndex = i),
                      itemBuilder: (_, i) => OnboardingPageContent(item: OnboardingItem.items[i]),
                    ),
                  ),
                  OnboardingDots(count: OnboardingItem.items.length, activeIndex: _currentIndex),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: LuxuryButton(
                      label: isLast ? AppStrings.startShopping : AppStrings.next,
                      icon: isLast ? Icons.arrow_back : null,
                      onPressed: _onNext,
                    ),
                  ),
                  if (isLast) const OnboardingLegalNotice() else const SizedBox(height: 8.0),
                  PoweredByHout(bottomPadding: 10.0, color: const Color(0xFF8B725A).withValues(alpha: 0.65)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
