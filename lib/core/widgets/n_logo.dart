
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
class NLogo extends StatelessWidget {
  final double size; const NLogo({super.key, this.size=80});
  @override Widget build(BuildContext context){
    return SizedBox(width:size, height:size, child: Stack(alignment: Alignment.center, children: [
      Container(width:size, height:size, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary.withOpacity(0.2)))),
      Container(width:size*1.3, height:size*1.3, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary.withOpacity(0.08)))),
      Container(width:size*0.75, height:size*0.75, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors:[AppColors.primary, Color(0xFFA78BFA)]), boxShadow:[BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius:20, offset: Offset(0,8))]), child: Center(child: Text('ن', style: TextStyle(fontSize:size*0.45, fontWeight: FontWeight.w900, color: Colors.white)))),
      Positioned(top:4, right:size*0.2, child: Container(width:8,height:8,decoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle))),
    ]));
  }
}
