
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
class NCard extends StatelessWidget {
  final Widget child; final EdgeInsetsGeometry? padding; final VoidCallback? onTap; final Color? color;
  const NCard({super.key, required this.child, this.padding, this.onTap, this.color});
  @override Widget build(BuildContext context){
    final isDark = Theme.of(context).brightness==Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: color ?? (isDark? AppColors.surfaceDark : Colors.white),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: isDark? Colors.black26 : AppColors.cardShadow, blurRadius: 32, offset: const Offset(0,8))],
        border: Border.all(color: isDark? Colors.white.withOpacity(0.06): Colors.black.withOpacity(0.04)),
      ),
      child: Material(color: Colors.transparent, borderRadius: BorderRadius.circular(24), child: InkWell(borderRadius: BorderRadius.circular(24), onTap: onTap, child: Padding(padding: padding ?? const EdgeInsets.all(20), child: child))),
    );
  }
}
