
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
class GlassNav extends StatelessWidget {
  final int currentIndex; final Function(int) onTap;
  const GlassNav({super.key, required this.currentIndex, required this.onTap});
  @override Widget build(BuildContext context){
    final isDark = Theme.of(context).brightness==Brightness.dark;
    return ClipRRect(borderRadius: BorderRadius.circular(32), child: BackdropFilter(filter: ImageFilter.blur(sigmaX:20, sigmaY:20), child: Container(height:72, margin: const EdgeInsets.symmetric(horizontal:16, vertical:12), padding: const EdgeInsets.symmetric(horizontal:8), decoration: BoxDecoration(color: isDark? Colors.black.withOpacity(0.6): Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(32), border: Border.all(color: isDark? Colors.white.withOpacity(0.1): Colors.black.withOpacity(0.06))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      _item(0, Icons.dashboard_rounded, 'الرئيسية'),
      _item(1, Icons.check_circle_rounded, 'مهام'),
      _item(2, Icons.wallet_rounded, 'مالية'),
      _item(3, Icons.repeat_rounded, 'عادات'),
      _item(4, Icons.lock_rounded, 'خزنة'),
    ]))));
  }
  Widget _item(int idx, IconData icon, String label){
    final sel = idx==currentIndex;
    return GestureDetector(onTap: ()=>onTap(idx), child: AnimatedContainer(duration: const Duration(milliseconds:250), padding: const EdgeInsets.symmetric(horizontal:14, vertical:8), decoration: BoxDecoration(color: sel? AppColors.primary: Colors.transparent, borderRadius: BorderRadius.circular(20)), child: Row(children: [Icon(icon, size:20, color: sel? Colors.white: Colors.grey), if(sel)...[const SizedBox(width:6), Text(label, style: const TextStyle(color: Colors.white, fontSize:12, fontWeight: FontWeight.w700))]])));
  }
}
