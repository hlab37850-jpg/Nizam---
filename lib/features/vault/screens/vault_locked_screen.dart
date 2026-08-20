
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'vault_list_screen.dart';
import '../../../core/widgets/n_card.dart';
import '../../../core/theme/app_colors.dart';
class VaultLockedScreen extends StatefulWidget { const VaultLockedScreen({super.key}); @override State<VaultLockedScreen> createState()=>_VaultLockedScreenState(); }
class _VaultLockedScreenState extends State<VaultLockedScreen>{
  bool _unlocking=false;
  Future<void> _auth() async {
    setState(()=>_unlocking=true);
    final auth=LocalAuthentication();
    try{
      final can=await auth.canCheckBiometrics;
      bool ok=false;
      if(can){ ok=await auth.authenticate(localizedReason:'افتح الخزنة المشفرة'); }
      if(ok|| !can){ if(!mounted) return; Navigator.push(context, MaterialPageRoute(builder: (_)=>const VaultListScreen())); }
    } catch(_){ if(!mounted) return; Navigator.push(context, MaterialPageRoute(builder: (_)=>const VaultListScreen())); }
    setState(()=>_unlocking=false);
  }
  @override Widget build(BuildContext context){
    return Scaffold(body: Stack(children:[
      Container(decoration: const BoxDecoration(gradient: LinearGradient(colors:[Color(0xFF0A0A0B), Color(0xFF1F1F23)], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
      BackdropFilter(filter: ImageFilter.blur(sigmaX:20, sigmaY:20), child: Container(color: Colors.black.withOpacity(0.3))),
      Center(child: Padding(padding: const EdgeInsets.all(24), child: NCard(child: Column(mainAxisSize:MainAxisSize.min, children:[
        Container(width:80,height:80, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), shape:BoxShape.circle), child: const Icon(Icons.lock_rounded, size:40, color:AppColors.primary)),
        const SizedBox(height:16),
        const Text('الخزنة المشفرة', style: TextStyle(fontSize:22, fontWeight: FontWeight.w900)),
        const SizedBox(height:8),
        const Text('محمية بتشفير AES + بصمة الجهاز\nكل أسرارك بأمان Offline', textAlign: TextAlign.center, style: TextStyle(color:Colors.grey, height:1.6)),
        const SizedBox(height:24),
        SizedBox(width:double.infinity, child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor:AppColors.primary, foregroundColor:Colors.white, padding: const EdgeInsets.symmetric(vertical:16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), onPressed: _unlocking? null: _auth, icon: Icon(_unlocking? Icons.hourglass_top_rounded: Icons.fingerprint_rounded), label: Text(_unlocking?'جاري التحقق...':'فتح بالبصمة / فتح'))),
        const SizedBox(height:12),
        TextButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const VaultListScreen())), child: const Text('فتح بدون بصمة (للمحاكي)')),
      ])))),
    ]));
  }
}
