import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme.dart';

class GlassNav extends StatelessWidget {
  final int index; final ValueChanged<int> onTap;
  const GlassNav({super.key,required this.index,required this.onTap});
  @override Widget build(BuildContext context)=>ClipRRect(
    borderRadius: BorderRadius.circular(28),
    child: BackdropFilter(filter: ImageFilter.blur(sigmaX:18,sigmaY:18),
      child: NavigationBar(selectedIndex:index,onDestinationSelected:onTap,
        backgroundColor: Theme.of(context).brightness==Brightness.dark?Colors.black.withOpacity(.45):Colors.white.withOpacity(.65),
        destinations: const [
          NavigationDestination(icon:Icon(LucideIcons.layoutDashboard),label:'الرئيسية'),
          NavigationDestination(icon:Icon(LucideIcons.checkSquare),label:'المهام'),
          NavigationDestination(icon:Icon(LucideIcons.walletCards),label:'المال'),
          NavigationDestination(icon:Icon(LucideIcons.activity),label:'العادات'),
          NavigationDestination(icon:Icon(LucideIcons.settings),label:'الإعدادات'),
        ])));
}
class NCard extends StatelessWidget {
  final Widget child; final EdgeInsets padding;
  const NCard({super.key,required this.child,this.padding=const EdgeInsets.all(18)});
  @override Widget build(BuildContext context)=>Card(
    child: Padding(padding:padding,child:child));
}
class NButton extends StatelessWidget {
  final String label; final VoidCallback onTap; final IconData? icon;
  const NButton({super.key,required this.label,required this.onTap,this.icon});
  @override Widget build(BuildContext context)=>FilledButton.icon(onPressed:onTap,icon:Icon(icon??LucideIcons.plus),label:Text(label));
}
