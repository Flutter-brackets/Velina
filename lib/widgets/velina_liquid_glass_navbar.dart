import 'package:flutter/material.dart';
import 'glass_capsule_container.dart';

/// RTL-safe Liquid Glass Bottom Navigation Bar with direct-item pill highlight.
class VelinaLiquidGlassNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const VelinaLiquidGlassNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  static const List<_NavBarItemData> _items = [
    _NavBarItemData('الرئيسية', Icons.home_outlined, Icons.home_rounded),
    _NavBarItemData('الأقسام', Icons.grid_view_outlined, Icons.grid_view_rounded),
    _NavBarItemData('السلة', Icons.shopping_bag_outlined, Icons.shopping_bag_rounded),
    _NavBarItemData('حسابي', Icons.person_outline_rounded, Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFC5A880);
    return Container(
      color: const Color(0xFF000000),
      child: SafeArea(
        top: false,
        child: GlassCapsuleContainer(
          child: Row(
            children: List.generate(_items.length, (index) {
              final isSelected = selectedIndex == index;
              final item = _items[index];
              final color = isSelected ? gold : Colors.white.withValues(alpha: 0.75);
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTabSelected(index),
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [Colors.white.withValues(alpha: 0.16), gold.withValues(alpha: 0.22)],
                              )
                            : null,
                        border: isSelected ? Border.all(color: Colors.white.withValues(alpha: 0.40)) : null,
                        boxShadow: isSelected
                            ? [BoxShadow(color: gold.withValues(alpha: 0.25), blurRadius: 10.0)]
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedScale(
                            scale: isSelected ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(isSelected ? item.activeIcon : item.icon, size: 22.0, color: color),
                          ),
                          const SizedBox(height: 3.0),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavBarItemData {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavBarItemData(this.label, this.icon, this.activeIcon);
}
