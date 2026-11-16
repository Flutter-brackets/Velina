import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/powered_by_hout.dart';
import '../onboarding/onboarding_screen.dart';
import '../webview/main_webview_screen.dart';
import 'widgets/splash_monogram_section.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();
    _navTimer = Timer(const Duration(milliseconds: 2200), _navigateNext);
  }

  Future<void> _navigateNext() async {
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final isDone = prefs.getBool(AppStrings.keyOnboardingCompleted) ?? false;
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, a, _) =>
            isDone ? const MainWebViewScreen() : const OnboardingScreen(),
        transitionsBuilder: (context, a, _, child) =>
            FadeTransition(opacity: a, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFF6EFE6)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(child: SplashMonogramSection(controller: _ctrl)),
              const Align(
                alignment: Alignment.bottomCenter,
                child: PoweredByHout(bottomPadding: 20.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
