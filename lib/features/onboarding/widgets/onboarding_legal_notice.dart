import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/privacy_policy_sheet.dart';

/// Discreet legal notice for the final onboarding slide.
class OnboardingLegalNotice extends StatelessWidget {
  const OnboardingLegalNotice({super.key});

  @override
  Widget build(BuildContext context) {
    const linkStyle = TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w700,
      color: Color(0xFF8B725A),
      decoration: TextDecoration.underline,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(fontSize: 11.5, color: Color(0xFF8B725A), height: 1.4),
          children: [
            const TextSpan(text: 'بمتابعتك، فإنك توافق على '),
            TextSpan(
              text: 'سياسة الخصوصية',
              style: linkStyle,
              recognizer: TapGestureRecognizer()..onTap = () => PrivacyPolicySheet.show(context),
            ),
            const TextSpan(text: ' و '),
            TextSpan(
              text: 'شروط الاستخدام',
              style: linkStyle,
              recognizer: TapGestureRecognizer()..onTap = () => PrivacyPolicySheet.show(context),
            ),
          ],
        ),
      ),
    );
  }
}
