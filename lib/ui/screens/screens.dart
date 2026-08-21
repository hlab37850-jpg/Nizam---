import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

import '../../core/models.dart';
import '../../core/storage.dart';
import '../../core/theme.dart';
import '../../providers/app_provider.dart';
import '../../services/vault.dart';
import '../widgets/common.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(milliseconds: 900),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const OnboardingScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _Logo(),
            const SizedBox(height: 18),
            Text(
              'Nizam OS',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      height: 86,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.purple,
      ),
      child: const Center(
        child: Text(
          'ن',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingState();
}

class _OnboardingState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int page = 0;

  final pages = const [
    (
      'نظامك الشخصي',
      'إدارة المهام والمال والعادات والمعرفة في مكان واحد.',
    ),
    (
      'خصوصيتك أولاً',
      'بياناتك محلية ومشفرة، ولا تحتاج إلى Firebase.',
    ),
    (
      'ابدأ الآن',
      'ابنِ يومك حول أهدافك وبياناتك الحقيقية.',
    ),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: pages.length,
                onPageChanged: (value) {
                  setState(() => page = value);
                },
                itemBuilder: (context, index) {
                  final item = pages[index];

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _Logo(),
                          const SizedBox(height: 30),
                          Text(
                            item.$1,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            item.$2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => Container(
                  width: 9,
                  height: 9,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == page
                        ? AppTheme.purple
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: NButton(
                  label: page == pages.length - 1
                      ? 'دخول Nizam OS'
                      : 'التالي',
                  onTap: () {
                    if (page == pages.length - 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Shell(),
                        ),
                      );
                    } else {
                      controller.nextPage(
                        duration:
                            const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
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

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;

  final pages = const [
    DashboardScreen(),
    TasksScreen(),
    FinanceScreen(),
    HabitsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(
          10,
          0,
          10,
          10,
        ),
        child: GlassNav(
          index: index,
          onTap: (value) {
            setState(() => index = value);
          },
        ),
      ),
    );
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final tasks = ref.watch(tasksProvider);
    final balance = ref.watch(financeProvider);
    final done = tasks.where((x) => x.done).length;

    final productivity = tasks.isEmpty
        ? 0
        : (done * 100 / tasks.length).round();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(18),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مساء الخير 👋',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium,
                      ),
                      Text(
                        'Nizam OS',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                  const _Logo(),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              18,
              0,
              18,
              18,
            ),
            sliver: SliverGrid(
              delegate: SliverChildListDelegate(
                [
                  _Stat(
                    'المهام',
                    '$done/${tasks.length}',
                    Icons.check_circle_outline,
                  ),
                  _Stat(
                    'الرصيد',
                    balance.toStringAsFixed(2),
                    Icons.account_balance_wallet_outlined,
                  ),
                  const _Stat(
                    'العادات',
                    '0',
                    Icons.local_fire_department_outlined,
                  ),
                  _Stat(
                    'الإنتاجية',
                    '$productivity%',
                    Icons.trending_up,
                  ),
                ],
              ),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.45,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            sliver: SliverToBoxAdapter(
              child: NCard(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مهام اليوم',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge,
                    ),
                    const SizedBox(height: 12),
                    if (tasks.isEmpty)
                      const Text('لا توجد مهام بعد.'),
                    ...tasks.take(5).map(
                      (task) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(task.title),
                        subtitle: task.project.isEmpty
                            ? null
                            : Text(task.project),
                        leading: Icon(
                          task.done
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: task.done
                              ? AppTheme.green
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(18),
            sliver: SliverToBoxAdapter(
              child: NCard(
                child: SizedBox(
                  height: 170,
                  child: LineChart(
                    LineChartData(
                      gridData:
                          const FlGridData(show: false),
                      titlesData:
                          const FlTitlesData(show: false),
                      borderData:
                          FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          barWidth: 3,
                          dotData:
                              const FlDotData(show: false),
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
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _Stat(
    this.title,
    this.value,
    this.icon,
  );

  @override
  Widget build(BuildContext context) {
    return NCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppTheme.purple,
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(title),
        ],
      ),
    );
  }
}

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final tasks = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task OS'),
        actions: [
          IconButton(
            onPressed: () => _addTask(context, ref),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          for (final status in [
            'todo',
            'doing',
            'done',
          ])
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 12),
              child: NCard(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      status == 'todo'
                          ? 'To Do'
                          : status == 'doing'
                              ? 'Doing'
                              : 'Done',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge,
                    ),
                    ...tasks
                        .where(
                          (task) =>
                              task.status == status,
                        )
                        .map(
                          (task) => ListTile(
                            title: Text(task.title),
                            subtitle: task.project.isEmpty
                                ? null
                                : Text(task.project),
                            leading: Checkbox(
                              value: task.done,
                              onChanged: (_) {
                                ref
                                    .read(
                                      tasksProvider
                                          .notifier,
                                    )
                                    .toggle(task);
                              },
                            ),
                            trailing:
                                PopupMenuButton<String>(
                              onSelected: (value) {
                                ref
                                    .read(
                                      tasksProvider
                                          .notifier,
                                    )
                                    .move(
                                      task,
                                      value,
                                    );
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                  value: 'todo',
                                  child: Text('To Do'),
                                ),
                                PopupMenuItem(
                                  value: 'doing',
                                  child: Text('Doing'),
                                ),
                                PopupMenuItem(
                                  value: 'done',
                                  child: Text('Done'),
                                ),
                              ],
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

void _addTask(
  BuildContext context,
  WidgetRef ref,
) {
  final controller = TextEditingController();

  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('مهمة جديدة'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'عنوان المهمة',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () async {
              final title =
                  controller.text.trim();

              if (title.isEmpty) return;

              await ref
                  .read(tasksProvider.notifier)
                  .add(title);

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      );
    },
  );
}

class FinanceScreen extends ConsumerStatefulWidget {
  const FinanceScreen({super.key});

  @override
  ConsumerState<FinanceScreen> createState() =>
      _FinanceScreenState();
}

class _FinanceScreenState
    extends ConsumerState<FinanceScreen> {
  String type = 'expense';

  List<Map<String, dynamic>> get transactions {
    final box = Storage.box('transactions');

    return box.values
        .whereType<Map>()
        .map(
          (value) =>
              Map<String, dynamic>.from(value),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final values = transactions;

    final income = values
        .where((m) => m['type'] == 'income')
        .fold<double>(
          0,
          (sum, m) =>
              sum +
              ((m['amount'] as num?)?.toDouble() ?? 0),
        );

    final expense = values
        .where((m) => m['type'] == 'expense')
        .fold<double>(
          0,
          (sum, m) =>
              sum +
              ((m['amount'] as num?)?.toDouble() ?? 0),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance OS'),
        actions: [
          IconButton(
            onPressed: () => _addTransaction(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NCard(
            child: Column(
              children: [
                Text(
                  'الرصيد الحقيقي',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),
                Text(
                  (income - expense)
                      .toStringAsFixed(2),
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: income,
                          title: 'دخل',
                        ),
                        PieChartSectionData(
                          value: expense,
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
                Text(
                  'المعاملات',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),
                ...values.reversed.take(20).map(
                  (value) => ListTile(
                    title: Text(
                      value['title']?.toString() ?? '',
                    ),
                    subtitle: Text(
                      value['type']?.toString() ?? '',
                    ),
                    trailing: Text(
                      '${value['amount'] ?? 0}',
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

  Future<void> _addTransaction(
    BuildContext context,
  ) async {
    final title = TextEditingController();
    final amount = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('معاملة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                decoration:
                    const InputDecoration(
                  labelText: 'الوصف',
                ),
              ),
              TextField(
                controller: amount,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration:
                    const InputDecoration(
                  labelText: 'المبلغ',
                ),
              ),
              DropdownButton<String>(
                value: type,
                items: const [
                  DropdownMenuItem(
                    value: 'expense',
                    child: Text('مصروف'),
                  ),
                  DropdownMenuItem(
                    value: 'income',
                    child: Text('دخل'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => type = value);
                },
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () async {
                final value =
                    double.tryParse(
                  amount.text.trim(),
                );

                if (title.text.trim().isEmpty ||
                    value == null) {
                  return;
                }

                await Storage.box(
                  'transactions',
                ).put(
                  const Uuid().v4(),
                  {
                    'title': title.text.trim(),
                    'amount': value,
                    'type': type,
                    'date': DateTime.now()
                        .toIso8601String(),
                  },
                );

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }

                setState(() {});
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }
}

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() =>
      _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  List<Map<String, dynamic>> get habits {
    return Storage.box('habits')
        .values
        .whereType<Map>()
        .map(
          (value) =>
              Map<String, dynamic>.from(value),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final values = habits;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit OS'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NCard(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'عاداتك',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),
                const SizedBox(height: 12),
                if (values.isEmpty)
                  const Text(
                    'أضف أول عادة لتبدأ.',
                  ),
                ...values.map(
                  (value) => ListTile(
                    title: Text(
                      value['name']?.toString() ?? '',
                    ),
                    leading: const Icon(
                      Icons.local_fire_department,
                    ),
                    trailing: Text(
                      '🔥 ${value['streak'] ?? 0}',
                    ),
                  ),
                ),
                NButton(
                  label: 'إضافة عادة',
                  onTap: () => _addHabit(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          NCard(
            child: Column(
              children: [
                const Text('الصلوات الخمس'),
                for (final prayer in [
                  'الفجر',
                  'الظهر',
                  'العصر',
                  'المغرب',
                  'العشاء',
                ])
                  CheckboxListTile(
                    value: false,
                    onChanged: (_) {},
                    title: Text(prayer),
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
                  title: const Text('الماء'),
                  trailing: Text(
                    '${Storage.box('water').get('today', defaultValue: 0)} كوب',
                  ),
                ),
                ListTile(
                  title: const Text('النوم'),
                  trailing: Text(
                    '${Storage.box('sleep').get('last', defaultValue: 0)} ساعة',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addHabit(
    BuildContext context,
  ) async {
    final controller = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('عادة'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'اسم العادة',
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () async {
                final name =
                    controller.text.trim();

                if (name.isEmpty) return;

                await Storage.box('habits').put(
                  const Uuid().v4(),
                  {
                    'name': name,
                    'streak': 0,
                    'createdAt':
                        DateTime.now()
                            .toIso8601String(),
                  },
                );

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }

                setState(() {});
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }
}

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() =>
      _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  bool unlocked = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _unlock();
  }

  Future<void> _unlock() async {
    setState(() => loading = true);

    final ok = await VaultService.unlock();

    if (!mounted) return;

    setState(() {
      unlocked = ok;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final values = Storage.box('vault')
        .values
        .whereType<Map>()
        .map(
          (value) =>
              Map<String, dynamic>.from(value),
        )
        .toList();

    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vault OS'),
      ),
      body: unlocked
          ? ListView(
              padding: const EdgeInsets.all(18),
              children: [
                ...values.map(
                  (value) => NCard(
                    child: ListTile(
                      title: Text(
                        value['title']
                                ?.toString() ??
                            '',
                      ),
                      subtitle: Text(
                        value['secret']
                                ?.toString() ??
                            '',
                      ),
                    ),
                  ),
                ),
                NButton(
                  label: 'إضافة سر',
                  onTap: () => _addSecret(context),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 64,
                  ),
                  const SizedBox(height: 12),
                  const Text('الخزنة مقفلة'),
                  NButton(
                    label: 'فتح بالبصمة',
                    onTap: _unlock,
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _addSecret(
    BuildContext context,
  ) async {
    final title = TextEditingController();
    final secret = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('سر جديد'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(
                  labelText: 'العنوان',
                ),
              ),
              TextField(
                controller: secret,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'المحتوى',
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () async {
                if (title.text.trim().isEmpty) {
                  return;
                }

                await VaultService.put(
                  title.text.trim(),
                  secret.text,
                );

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }

                setState(() {});
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }
}

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _Simple(
      title: 'Goals & Journal',
      icon: Icons.track_changes,
      body: TableCalendar(
        firstDay: DateTime.utc(2020),
        lastDay: DateTime.utc(2035),
        focusedDay: DateTime.now(),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final results = <Map<String, dynamic>>[];

    for (final name in [
      'tasks',
      'notes',
      'goals',
      'journal',
    ]) {
      for (final value in Storage.box(name).values) {
        if (value is! Map || query.trim().isEmpty) {
          continue;
        }

        final matches = value.values.any(
          (item) => item
              .toString()
              .toLowerCase()
              .contains(
                query.toLowerCase(),
              ),
        );

        if (matches) {
          results.add(
            Map<String, dynamic>.from(value),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() => query = value);
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'ابحث في كل شيء',
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: results
                  .map(
                    (value) => ListTile(
                      title: Text(
                        value['title']
                                ?.toString() ??
                            'عنصر',
                      ),
                      subtitle: Text(
                        value.values.join(' • '),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final dark = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NCard(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('الوضع الداكن'),
                  value: dark,
                  onChanged: (value) {
                    ref
                        .read(themeProvider.notifier)
                        .state = value;
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.lock_outline),
                  title: const Text('Vault OS'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const VaultScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.track_changes,
                  ),
                  title:
                      const Text('الأهداف والمفكرة'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const GoalsScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.search),
                  title:
                      const Text('البحث الشامل'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const SearchScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.download,
                  ),
                  title: const Text('نسخة JSON'),
                  onTap: () async {
                    final json =
                        await Storage.exportJson();

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم تجهيز ${json.length} حرفًا من البيانات المحلية',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Simple extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget body;

  const _Simple({
    required this.title,
    required this.icon,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: NCard(
          child: Column(
            children: [
              Icon(
                icon,
                size: 50,
                color: AppTheme.purple,
              ),
              const SizedBox(height: 12),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return _Simple(
      title: 'تفاصيل المهمة',
      icon: Icons.check_box_outlined,
      body: ListView(
        children: [
          Text(
            task.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall,
          ),
          Text(
            'المشروع: ${task.project.isEmpty ? 'بدون مشروع' : task.project}',
          ),
          Text('الحالة: ${task.status}'),
          const SizedBox(height: 20),
          NButton(
            label: 'Pomodoro 25 دقيقة',
            onTap: () => _pomodoro(context),
          ),
        ],
      ),
    );
  }

  void _pomodoro(BuildContext context) {
    int secondsLeft = 25 * 60;
    Timer? timer;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            timer ??= Timer.periodic(
              const Duration(seconds: 1),
              (_) {
                if (secondsLeft > 0) {
                  setState(() => secondsLeft--);
                }
              },
            );

            return AlertDialog(
              title: const Text('Pomodoro'),
              content: Text(
                '${secondsLeft ~/ 60}:${(secondsLeft % 60).toString().padLeft(2, '0')}',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    timer?.cancel();
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('إيقاف'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      timer?.cancel();
    });
  }
}

class WalletsScreen extends StatelessWidget {
  const WalletsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BoxList(
      title: 'Wallets',
      box: 'wallets',
      label: 'محفظة',
    );
  }
}

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BoxList(
      title: 'Budgets',
      box: 'budgets',
      label: 'ميزانية',
    );
  }
}

class DebtsScreen extends StatelessWidget {
  const DebtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BoxList(
      title: 'Debts',
      box: 'debts',
      label: 'دين',
    );
  }
}

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('متتبع الصلاة'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NCard(
            child: Column(
              children: [
                for (final prayer in [
                  'الفجر',
                  'الظهر',
                  'العصر',
                  'المغرب',
                  'العشاء',
                ])
                  CheckboxListTile(
                    value: false,
                    onChanged: (_) {},
                    title: Text(prayer),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المفكرة'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          NCard(
            child: TableCalendar(
              firstDay: DateTime.utc(2020),
              lastDay: DateTime.utc(2035),
              focusedDay: DateTime.now(),
            ),
          ),
          const SizedBox(height: 12),
          const NCard(
            child: TextField(
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'اكتب يومياتك...',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final tasks = ref.watch(tasksProvider);
    final done =
        tasks.where((task) => task.done).length;

    return _Simple(
      title: 'Statistics',
      icon: Icons.bar_chart,
      body: ListView(
        children: [
          Text(
            'إنجاز المهام: ${tasks.isEmpty ? 0 : (done * 100 / tasks.length).round()}%',
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: done.toDouble(),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY:
                            (tasks.length - done)
                                .toDouble(),
                      ),
                    ],
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

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() =>
      _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    final values = Storage.box('notes')
        .values
        .whereType<Map>()
        .map(
          (value) =>
              Map<String, dynamic>.from(value),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge'),
        actions: [
          IconButton(
            onPressed: () => _addNote(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: values
            .map(
              (value) => NCard(
                child: ListTile(
                  title: Text(
                    value['title']
                            ?.toString() ??
                        '',
                  ),
                  subtitle: Text(
                    value['body']?.toString() ?? '',
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> _addNote(
    BuildContext context,
  ) async {
    final title = TextEditingController();
    final body = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('ملاحظة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                decoration:
                    const InputDecoration(
                  labelText: 'العنوان',
                ),
              ),
              TextField(
                controller: body,
                maxLines: 4,
                decoration:
                    const InputDecoration(
                  labelText: 'النص',
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () async {
                await Storage.box('notes').put(
                  const Uuid().v4(),
                  {
                    'title': title.text.trim(),
                    'body': body.text,
                    'date': DateTime.now()
                        .toIso8601String(),
                  },
                );

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }

                setState(() {});
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }
}

class _BoxList extends StatelessWidget {
  final String title;
  final String box;
  final String label;

  const _BoxList({
    required this.title,
    required this.box,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final hiveBox = Storage.box(box);

    final values = hiveBox.values
        .whereType<Map>()
        .map(
          (value) =>
              Map<String, dynamic>.from(value),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          ...values.map(
            (value) => NCard(
              child: ListTile(
                title: Text(
                  value['name']?.toString() ??
                      label,
                ),
                subtitle: Text(
                  value['amount']?.toString() ??
                      '',
                ),
              ),
            ),
          ),
          NButton(
            label: 'إضافة $label',
            onTap: () async {
              await hiveBox.put(
                const Uuid().v4(),
                {
                  'name': label,
                  'amount': 0,
                  'createdAt':
                      DateTime.now()
                          .toIso8601String(),
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
