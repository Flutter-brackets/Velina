import 'package:flutter/material.dart';
import 'glass_navbar_decoration.dart';
import 'liquid_glass_pill.dart';
import 'nav_cart_icon.dart';

/// iOS 26 Liquid Glass Bottom Navigation Bar with Tap + Horizontal Drag physics.
class CustomBottomNav extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final bool isArabic;
  final int cartCount;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    this.isArabic = true,
    this.cartCount = 0,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  double? _dragX;
  bool _isDragging = false;

  static const _tabsAr = [
    ('الرئيسية', Icons.home_outlined), ('السلة', Icons.shopping_bag_outlined),
    ('تسجيل الدخول', Icons.person_outline_rounded), ('بحث', Icons.search_rounded),
  ];
  static const _tabsEn = [
    ('Home', Icons.home_outlined), ('Cart', Icons.shopping_bag_outlined),
    ('Login', Icons.person_outline_rounded), ('Search', Icons.search_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final tabs = widget.isArabic ? _tabsAr : _tabsEn;

    return GlassNavbarDecoration(
      child: LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;
        final tabW = w / 4;
        final target = (widget.isArabic ? (3 - widget.selectedIndex) : widget.selectedIndex) * tabW;
        final pillLeft = (_dragX ?? target).clamp(4.0, w - tabW + 4.0);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (d) {
            final raw = (d.localPosition.dx / tabW).floor().clamp(0, 3);
            widget.onTabSelected(widget.isArabic ? (3 - raw) : raw);
          },
          onHorizontalDragStart: (d) => setState(() {
            _isDragging = true;
            _dragX = d.localPosition.dx - (tabW / 2);
          }),
          onHorizontalDragUpdate: (d) => setState(() => _dragX = d.localPosition.dx - (tabW / 2)),
          onHorizontalDragEnd: (_) {
            final raw = (((_dragX ?? target) + (tabW / 2)) / tabW).floor().clamp(0, 3);
            setState(() { _isDragging = false; _dragX = null; });
            widget.onTabSelected(widget.isArabic ? (3 - raw) : raw);
          },
          child: Stack(
            children: [
              LiquidGlassPill(left: pillLeft + 4.0, width: tabW - 8.0, isDragging: _isDragging),
              Directionality(
                textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: Row(
                  children: List.generate(tabs.length, (i) {
                    final sel = widget.selectedIndex == i;
                    final col = sel ? Colors.white : Colors.white.withValues(alpha: 0.78);
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            i == 1
                                ? NavCartIcon(icon: tabs[i].$2, color: col, count: widget.cartCount)
                                : Icon(tabs[i].$2, size: 21.0, color: col),
                            const SizedBox(height: 2.0),
                            Text(
                              tabs[i].$1,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.0,
                                color: col,
                                fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
