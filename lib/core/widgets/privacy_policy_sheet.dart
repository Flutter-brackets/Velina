import 'package:flutter/material.dart';

/// Luxury Privacy Policy & Terms modal bottom sheet for Velina.
class PrivacyPolicySheet extends StatelessWidget {
  const PrivacyPolicySheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const PrivacyPolicySheet(),
  );

  static const _sections = [
    (Icons.lock_outline, 'حماية البيانات والخصوصية', 'نلتزم بالسرية التامة لبياناتكم الشخصية ومعلومات الدفع وعناوين التوصيل بأعلى معايير الأمان.'),
    (Icons.notifications_outlined, 'تجربة التسوق والإشعارات', 'تُستخدم التنبيهات لإطلاعكم على جديد المجموعات ومتابعة مسار طلباتكم فقط مع إمكانية التحكم بها.'),
    (Icons.verified_outlined, 'الاستبدال والاسترجاع والملكية', 'جميع المنتجات أصلية وتخضع للسياسات الرسمية لمتجر VÉLINA BOUTIQUE مع ضمان الجودة.'),
  ];

  Widget _buildCard((IconData, String, String) s) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6DACB))),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(color: const Color(0xFF8B725A).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(9)),
          child: Icon(s.$1, size: 17, color: const Color(0xFF8B725A)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.$2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E1916))),
              const SizedBox(height: 2),
              Text(s.$3, style: const TextStyle(fontSize: 11.5, color: Color(0xFF6E5D4F), height: 1.4)),
            ],
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6F0),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: const Color(0xFFC5A880).withValues(alpha: 0.35)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 44, height: 4, decoration: BoxDecoration(color: const Color(0xFF8B725A).withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFF8B725A).withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.shield_outlined, size: 19, color: Color(0xFF8B725A))),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('سياسة الخصوصية وشروط الاستخدام', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: Color(0xFF1E1916)))),
                  IconButton(icon: const Icon(Icons.close, size: 20, color: Color(0xFF8B725A)), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 6),
              Flexible(child: SingleChildScrollView(child: Column(children: _sections.map(_buildCard).toList()))),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B725A), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                  child: const Text('فهمت ذلك', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
