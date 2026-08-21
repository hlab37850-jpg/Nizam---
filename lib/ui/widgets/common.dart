import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme.dart';

class GlassNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const GlassNav({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: onTap,
          backgroundColor: isDark
              ? Colors.black.withOpacity(0.45)
              : Colors.white.withOpacity(0.65),
          indicatorColor: AppTheme.purple.withOpacity(0.2),
          destinations: const [
            NavigationDestination(icon: Icon(LucideIcons.layoutDashboard), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(LucideIcons.checkSquare), label: 'المهام'),
            NavigationDestination(icon: Icon(LucideIcons.walletCards), label: 'المال'),
            NavigationDestination(icon: Icon(LucideIcons.activity), label: 'العادات'),
            NavigationDestination(icon: Icon(LucideIcons.settings), label: 'الإعدادات'),
          ],
        ),
      ),
    );
  }
}

class NCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  const NCard({super.key, required this.child, this.padding = const EdgeInsets.all(18), this.onTap});

  @override
  Widget build(BuildContext context) {
    final card = Card(child: Padding(padding: padding, child: child));
    if (onTap != null) {
      return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(24), child: card);
    }
    return card;
  }
}

class NButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool filled;
  const NButton({super.key, required this.label, required this.onTap, this.icon, this.filled = true});

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return FilledButton.icon(
        onPressed: onTap,
        icon: Icon(icon ?? LucideIcons.plus, size: 18),
        label: Text(label),
      );
    }
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon ?? LucideIcons.plus, size: 18),
      label: Text(label),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  const StatCard({super.key, required this.title, required this.value, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return NCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (color ?? AppTheme.purple).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color ?? AppTheme.purple, size: 20),
          ),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        if (actionLabel != null) TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}
