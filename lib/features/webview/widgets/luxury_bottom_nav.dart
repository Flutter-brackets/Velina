import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

/// Floating oval luxury bottom navigation bar without BackdropFilter for maximum frame rate.
class LuxuryBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const LuxuryBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: AppStrings.navHome),
    _NavItem(icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag, label: AppStrings.navCart),
    _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: AppStrings.navProfile),
    _NavItem(icon: Icons.search_rounded, activeIcon: Icons.search, label: AppStrings.navSearch),
  ];

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        height: 58.0,
        margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 14.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.0),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.16), blurRadius: 16.0, offset: const Offset(0, 6)),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.0),
            color: const Color(0xFF8B725A).withValues(alpha: 0.94),
            border: Border.all(color: Colors.white.withValues(alpha: 0.24), width: 1.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final isSelected = index == selectedIndex;
              final item = _items[index];
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTabSelected(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSelected ? item.activeIcon : item.icon,
                      size: 21.0,
                      color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.78),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.78),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}
