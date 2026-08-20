
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/n_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/app_models.dart';
import '../providers/task_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class TaskDetailScreen extends ConsumerStatefulWidget { final TaskModel task; const TaskDetailScreen({super.key, required this.task}); @override ConsumerState<TaskDetailScreen> createState()=>_TaskDetailScreenState(); }
class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen>{
  int _sec=25*60; Timer? _timer; bool _run=false; final _notif=FlutterLocalNotificationsPlugin();
  @override void initState(){ super.initState(); _notif.initialize(const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'))); }
  void _toggle(){ if(_run){ _timer?.cancel(); setState(()=>_run=false);} else { setState(()=>_run=true); _timer=Timer.periodic(const Duration(seconds:1), (t){ if(_sec==0){ t.cancel(); setState(()=>_run=false); widget.task.pomodoroCount++; ref.read(tasksBoxProvider).put(widget.task.id, widget.task.toMap()); _notif.show(0,'انتهى البومودورو 🍅','أحسنت! خذ استراحة', const NotificationDetails(android: AndroidNotificationDetails('nizam','Nizam'))); setState(()=>_sec=25*60);} else setState(()=>_sec--); }); } }
  String _fmt(int s){ final m=s~/60; final sec=s%60; return '\${m.toString().padLeft(2,'0')}:\${sec.toString().padLeft(2,'0')}'; }
  @override void dispose(){ _timer?.cancel(); super.dispose(); }
  @override Widget build(BuildContext context){ final task=widget.task; return Scaffold(appBar: AppBar(title: Text(task.title)), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children:[NCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(task.title, style: const TextStyle(fontSize:20, fontWeight: FontWeight.w800)), const SizedBox(height:8), Text(task.desc??'لا يوجد وصف', style: const TextStyle(color:Colors.grey))])), const SizedBox(height:16), NCard(child: Column(children:[const Text('بومودورو تايمر', style: TextStyle(fontWeight: FontWeight.w800, fontSize:18)), const SizedBox(height:24), Stack(alignment: Alignment.center, children:[SizedBox(width:180,height:180, child: CircularProgressIndicator(value:_sec/(25*60), strokeWidth:8, backgroundColor:Colors.grey.shade200, valueColor: const AlwaysStoppedAnimation(AppColors.primary))), Text(_fmt(_sec), style: const TextStyle(fontSize:40, fontWeight: FontWeight.w900))]), const SizedBox(height:24), SizedBox(width:double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _run? AppColors.warning: AppColors.primary, foregroundColor:Colors.white, padding: const EdgeInsets.symmetric(vertical:16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), onPressed:_toggle, child: Text(_run?'إيقاف':'بدء التركيز 25 دقيقة', style: const TextStyle(fontWeight: FontWeight.w800))))]))]))); }
}
