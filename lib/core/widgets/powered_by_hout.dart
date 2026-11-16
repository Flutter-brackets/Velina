import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

/// Pinned footer badge: "Powered by Hout" with luxury Warm Mocha typography.
class PoweredByHout extends StatelessWidget {
  final double bottomPadding;
  final Color? color;

  const PoweredByHout({
    super.key,
    this.bottomPadding = 20.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Text(
        AppStrings.poweredBy,
        style: TextStyle(
          color: color ?? const Color(0xFF8B725A).withValues(alpha: 0.75),
          fontSize: 11.5,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
