
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'core/widgets/glass_nav.dart';
import 'features/tasks/screens/tasks_list_screen.dart';
import 'features/finance/screens/finance_dashboard.dart';
import 'features/habits/screens/habits_screen.dart';
import 'features/vault/screens/vault_locked_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/search/screens/global_search_screen.dart';
import 'features/goals/screens/goals_timeline_screen.dart';
import 'features/journal/screens/journal_calendar_screen.dart';
import 'features/knowledge/screens/knowledge_screen.dart';
import 'features/statistics/screens/statistics_screen.dart';
final themeProvider = StateProvider<ThemeMode>((ref)=>ThemeMode.system);
class NizamApp extends ConsumerWidget { const NizamApp({super.key}); @override Widget build(BuildContext context, WidgetRef ref){ final mode=ref.watch(themeProvider); return MaterialApp(title:'Nizam OS', debugShowCheckedModeBanner:false, theme:AppTheme.light, darkTheme:AppTheme.dark, themeMode:mode, locale: const Locale('ar'), builder: (c,ch)=>Directionality(textDirection: TextDirection.rtl, child: ch!), home: const SplashScreen()); } }
class MainShell extends StatefulWidget { const MainShell({super.key}); @override State<MainShell> createState()=>_MainShellState(); }
class _MainShellState extends State<MainShell>{ int _index=0; final _pages=[const DashboardScreen(), const TasksListScreen(), const FinanceDashboard(), const HabitsScreen(), const VaultLockedScreen()]; void _open(int i){ Navigator.of(context).push(MaterialPageRoute(builder: (_){ switch(i){ case 0: return const GoalsTimelineScreen(); case 1: return const JournalCalendarScreen(); case 2: return const KnowledgeScreen(); case 3: return const GlobalSearchScreen(); case 4: return const StatisticsScreen(); case 5: return const SettingsScreen(); default: return const SettingsScreen(); } })); } @override Widget build(BuildContext context){ return Scaffold(drawer: Drawer(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24), bottomLeft: Radius.circular(24))), child: ListView(padding: const EdgeInsets.all(20), children: [const SizedBox(height:30), const Center(child: Text('نظام', style: TextStyle(fontSize:32, fontWeight: FontWeight.w900, color: Color(0xFF7C3AED)))), const SizedBox(height:8), const Center(child: Text('نظام التشغيل الشخصي', style: TextStyle(color: Colors.grey))), const SizedBox(height:24), const Divider(), ListTile(leading: const Icon(Icons.flag_rounded, color: Color(0xFF7C3AED)), title: const Text('الأهداف'), onTap: (){Navigator.pop(context); _open(0);}), ListTile(leading: const Icon(Icons.book_rounded, color: Color(0xFF7C3AED)), title: const Text('المفكرة'), onTap: (){Navigator.pop(context); _open(1);}), ListTile(leading: const Icon(Icons.lightbulb_rounded, color: Color(0xFF7C3AED)), title: const Text('المعرفة'), onTap: (){Navigator.pop(context); _open(2);}), ListTile(leading: const Icon(Icons.search_rounded, color: Color(0xFF7C3AED)), title: const Text('بحث شامل'), onTap: (){Navigator.pop(context); _open(3);}), ListTile(leading: const Icon(Icons.bar_chart_rounded, color: Color(0xFF7C3AED)), title: const Text('الإحصائيات'), onTap: (){Navigator.pop(context); _open(4);}), ListTile(leading: const Icon(Icons.settings_rounded, color: Color(0xFF7C3AED)), title: const Text('الإعدادات والنسخ'), onTap: (){Navigator.pop(context); _open(5);}),])), appBar: AppBar(title: const Text('نظام OS', style: TextStyle(fontWeight: FontWeight.w800)), actions: [IconButton(icon: const Icon(Icons.search_rounded), onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const GlobalSearchScreen()))), IconButton(icon: const Icon(Icons.insights_rounded), onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const StatisticsScreen())))]), body: _pages[_index], bottomNavigationBar: GlassNav(currentIndex: _index, onTap: (i)=>setState(()=>_index=i))); } }
