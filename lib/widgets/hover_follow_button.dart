import 'package:echo/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HoverFollowButton extends StatefulWidget {
  final String count;
  final String label;
  final VoidCallback onTap;

  const HoverFollowButton({
    super.key,
    required this.count,
    required this.label,
    required this.onTap,
  });

  @override
  State<HoverFollowButton> createState() => _HoverFollowButtonState();
}

class _HoverFollowButtonState extends State<HoverFollowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // يغير شكل مؤشر الماوس ليد عند الوقوف عليه 👆
      onEnter: (_) => setState(() => _isHovered = true),  // يبدأ الـ Hover
      onExit: (_) => setState(() => _isHovered = false),  // ينتهي الـ Hover
      child: InkWell(
        onTap: widget.onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent, // إلغاء تأثيرات الضغط الرمادية للحفاظ على ستايل تويتر النظيف
        child: Row(
          children: [
            Text(
              widget.count,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              widget.label,
              style: TextStyle(
                color: AppColor.greyForText,
                fontSize: 14,
                // هنا تكمن السحر: إذا كان الماوس فوق الكلمة، يوضع خط سفلي إضافي
                decoration: _isHovered ? TextDecoration.underline : TextDecoration.none,
                decorationColor: AppColor.greyForText, // لون الخط السفلي مطابق للنص
              ),
            ),
          ],
        ),
      ),
    );
  }
}