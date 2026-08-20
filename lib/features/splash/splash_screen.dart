
import 'package:flutter/material.dart';
import '../../core/widgets/n_logo.dart';
import '../../app.dart';
import '../onboarding/onboarding_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
class SplashScreen extends StatefulWidget { const SplashScreen({super.key}); @override State<SplashScreen> createState()=>_SplashScreenState(); }
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _c; late Animation<double> _scale,_fade;
  @override void initState(){ super.initState(); _c=AnimationController(vsync:this, duration: const Duration(milliseconds:1800)); _scale=CurvedAnimation(parent:_c, curve:Curves.elasticOut); _fade=CurvedAnimation(parent:_c, curve:Curves.easeIn); _c.forward(); Future.delayed(const Duration(milliseconds:2200), _go); }
  void _go(){ final seen=Hive.box('settings').get('onboarding_seen', defaultValue:false); if(!mounted) return; Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> seen? const MainShell(): const OnboardingScreen())); }
  @override void dispose(){ _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context){ return Scaffold(body: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors:[Color(0xFFFDFCF6), Color(0xFFEDE9FE)])), child: Center(child: FadeTransition(opacity:_fade, child: ScaleTransition(scale:_scale, child: Column(mainAxisSize:MainAxisSize.min, children: [const NLogo(size:120), const SizedBox(height:24), Text('Nizam OS', style: Theme.of(context).textTheme.displayLarge), const SizedBox(height:8), const Text('نظام التشغيل الشخصي', style: TextStyle(color:Colors.grey)), const SizedBox(height:32), const SizedBox(width:24,height:24, child: CircularProgressIndicator(strokeWidth:2, color: Color(0xFF7C3AED)))])))))); }
}
