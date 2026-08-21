import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';
import '../../core/storage.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../providers/app_provider.dart';
import '../../services/vault.dart';
import '../widgets/common.dart';

// 1. Splash
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.purple),
              child: const Center(child: Text('ن', style: TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.bold))),
            ),
            const SizedBox(height: 20),
            Text('Nizam OS', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('نظام التشغيل الشخصي', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

// 2. Onboarding
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingState();
}

class _OnboardingState extends State<OnboardingScreen> {
  final PageController _page = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _page,
                onPageChanged: (i) => setState(() => _index = i),
                children: const [
                  _OnboardingPage(title: 'نظامك الشخصي', desc: 'إدارة المهام والمال والعادات في مكان واحد بتصميم عربي أصيل.'),
                  _OnboardingPage(title: 'خصوصيتك أولاً', desc: 'بياناتك محلية ومشفرة بـ Hive + SecureStorage بدون تتبع.'),
                  _OnboardingPage(title: 'ابدأ الآن', desc: 'ابن يومك حول أهدافك الحقيقية مع Kanban و Pomodoro.'),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (x) => Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: x == _index ? AppTheme.purple : Colors.grey.shade300,
                ),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: NButton(
                  label: _index == 2 ? 'دخول Nizam OS' : 'التالي',
                  onTap: () {
                    if (_index == 2) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Shell()));
                    } else {
                      _page.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String desc;
  const _OnboardingPage({required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.purple),
            child: const Center(child: Text('ن', style: TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 32),
          Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(desc, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// 3. Shell
class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;
  final _pages = const [
    DashboardScreen(),
    TasksListScreen(),
    FinanceDashboardScreen(),
    HabitsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
        child: GlassNav(index: _index, onTap: (i) => setState(() => _index = i)),
      ),
    );
  }
}

// 4. Dashboard
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final balance = ref.watch(financeProvider);
    final done = tasks.where((t) => t.done).length;
    final habits = ref.watch(habitsProvider);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(18),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('مساء الخير', style: Theme.of(context).textTheme.titleMedium),
                      Text('Nizam OS', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                    ],
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.purple),
                    child: const Center(child: Text('ن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.45,
              ),
              delegate: SliverChildListDelegate([
                StatCard(title: 'المهام', value: '$done/${tasks.length}', icon: LucideIcons.checkCircle, color: AppTheme.purple),
                StatCard(title: 'الرصيد', value: balance.toStringAsFixed(0), icon: LucideIcons.wallet, color: AppTheme.green),
                StatCard(title: 'العادات', value: '${habits.length}', icon: LucideIcons.flame, color: AppTheme.amber),
                StatCard(
                  title: 'الإنتاجية',
                  value: tasks.isEmpty ? '0%' : '${(done * 100 ~/ tasks.length)}%',
                  icon: LucideIcons.trendingUp,
                  color: AppTheme.purple,
                ),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(18),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  NCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: 'مهام اليوم',
                          actionLabel: 'Kanban',
                          onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KanbanScreen())),
                        ),
                        const SizedBox(height: 12),
                        if (tasks.isEmpty) const Text('لا توجد مهام بعد، أضف أول مهمة.'),
                        for (final t in tasks.take(5))
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(t.title),
                            subtitle: Text(t.status),
                            leading: Icon(t.done ? LucideIcons.checkCircle2 : LucideIcons.circle, color: t.done ? AppTheme.green : null),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailScreen(task: t))),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  NCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(title: 'الوصول السريع'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ActionChip(label: const Text('Kanban'), avatar: const Icon(LucideIcons.columns, size: 16), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KanbanScreen()))),
                            ActionChip(label: const Text('المحافظ'), avatar: const Icon(LucideIcons.wallet, size: 16), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletsScreen()))),
                            ActionChip(label: const Text('الميزانيات'), avatar: const Icon(LucideIcons.pieChart, size: 16), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BudgetsScreen()))),
                            ActionChip(label: const Text('الديون'), avatar: const Icon(LucideIcons.coins, size: 16), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DebtsScreen()))),
                            ActionChip(label: const Text('الصلاة'), avatar: const Icon(LucideIcons.moon, size: 16), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrayerScreen()))),
                            ActionChip(label: const Text('الأهداف'), avatar: const Icon(LucideIcons.target, size: 16), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalsTimelineScreen()))),
                            ActionChip(label: const Text('المفكرة'), avatar: const Icon(LucideIcons.bookOpen, size: 16), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JournalCalendarScreen()))),
                            ActionChip(label: const Text('الخزنة'), avatar: const Icon(LucideIcons.lock, size: 16), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VaultScreen()))),
                            ActionChip(label: const Text('الإحصائيات'), avatar: const Icon(LucideIcons.barChart3, size: 16), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatisticsScreen()))),
                            ActionChip(label: const Text('البحث'), avatar: const Icon(LucideIcons.search, size: 16), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  NCard(
                    child: SizedBox(
                      height: 170,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              barWidth: 3,
                              dotData: const FlDotData(show: false),
                              color: AppTheme.purple,
                              spots: const [
                                FlSpot(0, 2),
                                FlSpot(1, 3),
                                FlSpot(2, 2),
                                FlSpot(3, 4),
                                FlSpot(4, 3),
                                FlSpot(5, 5),
                                FlSpot(6, 4),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 5. Tasks List
class TasksListScreen extends ConsumerWidget {
  const TasksListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('المهام'),
        actions: [
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KanbanScreen())), icon: const Icon(LucideIcons.columns)),
          IconButton(onPressed: () => _showAddDialog(context, ref), icon: const Icon(LucideIcons.plus)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          for (final status in ['todo', 'doing', 'done'])
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(status == 'todo' ? 'To Do' : status == 'doing' ? 'Doing' : 'Done', style: Theme.of(context).textTheme.titleLarge),
                    const Divider(),
                    for (final t in tasks.where((x) => x.status == status))
                      ListTile(
                        title: Text(t.title),
                        subtitle: Text(t.project.isEmpty ? 'بدون مشروع' : t.project),
                        leading: Checkbox(value: t.done, onChanged: (_) => ref.read(tasksProvider.notifier).toggle(t)),
                        trailing: PopupMenuButton<String>(
                          onSelected: (s) {
                            if (s == 'delete') {
                              ref.read(tasksProvider.notifier).delete(t);
                            } else {
                              ref.read(tasksProvider.notifier).move(t, s);
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'todo', child: Text('To Do')),
                            PopupMenuItem(value: 'doing', child: Text('Doing')),
                            PopupMenuItem(value: 'done', child: Text('Done')),
                            PopupMenuItem(value: 'delete', child: Text('حذف')),
                          ],
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailScreen(task: t))),
                      ),
                    if (tasks.where((x) => x.status == status).isEmpty)
                      const Padding(padding: EdgeInsets.all(8), child: Text('فارغ')),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _showAddDialog(context, ref), child: const Icon(LucideIcons.plus)),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final projCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('مهمة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, autofocus: true, decoration: const InputDecoration(hintText: 'عنوان المهمة')),
            const SizedBox(height: 8),
            TextField(controller: projCtrl, decoration: const InputDecoration(hintText: 'المشروع (اختياري)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          FilledButton(
            onPressed: () async {
              if (titleCtrl.text.trim().isNotEmpty) {
                await ref.read(tasksProvider.notifier).add(titleCtrl.text.trim(), project: projCtrl.text.trim());
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}

// 6. Kanban
class KanbanScreen extends ConsumerWidget {
  const KanbanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Kanban')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          for (final status in ['todo', 'doing', 'done'])
            NCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(status.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(),
                  for (final t in tasks.where((x) => x.status == status))
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(t.title),
                        subtitle: Text(t.project),
                        trailing: PopupMenuButton<String>(
                          onSelected: (s) {
                            if (s == 'delete') {
                              ref.read(tasksProvider.notifier).delete(t);
                            } else {
                              ref.read(tasksProvider.notifier).move(t, s);
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'todo', child: Text('To Do')),
                            PopupMenuItem(value: 'doing', child: Text('Doing')),
                            PopupMenuItem(value: 'done', child: Text('Done')),
                            PopupMenuItem(value: 'delete', child: Text('حذف')),
                          ],
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailScreen(task: t))),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// 7. Task Detail + Pomodoro
class TaskDetailScreen extends ConsumerStatefulWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailState();
}

class _TaskDetailState extends ConsumerState<TaskDetailScreen> {
  Timer? _timer;
  int _seconds = 25 * 60;
  bool _running = false;

  void _toggleTimer() {
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
    } else {
      setState(() => _running = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_seconds > 0) {
          setState(() => _seconds--);
        } else {
          t.cancel();
          setState(() {
            _running = false;
            _seconds = 25 * 60;
          });
          ref.read(tasksProvider.notifier).incPomodoro(widget.task);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskList = ref.watch(tasksProvider);
    final task = taskList.firstWhere((e) => e.id == widget.task.id, orElse: () => widget.task);
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('الحالة: ${task.status}', style: Theme.of(context).textTheme.titleMedium),
                Text('Pomodoro: ${task.pomodoroCount}'),
                const SizedBox(height: 12),
                NButton(
                  label: task.done ? 'إعادة فتح' : 'إكمال',
                  icon: task.done ? LucideIcons.rotateCcw : LucideIcons.check,
                  onTap: () => ref.read(tasksProvider.notifier).toggle(task),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          NCard(
            child: Column(
              children: [
                Text('${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                NButton(label: _running ? 'إيقاف' : 'بدء Pomodoro', icon: _running ? LucideIcons.pause : LucideIcons.play, onTap: _toggleTimer),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _seconds = 25 * 60);
                    _timer?.cancel();
                    setState(() => _running = false);
                  },
                  icon: const Icon(LucideIcons.refreshCw),
                  label: const Text('إعادة تعيين'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 8. Finance Dashboard
class FinanceDashboardScreen extends ConsumerWidget {
  const FinanceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = ref.watch(transactionsProvider);
    final balance = ref.watch(financeProvider);
    final income = txs.where((t) => t.type == 'income').fold<double>(0, (s, t) => s + t.amount);
    final expense = txs.where((t) => t.type == 'expense').fold<double>(0, (s, t) => s + t.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('المالية'),
        actions: [
          IconButton(icon: const Icon(LucideIcons.wallet), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletsScreen()))),
          IconButton(icon: const Icon(LucideIcons.plus), onPressed: () => _showAddTx(context, ref)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NCard(
            child: Column(
              children: [
                Text('الرصيد الحقيقي', style: Theme.of(context).textTheme.titleMedium),
                Text(balance.toStringAsFixed(2), style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: balance >= 0 ? AppTheme.green : Colors.red)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(value: income == 0 ? 1 : income, title: 'دخل', color: AppTheme.green, radius: 60),
                        PieChartSectionData(value: expense == 0 ? 1 : expense, title: 'مصروف', color: AppTheme.amber, radius: 60),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: StatCard(title: 'الدخل', value: income.toStringAsFixed(0), icon: LucideIcons.trendingUp, color: AppTheme.green)),
                    const SizedBox(width: 12),
                    Expanded(child: StatCard(title: 'المصروف', value: expense.toStringAsFixed(0), icon: LucideIcons.trendingDown, color: AppTheme.amber)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          NCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: 'المعاملات', actionLabel: 'إضافة', onAction: () => _showAddTx(context, ref)),
                const SizedBox(height: 8),
                for (final m in txs.take(20))
                  ListTile(
                    title: Text(m.title),
                    subtitle: Text(m.type == 'income' ? 'دخل' : 'مصروف'),
                    trailing: Text('${m.amount}', style: TextStyle(color: m.type == 'income' ? AppTheme.green : Colors.red, fontWeight: FontWeight.bold)),
                    onTap: () => ref.read(transactionsProvider.notifier).delete(m.id),
                  ),
                if (txs.isEmpty) const Text('لا توجد معاملات بعد.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTx(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String type = 'expense';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: const Text('معاملة جديدة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'الوصف')),
              TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المبلغ')),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: type,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'expense', child: Text('مصروف')),
                  DropdownMenuItem(value: 'income', child: Text('دخل')),
                ],
                onChanged: (v) => setSt(() => type = v!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            FilledButton(
              onPressed: () async {
                final a = double.tryParse(amountCtrl.text);
                if (titleCtrl.text.isNotEmpty && a != null) {
                  await ref.read(transactionsProvider.notifier).add(titleCtrl.text, a, type);
                  if (ctx.mounted) Navigator.pop(ctx);
                }
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }
}

// 9. Wallets
class WalletsScreen extends ConsumerWidget {
  const WalletsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(walletsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('المحافظ')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          for (final w in wallets)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NCard(child: ListTile(title: Text(w.name), subtitle: Text('ID: ${w.id}'), leading: const Icon(LucideIcons.wallet))),
            ),
          const SizedBox(height: 12),
          NButton(
            label: 'إضافة محفظة',
            onTap: () {
              final ctl = TextEditingController();
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('محفظة جديدة'),
                  content: TextField(controller: ctl),
                  actions: [
                    FilledButton(
                      onPressed: () async {
                        if (ctl.text.trim().isNotEmpty) {
                          await ref.read(walletsProvider.notifier).add(ctl.text.trim());
                        }
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('حفظ'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// 10. Budgets
class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final box = Storage.box('budgets');
    final items = box.values.map((e) => Budget.fromMap(Map<String, dynamic>.from(e as Map))).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('الميزانيات')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          for (final b in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NCard(child: ListTile(title: Text(b.name), subtitle: Text('${b.spent}/${b.limit}'), trailing: Text('${((b.spent / (b.limit == 0 ? 1 : b.limit)) * 100).round()}%'))),
            ),
          if (items.isEmpty) const NCard(child: Text('لا توجد ميزانيات')),
          const SizedBox(height: 12),
          NButton(
            label: 'إضافة ميزانية',
            onTap: () {
              final name = TextEditingController();
              final limit = TextEditingController();
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('ميزانية'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(controller: name, decoration: const InputDecoration(labelText: 'الاسم')),
                      TextField(controller: limit, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الحد')),
                    ],
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () async {
                        final l = double.tryParse(limit.text);
                        if (name.text.isNotEmpty && l != null) {
                          final id = const Uuid().v4();
                          await box.put(id, Budget(id: id, name: name.text, limit: l).toMap());
                        }
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('حفظ'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// 11. Debts
class DebtsScreen extends StatelessWidget {
  const DebtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Storage.box('debts');
    final items = box.values.map((e) => Debt.fromMap(Map<String, dynamic>.from(e as Map))).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('الديون')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          for (final d in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NCard(child: ListTile(title: Text(d.name), subtitle: Text(d.type), trailing: Text('${d.amount}'))),
            ),
          if (items.isEmpty) const NCard(child: Text('لا توجد ديون')),
          const SizedBox(height: 12),
          NButton(
            label: 'إضافة دين',
            onTap: () {
              final title = TextEditingController();
              final amount = TextEditingController();
              final person = TextEditingController();
              String type = 'owed';
              showDialog(
                context: context,
                builder: (ctx) => StatefulBuilder(
                  builder: (ctx, setSt) => AlertDialog(
                    title: const Text('دين'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(controller: title, decoration: const InputDecoration(labelText: 'الوصف')),
                        TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المبلغ')),
                        TextField(controller: person, decoration: const InputDecoration(labelText: 'الشخص')),
                        DropdownButton<String>(
                          value: type,
                          items: const [
                            DropdownMenuItem(value: 'owed', child: Text('لي')),
                            DropdownMenuItem(value: 'owedTo', child: Text('علي')),
                          ],
                          onChanged: (v) => setSt(() => type = v!),
                        ),
                      ],
                    ),
                    actions: [
                      FilledButton(
                        onPressed: () async {
                          final a = double.tryParse(amount.text);
                          if (title.text.isNotEmpty && a != null) {
                            final id = const Uuid().v4();
                            await box.put(id, Debt(id: id, name: title.text.isNotEmpty ? title.text : person.text, amount: a, type: type, date: DateTime.now()).toMap());
                          }
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                        child: const Text('حفظ'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// 12. Habits
class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('العادات'),
        actions: [
          IconButton(icon: const Icon(LucideIcons.moon), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrayerScreen()))),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: 'عاداتك', actionLabel: 'إضافة', onAction: () => _addHabit(context, ref)),
                const SizedBox(height: 12),
                if (habits.isEmpty) const Text('أضف أول عادة لتبدأ.'),
                for (final h in habits)
                  ListTile(
                    title: Text(h.name),
                    subtitle: Text('Streak ${h.streak}'),
                    leading: const Icon(LucideIcons.flame),
                    trailing: IconButton(icon: const Icon(LucideIcons.check), onPressed: () => ref.read(habitsProvider.notifier).complete(h.id)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          NCard(
            child: Column(
              children: [
                const Text('ماء ونوم'),
                ListTile(
                  title: const Text('الماء اليوم'),
                  subtitle: Text('${Storage.box('water').get('today', defaultValue: 0)} كوب'),
                  trailing: IconButton(
                    icon: const Icon(LucideIcons.plus),
                    onPressed: () async {
                      final b = Storage.box('water');
                      final c = (b.get('today', defaultValue: 0) as int) + 1;
                      await b.put('today', c);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم: $c أكواب')));
                      }
                    },
                  ),
                ),
                ListTile(
                  title: const Text('النوم'),
                  subtitle: Text('${Storage.box('sleep').get('last', defaultValue: 0)} ساعة'),
                  trailing: IconButton(
                    icon: const Icon(LucideIcons.plus),
                    onPressed: () async {
                      final b = Storage.box('sleep');
                      await b.put('last', 8);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _addHabit(context, ref), child: const Icon(LucideIcons.plus)),
    );
  }

  void _addHabit(BuildContext context, WidgetRef ref) {
    final ctl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('عادة جديدة'),
        content: TextField(controller: ctl, decoration: const InputDecoration(hintText: 'اسم العادة')),
        actions: [
          FilledButton(
            onPressed: () async {
              if (ctl.text.trim().isNotEmpty) {
                await ref.read(habitsProvider.notifier).add(ctl.text.trim());
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}

// 13. Prayer
class PrayerScreen extends StatelessWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Storage.box('prayers');
    return Scaffold(
      appBar: AppBar(title: const Text('الصلاة')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NCard(
            child: Column(
              children: [
                Text('الصلوات الخمس', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                for (final p in ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'])
                  CheckboxListTile(
                    value: box.get(p, defaultValue: false) as bool,
                    onChanged: (v) async {
                      await box.put(p, v ?? false);
                    },
                    title: Text(p),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          NCard(
            child: TableCalendar(firstDay: DateTime.utc(2020), lastDay: DateTime.utc(2035), focusedDay: DateTime.now()),
          ),
        ],
      ),
    );
  }
}

// 14. Vault
class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});
  @override
  State<VaultScreen> createState() => _VaultState();
}

class _VaultState extends State<VaultScreen> {
  bool _unlocked = false;

  @override
  void initState() {
    super.initState();
    _unlock();
  }

  Future<void> _unlock() async {
    final ok = await VaultService.unlock();
    if (mounted) setState(() => _unlocked = ok);
  }

  @override
  Widget build(BuildContext context) {
    final box = Storage.box('vault');
    final items = box.values.map((e) => VaultItem.fromMap(Map<String, dynamic>.from(e as Map))).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('الخزنة')),
      body: _unlocked
          ? ListView(
              padding: const EdgeInsets.all(18),
              children: [
                for (final m in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NCard(
                      child: ListTile(
                        title: Text(m.title),
                        subtitle: Text(m.secret),
                        trailing: IconButton(
                          icon: const Icon(LucideIcons.trash2),
                          onPressed: () async {
                            await VaultService.delete(m.id);
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                NButton(label: 'إضافة سر', onTap: () => _addSecret(context)),
              ],
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.lock, size: 64),
                  const SizedBox(height: 12),
                  const Text('الخزنة مقفلة'),
                  const SizedBox(height: 12),
                  NButton(label: 'فتح بالبصمة', onTap: _unlock),
                ],
              ),
            ),
    );
  }

  void _addSecret(BuildContext context) {
    final title = TextEditingController();
    final secret = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('سر جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: title, decoration: const InputDecoration(labelText: 'العنوان')),
            TextField(controller: secret, obscureText: true, decoration: const InputDecoration(labelText: 'المحتوى')),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              if (title.text.isNotEmpty) {
                await VaultService.put(title.text, secret.text);
              }
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}

// 15. Goals Timeline
class GoalsTimelineScreen extends StatelessWidget {
  const GoalsTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Storage.box('goals');
    final goals = box.values.map((e) => Goal.fromMap(Map<String, dynamic>.from(e as Map))).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('الأهداف')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          for (final g in goals)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(g.title, style: Theme.of(context).textTheme.titleMedium),
                    Text('التقدم: ${(g.progress*100).round()}%'),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: g.progress),
                    Text('${(g.progress * 100).round()}%'),
                  ],
                ),
              ),
            ),
          if (goals.isEmpty) const NCard(child: Text('لا توجد أهداف بعد')),
          const SizedBox(height: 12),
          NButton(
            label: 'إضافة هدف',
            onTap: () {
              final title = TextEditingController();
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('هدف جديد'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(controller: title, decoration: const InputDecoration(labelText: 'العنوان')),
                    ],
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () async {
                        if (title.text.isNotEmpty) {
                          final id = const Uuid().v4();
                          await box.put(id, Goal(id: id, title: title.text, progress: 0.2, createdAt: DateTime.now()).toMap());
                        }
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('حفظ'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// 16. Journal Calendar
class JournalCalendarScreen extends StatelessWidget {
  const JournalCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Storage.box('journal');
    final entries = box.values.map((e) => JournalEntry.fromMap(Map<String, dynamic>.from(e as Map))).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('المفكرة والمزاج')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NCard(child: TableCalendar(firstDay: DateTime.utc(2020), lastDay: DateTime.utc(2035), focusedDay: DateTime.now())),
          const SizedBox(height: 12),
          for (final j in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NCard(child: ListTile(title: Text(j.content.length > 30 ? '${j.content.substring(0, 30)}...' : j.content), subtitle: Text(j.mood), trailing: Text('${j.date.day}/${j.date.month}'))),
            ),
          if (entries.isEmpty) const NCard(child: Text('لا توجد مذكرات')),
          const SizedBox(height: 12),
          NButton(
            label: 'إضافة مذكرة',
            onTap: () {
              final title = TextEditingController();
              final content = TextEditingController();
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('مذكرة جديدة'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(controller: title, decoration: const InputDecoration(labelText: 'العنوان')),
                      TextField(controller: content, decoration: const InputDecoration(labelText: 'المحتوى')),
                    ],
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () async {
                        if (title.text.isNotEmpty) {
                          final id = const Uuid().v4();
                          await box.put(id, JournalEntry(id: id, content: content.text.isNotEmpty ? content.text : title.text, date: DateTime.now()).toMap());
                        }
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('حفظ'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// 17. Search
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results = <Map<String, dynamic>>[];
    if (_query.isNotEmpty) {
      for (final name in ['tasks', 'notes', 'goals', 'journal', 'transactions']) {
        for (final v in Storage.box(name).values) {
          if (v is Map && v.values.any((x) => x.toString().toLowerCase().contains(_query.toLowerCase()))) {
            results.add(Map<String, dynamic>.from(v));
          }
        }
      }
    }
    return Scaffold(
      appBar: AppBar(title: const Text('البحث الشامل')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(prefixIcon: Icon(LucideIcons.search), hintText: 'ابحث في كل شيء...'),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                for (final m in results)
                  ListTile(
                    title: Text(m['title']?.toString() ?? 'عنصر'),
                    subtitle: Text(m.values.join(' - ').toString()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 18. Settings + Backup
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NCard(
            child: Column(
              children: [
                SwitchListTile(title: const Text('الوضع الداكن'), value: isDark, onChanged: (v) => ref.read(themeProvider.notifier).state = v),
                ListTile(leading: const Icon(LucideIcons.lock), title: const Text('الخزنة'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VaultScreen()))),
                ListTile(leading: const Icon(LucideIcons.search), title: const Text('البحث'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()))),
                ListTile(leading: const Icon(LucideIcons.barChart3), title: const Text('الإحصائيات'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatisticsScreen()))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          NCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('النسخ الاحتياطي', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                NButton(
                  label: 'تصدير JSON',
                  icon: LucideIcons.download,
                  onTap: () async {
                    final jsonStr = await Storage.exportJson();
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('نسخة JSON'),
                          content: SingleChildScrollView(child: Text(jsonStr.length > 2000 ? '${jsonStr.substring(0, 2000)}...' : jsonStr)),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق'))],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 8),
                NButton(
                  label: 'استيراد JSON',
                  icon: LucideIcons.upload,
                  filled: false,
                  onTap: () async {
                    final ctl = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('استيراد'),
                        content: TextField(controller: ctl, maxLines: 5, decoration: const InputDecoration(hintText: 'الصق JSON هنا')),
                        actions: [
                          FilledButton(
                            onPressed: () async {
                              try {
                                await Storage.importJson(ctl.text);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الاستيراد')));
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
                                }
                              }
                            },
                            child: const Text('استيراد'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                NButton(
                  label: 'مسح كل البيانات',
                  icon: LucideIcons.trash2,
                  filled: false,
                  onTap: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('تأكيد'),
                        content: const Text('هل أنت متأكد من مسح كل البيانات؟'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
                          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('مسح')),
                        ],
                      ),
                    );
                    if (ok == true) {
                      await Storage.clearAll();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم المسح')));
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const NCard(
            child: Column(
              children: [
                ListTile(title: Text('Nizam OS'), subtitle: Text('الإصدار 1.0.0 - Offline-first RTL')),
                ListTile(title: Text('المطور'), subtitle: Text('نظام التشغيل الشخصي لإدارة الحياة')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 19. Statistics
class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final txs = ref.watch(transactionsProvider);
    final done = tasks.where((t) => t.done).length;
    return Scaffold(
      appBar: AppBar(title: const Text('الإحصائيات')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('إنتاجية المهام', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(value: done.toDouble() == 0 ? 1 : done.toDouble(), title: 'منجز', color: AppTheme.green),
                        PieChartSectionData(value: (tasks.length - done).toDouble() == 0 ? 1 : (tasks.length - done).toDouble(), title: 'متبقي', color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          NCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('المالية', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      barGroups: [
                        BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: txs.where((t) => t.type == 'income').fold(0.0, (s, t) => s + t.amount), color: AppTheme.green)]),
                        BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: txs.where((t) => t.type == 'expense').fold(0.0, (s, t) => s + t.amount), color: AppTheme.amber)]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
