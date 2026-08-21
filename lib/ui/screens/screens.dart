import 'dart:async';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

import '../../core/storage.dart';
import '../../core/theme.dart';
import '../../providers/app_provider.dart';
import '../../services/vault.dart';
import '../widgets/common.dart';

class LogoMark extends StatelessWidget {
  const LogoMark({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppTheme.purple,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        'ن',
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.55,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LogoMark(),
            const SizedBox(height: 18),
            Text(
              'Nizam OS',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text('نظام التشغيل الشخصي'),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  static const List<Map<String, String>> _pages = [
    {
      'title': 'نظامك الشخصي',
      'body': 'المهام والمال والعادات والأهداف والمعرفة في مكان واحد.',
    },
    {
      'title': 'خصوصيتك أولاً',
      'body': 'تخزين محلي مشفر وبدون Firebase أو اعتماد على الإنترنت.',
    },
    {
      'title': 'ابدأ الآن',
      'body': 'بياناتك محفوظة على جهازك ويمكن تصديرها كنسخة JSON.',
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AppShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (value) => setState(() => _index = value),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LogoMark(size: 120),
                        const SizedBox(height: 36),
                        Text(
                          page['title']!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page['body']!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: index == _index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == _index
                        ? AppTheme.purple
                        : Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_index == _pages.length - 1) {
                      _finish();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  child: Text(
                    _index == _pages.length - 1 ? 'ابدأ' : 'التالي',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    TasksScreen(),
    FinanceScreen(),
    HabitsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: GlassNav(
          index: _index,
          onTap: (value) => setState(() => _index = value),
        ),
      ),
    );
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final balance = ref.watch(financeProvider);
    final habits = Storage.box('habits').length;
    final done = tasks.where((task) => task.done).length;
    final weeklyTasks = <FlSpot>[];
    final today = DateTime.now();
    for (var i = 6; i >= 0; i--) {
      final day = DateTime(today.year, today.month, today.day).subtract(Duration(days: i));
      final count = tasks.where((task) {
        final date = task.createdAt;
        return date.year == day.year && date.month == day.month && date.day == day.day;
      }).length;
      weeklyTasks.add(FlSpot((6 - i).toDouble(), count.toDouble()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nizam OS'),
        actions: [
          IconButton(
            tooltip: 'الإحصائيات',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const StatisticsScreen()),
              );
            },
            icon: const Icon(Icons.insights_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(financeProvider),
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text(
              'مرحباً بك 👋',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text('لوحة التحكم الشخصية'),
            const SizedBox(height: 18),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                _SummaryCard(
                  title: 'المهام',
                  value: '${tasks.length}',
                  icon: Icons.task_alt,
                  color: AppTheme.purple,
                ),
                _SummaryCard(
                  title: 'الرصيد',
                  value: balance.toStringAsFixed(2),
                  icon: Icons.account_balance_wallet_outlined,
                  color: AppTheme.green,
                ),
                _SummaryCard(
                  title: 'العادات',
                  value: '$habits',
                  icon: Icons.local_fire_department_outlined,
                  color: AppTheme.amber,
                ),
                _SummaryCard(
                  title: 'الإنتاجية',
                  value: tasks.isEmpty ? '0%' : '${((done / tasks.length) * 100).round()}%',
                  icon: Icons.bolt_outlined,
                  color: AppTheme.purple,
                ),
              ],
            ),
            const SizedBox(height: 18),
            NCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'مهام اليوم',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text('$done / ${tasks.length}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (tasks.isEmpty)
                    const Text('لا توجد مهام بعد. أضف مهمتك الأولى من Task OS.')
                  else
                    ...tasks.take(6).map(
                      (task) => CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: task.done,
                        title: Text(task.title),
                        subtitle: task.project.isEmpty ? null : Text(task.project),
                        onChanged: (_) => ref.read(tasksProvider.notifier).toggle(task),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            NCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'النشاط الأسبوعي',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 180,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            spots: weeklyTasks,
                            barWidth: 4,
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return NCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(title),
        ],
      ),
    );
  }
}

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  String _filter = 'all';

  Future<void> _addTask() async {
    final controller = TextEditingController();
    final project = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('مهمة جديدة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'اسم المهمة'),
              ),
              TextField(
                controller: project,
                decoration: const InputDecoration(labelText: 'المشروع'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
    if (saved == true && controller.text.trim().isNotEmpty) {
      await ref.read(tasksProvider.notifier).add(
            controller.text.trim(),
            project: project.text.trim(),
          );
    }
    controller.dispose();
    project.dispose();
  }

  Future<void> _pomodoro() async {
    var seconds = 25 * 60;
    Timer? timer;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            timer ??= Timer.periodic(const Duration(seconds: 1), (_) {
              if (seconds > 0) {
                setState(() => seconds--);
              } else {
                timer?.cancel();
              }
            });
            final minutes = seconds ~/ 60;
            final remainder = seconds % 60;
            return AlertDialog(
              title: const Text('Pomodoro'),
              content: Text(
                '$minutes:${remainder.toString().padLeft(2, '0')}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    timer?.cancel();
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('إغلاق'),
                ),
              ],
            );
          },
        );
      },
    );
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);
    final filtered = _filter == 'all'
        ? tasks
        : tasks.where((task) => task.status == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task OS'),
        actions: [
          IconButton(onPressed: _pomodoro, icon: const Icon(Icons.timer_outlined)),
          IconButton(onPressed: _addTask, icon: const Icon(Icons.add)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final item in const [
                  ('all', 'الكل'),
                  ('todo', 'To Do'),
                  ('doing', 'Doing'),
                  ('done', 'Done'),
                ])
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ChoiceChip(
                      label: Text(item.$2),
                      selected: _filter == item.$1,
                      onSelected: (_) => setState(() => _filter = item.$1),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (filtered.isEmpty)
            const NCard(child: Text('لا توجد مهام في هذه الحالة.'))
          else
            ...filtered.map(
              (task) => NCard(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Checkbox(
                    value: task.done,
                    onChanged: (_) => ref.read(tasksProvider.notifier).toggle(task),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(task.project.isEmpty ? task.status : task.project),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      ref.read(tasksProvider.notifier).move(task, value);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'todo', child: Text('To Do')),
                      PopupMenuItem(value: 'doing', child: Text('Doing')),
                      PopupMenuItem(value: 'done', child: Text('Done')),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  Future<void> _addTransaction() async {
    final title = TextEditingController();
    final amount = TextEditingController();
    var type = 'expense';
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('معاملة مالية'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: title,
                    decoration: const InputDecoration(labelText: 'الوصف'),
                  ),
                  TextField(
                    controller: amount,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'المبلغ'),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'expense', label: Text('مصروف')),
                      ButtonSegment(value: 'income', label: Text('دخل')),
                    ],
                    selected: {type},
                    onSelectionChanged: (value) {
                      setDialogState(() => type = value.first);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('إلغاء'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );

    final value = double.tryParse(amount.text.trim());
    if (saved == true && title.text.trim().isNotEmpty && value != null && value > 0) {
      await Storage.box('transactions').put(const Uuid().v4(), {
        'title': title.text.trim(),
        'amount': value,
        'type': type,
        'date': DateTime.now().toIso8601String(),
      });
      if (mounted) setState(() {});
    }
    title.dispose();
    amount.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final values = Storage.box('transactions').values.whereType<Map>().map(
      (value) => Map<String, dynamic>.from(value),
    ).toList();

    double income = 0;
    double expense = 0;
    for (final value in values) {
      final amount = (value['amount'] as num?)?.toDouble() ?? 0;
      if (value['type'] == 'income') {
        income += amount;
      } else {
        expense += amount;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance OS'),
        actions: [
          IconButton(onPressed: _addTransaction, icon: const Icon(Icons.add)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NCard(
            child: Column(
              children: [
                const Text('الرصيد الحقيقي'),
                const SizedBox(height: 6),
                Text(
                  (income - expense).toStringAsFixed(2),
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: income == 0 ? 0.01 : income,
                          title: 'دخل',
                        ),
                        PieChartSectionData(
                          value: expense == 0 ? 0.01 : expense,
                          title: 'مصروف',
                        ),
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
              children: [
                const ListTile(title: Text('المعاملات')),
                if (values.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('لا توجد معاملات مالية بعد.'),
                  )
                else
                  ...values.reversed.take(30).map(
                    (value) => ListTile(
                      title: Text('${value['title'] ?? ''}'),
                      subtitle: Text(
                        value['type'] == 'income' ? 'دخل' : 'مصروف',
                      ),
                      trailing: Text('${value['amount'] ?? 0}'),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: NButton(
                  label: 'المحافظ',
                  icon: Icons.account_balance_wallet_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WalletsScreen()),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: NButton(
                  label: 'الديون',
                  icon: Icons.receipt_long_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DebtsScreen()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WalletsScreen extends StatefulWidget {
  const WalletsScreen({super.key});

  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen> {
  Future<void> _add() async {
    final name = TextEditingController();
    final opening = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('محفظة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'الاسم')),
            TextField(
              controller: opening,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'الرصيد الافتتاحي'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('حفظ')),
        ],
      ),
    );
    final balance = double.tryParse(opening.text) ?? 0;
    if (saved == true && name.text.trim().isNotEmpty) {
      await Storage.box('wallets').put(const Uuid().v4(), {
        'name': name.text.trim(),
        'balance': balance,
        'createdAt': DateTime.now().toIso8601String(),
      });
      if (mounted) setState(() {});
    }
    name.dispose();
    opening.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallets = Storage.box('wallets').values.whereType<Map>().map(
      (value) => Map<String, dynamic>.from(value),
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallets'),
        actions: [IconButton(onPressed: _add, icon: const Icon(Icons.add))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          if (wallets.isEmpty)
            const NCard(child: Text('لا توجد محافظ بعد.'))
          else
            ...wallets.map(
              (wallet) => NCard(
                child: ListTile(
                  leading: const Icon(Icons.account_balance_wallet),
                  title: Text('${wallet['name'] ?? ''}'),
                  trailing: Text('${wallet['balance'] ?? 0}'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DebtsScreen extends StatefulWidget {
  const DebtsScreen({super.key});

  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  Future<void> _add() async {
    final person = TextEditingController();
    final amount = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('دين جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: person, decoration: const InputDecoration(labelText: 'الاسم')),
            TextField(
              controller: amount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'المبلغ'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('حفظ')),
        ],
      ),
    );
    final value = double.tryParse(amount.text) ?? 0;
    if (saved == true && person.text.trim().isNotEmpty && value > 0) {
      await Storage.box('debts').put(const Uuid().v4(), {
        'person': person.text.trim(),
        'amount': value,
        'paid': 0.0,
        'createdAt': DateTime.now().toIso8601String(),
      });
      if (mounted) setState(() {});
    }
    person.dispose();
    amount.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final debts = Storage.box('debts').values.whereType<Map>().map(
      (value) => Map<String, dynamic>.from(value),
    ).toList();
    final total = debts.fold<double>(
      0,
      (sum, debt) => sum + ((debt['amount'] as num?)?.toDouble() ?? 0) - ((debt['paid'] as num?)?.toDouble() ?? 0),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debts'),
        actions: [IconButton(onPressed: _add, icon: const Icon(Icons.add))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NCard(child: Text('إجمالي المستحق: ${total.toStringAsFixed(2)}')),
          const SizedBox(height: 12),
          ...debts.map(
            (debt) => NCard(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text('${debt['person'] ?? ''}'),
                trailing: Text('${debt['amount'] ?? 0}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  Future<void> _addHabit() async {
    final controller = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('عادة جديدة'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'اسم العادة'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('حفظ')),
        ],
      ),
    );
    if (saved == true && controller.text.trim().isNotEmpty) {
      await Storage.box('habits').put(const Uuid().v4(), {
        'name': controller.text.trim(),
        'streak': 0,
        'createdAt': DateTime.now().toIso8601String(),
      });
      if (mounted) setState(() {});
    }
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habits = Storage.box('habits').values.whereType<Map>().map(
      (value) => Map<String, dynamic>.from(value),
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit OS'),
        actions: [IconButton(onPressed: _addHabit, icon: const Icon(Icons.add))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NCard(
            child: Column(
              children: [
                const ListTile(title: Text('عاداتك')),
                if (habits.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('أضف أول عادة.'),
                  )
                else
                  ...habits.map(
                    (habit) => ListTile(
                      leading: const Icon(Icons.local_fire_department, color: AppTheme.amber),
                      title: Text('${habit['name'] ?? ''}'),
                      trailing: Text('🔥 ${habit['streak'] ?? 0}'),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          NCard(
            child: Column(
              children: [
                const ListTile(title: Text('متتبع الصلوات')),
                for (final prayer in const ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'])
                  PrayerTile(name: prayer),
              ],
            ),
          ),
          const SizedBox(height: 12),
          NCard(
            child: Column(
              children: [
                const ListTile(title: Text('الماء والنوم')),
                ListTile(
                  title: const Text('الماء'),
                  trailing: Text('${Storage.box('water').get('today', defaultValue: 0)} كوب'),
                ),
                ListTile(
                  title: const Text('النوم'),
                  trailing: Text('${Storage.box('sleep').get('last', defaultValue: 0)} ساعة'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PrayerTile extends StatefulWidget {
  const PrayerTile({required this.name, super.key});

  final String name;

  @override
  State<PrayerTile> createState() => _PrayerTileState();
}

class _PrayerTileState extends State<PrayerTile> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: checked,
      title: Text(widget.name),
      onChanged: (value) => setState(() => checked = value ?? false),
    );
  }
}

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  bool _unlocked = false;
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _unlock();
  }

  Future<void> _unlock() async {
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) return;
      final result = await VaultService.unlock();
      if (mounted) setState(() => _unlocked = result);
    } catch (_) {
      if (mounted) setState(() => _unlocked = false);
    }
  }

  Future<void> _addSecret() async {
    final title = TextEditingController();
    final secret = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('عنصر آمن'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: title, decoration: const InputDecoration(labelText: 'العنوان')),
            TextField(controller: secret, obscureText: true, decoration: const InputDecoration(labelText: 'المحتوى السري')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('حفظ')),
        ],
      ),
    );
    if (saved == true && title.text.trim().isNotEmpty && secret.text.isNotEmpty) {
      await VaultService.put(title.text.trim(), secret.text);
      if (mounted) setState(() {});
    }
    title.dispose();
    secret.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final values = Storage.box('vault').values.whereType<Map>().map(
      (value) => Map<String, dynamic>.from(value),
    ).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Vault OS')),
      body: _unlocked
          ? ListView(
              padding: const EdgeInsets.all(18),
              children: [
                FilledButton.icon(
                  onPressed: _addSecret,
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة عنصر آمن'),
                ),
                const SizedBox(height: 12),
                if (values.isEmpty)
                  const NCard(child: Text('الخزنة فارغة.'))
                else
                  ...values.map(
                    (value) => NCard(
                      child: ListTile(
                        leading: const Icon(Icons.lock_outline),
                        title: Text('${value['title'] ?? ''}'),
                        subtitle: const Text('محتوى مشفر محلياً'),
                      ),
                    ),
                  ),
              ],
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock, size: 72),
                  const SizedBox(height: 12),
                  const Text('الخزنة مقفلة'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _unlock,
                    child: const Text('فتح بالبصمة / قفل الجهاز'),
                  ),
                ],
              ),
            ),
    );
  }
}

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  Future<void> _addGoal() async {
    final controller = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('هدف جديد'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'اسم الهدف')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('حفظ')),
        ],
      ),
    );
    if (saved == true && controller.text.trim().isNotEmpty) {
      await Storage.box('goals').put(const Uuid().v4(), {
        'title': controller.text.trim(),
        'createdAt': DateTime.now().toIso8601String(),
      });
      if (mounted) setState(() {});
    }
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goals = Storage.box('goals').values.whereType<Map>().map(
      (value) => Map<String, dynamic>.from(value),
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals & Journal'),
        actions: [IconButton(onPressed: _addGoal, icon: const Icon(Icons.add))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const NCard(child: Text('الأهداف — Timeline')),
          const SizedBox(height: 12),
          ...goals.map(
            (goal) => NCard(
              child: ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: Text('${goal['title'] ?? ''}'),
                subtitle: Text('${goal['createdAt'] ?? ''}'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          NCard(
            child: TableCalendar<void>(
              focusedDay: DateTime.now(),
              firstDay: DateTime(2020),
              lastDay: DateTime(2100),
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) => isSameDay(day, DateTime.now()),
              onDaySelected: (_, __) {},
            ),
          ),
        ],
      ),
    );
  }
}

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  Future<void> _addEntry() async {
    final controller = TextEditingController();
    var mood = 3;
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('مذكرة جديدة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: controller, maxLines: 5, decoration: const InputDecoration(labelText: 'اكتب مذكرتك')),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: mood,
                items: [
                  for (var value = 1; value <= 5; value++)
                    DropdownMenuItem(value: value, child: Text('المزاج $value / 5')),
                ],
                onChanged: (value) => setState(() => mood = value ?? 3),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('إلغاء')),
            FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('حفظ')),
          ],
        ),
      ),
    );
    if (saved == true && controller.text.trim().isNotEmpty) {
      await Storage.box('journal').put(const Uuid().v4(), {
        'text': controller.text.trim(),
        'mood': mood,
        'date': DateTime.now().toIso8601String(),
      });
      if (mounted) setState(() {});
    }
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = Storage.box('journal').values.whereType<Map>().map(
      (value) => Map<String, dynamic>.from(value),
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        actions: [IconButton(onPressed: _addEntry, icon: const Icon(Icons.add))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          if (entries.isEmpty)
            const NCard(child: Text('لا توجد مذكرات بعد.'))
          else
            ...entries.reversed.map(
              (entry) => NCard(
                child: ListTile(
                  title: Text('${entry['text'] ?? ''}'),
                  subtitle: Text('المزاج: ${entry['mood'] ?? 3}/5 — ${entry['date'] ?? ''}'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _results = [];

  void _search(String query) {
    final all = <String>[];
    for (final boxName in Storage.boxNames) {
      for (final value in Storage.box(boxName).values) {
        if (value is Map) {
          all.addAll(value.values.map((item) => '$item'));
        } else {
          all.add('$value');
        }
      }
    }
    final normalized = query.trim().toLowerCase();
    setState(() {
      _results = normalized.isEmpty
          ? []
          : all.where((value) => value.toLowerCase().contains(normalized)).take(50).toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Global Search')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: _search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'ابحث في بياناتك',
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: _results.map((value) => ListTile(title: Text(value))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _showBackup(BuildContext context) async {
    final data = await Storage.exportJson();
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Backup JSON'),
        content: Text('حجم البيانات الجاهزة للتصدير: ${utf8.encode(data).length} بايت.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إغلاق')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NCard(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('الوضع الداكن'),
              value: dark,
              onChanged: (value) {
                Storage.box('settings').put('darkMode', value);
                ref.read(themeProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(height: 10),
          NCard(
            child: ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Vault OS'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VaultScreen()),
              ),
            ),
          ),
          NCard(
            child: ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: const Text('الأهداف والمفكرة'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GoalsScreen()),
              ),
            ),
          ),
          NCard(
            child: ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: const Text('Journal'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const JournalScreen()),
              ),
            ),
          ),
          NCard(
            child: ListTile(
              leading: const Icon(Icons.search),
              title: const Text('البحث الشامل'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              ),
            ),
          ),
          NCard(
            child: ListTile(
              leading: const Icon(Icons.data_object),
              title: const Text('نسخ احتياطي JSON'),
              onTap: () => _showBackup(context),
            ),
          ),
        ],
      ),
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = Storage.box('tasks').values.length;
    final transactions = Storage.box('transactions').values.length;
    final habits = Storage.box('habits').values.length;
    final notes = Storage.box('notes').values.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _StatTile(title: 'المهام', value: tasks),
          _StatTile(title: 'المعاملات', value: transactions),
          _StatTile(title: 'العادات', value: habits),
          _StatTile(title: 'الملاحظات', value: notes),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.title, required this.value});

  final String title;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(
              '$value',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
