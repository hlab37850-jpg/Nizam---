import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:local_auth/local_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/storage.dart';
import '../../core/theme.dart';
import '../../providers/app_provider.dart';

class LogoMark extends StatelessWidget {
  const LogoMark({super.key, this.size = 72});
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: const BoxDecoration(
      shape: BoxShape.circle, color: AppTheme.purple,
    ),
    alignment: Alignment.center,
    child: Text('ن', style: TextStyle(
      color: Colors.white, fontSize: size * .55, fontWeight: FontWeight.w800,
    )),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashState();
}
class _SplashState extends State<SplashScreen> {
  @override void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 900), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }
  @override Widget build(BuildContext context) => Scaffold(
    body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const LogoMark(),
      const SizedBox(height: 18),
      Text('Nizam OS', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      const Text('نظام التشغيل الشخصي'),
      const SizedBox(height: 24),
      const CircularProgressIndicator(),
    ])),
  );
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override State<OnboardingScreen> createState() => _OnboardingState();
}
class _OnboardingState extends State<OnboardingScreen> {
  final controller = PageController();
  int index = 0;
  final pages = const [
    ('نظامك الشخصي', 'المهام والمال والعادات والأهداف والمعرفة في مكان واحد.'),
    ('خصوصيتك أولاً', 'تخزين محلي مشفر وبدون Firebase أو اعتماد على الإنترنت.'),
    ('ابدأ الآن', 'بياناتك الحقيقية محفوظة على جهازك ويمكن نسخها احتياطياً.'),
  ];
  @override Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Column(children: [
      Expanded(child: PageView.builder(
        controller: controller, itemCount: pages.length,
        onPageChanged: (v) => setState(() => index = v),
        itemBuilder: (_, i) => Center(child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const LogoMark(size: 86), const SizedBox(height: 28),
            Text(pages[i].$1, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(pages[i].$2, textAlign: TextAlign.center),
          ]),
        )),
      )),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) =>
        Container(width: 9, height: 9, margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(shape: BoxShape.circle, color: i == index ? AppTheme.purple : Colors.grey.shade400)))),
      Padding(padding: const EdgeInsets.all(24), child: SizedBox(width: double.infinity,
        child: FilledButton(
          onPressed: () {
            if (index == 2) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AppShell()));
            } else {
              controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
            }
          },
          child: Text(index == 2 ? 'دخول Nizam OS' : 'التالي'),
        ))),
    ])),
  );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override State<AppShell> createState() => _AppShellState();
}
class _AppShellState extends State<AppShell> {
  int index = 0;
  final screens = const [
    DashboardScreen(), TasksScreen(), FinanceScreen(), HabitsScreen(), SettingsScreen()
  ];
  @override Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: index, children: screens),
    bottomNavigationBar: NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (v) => setState(() => index = v),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'الرئيسية'),
        NavigationDestination(icon: Icon(Icons.check_circle_outline), selectedIcon: Icon(Icons.check_circle), label: 'المهام'),
        NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'المال'),
        NavigationDestination(icon: Icon(Icons.local_fire_department_outlined), selectedIcon: Icon(Icons.local_fire_department), label: 'العادات'),
        NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'الإعدادات'),
      ],
    ),
  );
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  @override Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final balance = ref.watch(financeProvider);
    final done = tasks.where((t) => t.done).length;
    return SafeArea(child: ListView(padding: const EdgeInsets.all(18), children: [
      Row(children: [
        const LogoMark(size: 52), const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Nizam OS', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const Text('نظرة سريعة على يومك'),
        ]),
      ]),
      const SizedBox(height: 18),
      GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.5,
        children: [
          StatCard('المهام', '$done / ${tasks.length}', Icons.task_alt),
          StatCard('الرصيد', balance.toStringAsFixed(2), Icons.wallet),
          StatCard('العادات', '${Storage.box('habits').length}', Icons.local_fire_department),
          StatCard('الأهداف', '${Storage.box('goals').length}', Icons.flag),
        ]),
      const SizedBox(height: 14),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('مهام اليوم', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (tasks.isEmpty) const Text('لا توجد مهام. أضف أول مهمة من Task OS.'),
        ...tasks.take(5).map((t) => CheckboxListTile(
          contentPadding: EdgeInsets.zero, value: t.done, title: Text(t.title),
          onChanged: (_) => ref.read(tasksProvider.notifier).toggle(t),
        )),
      ]))),
      const SizedBox(height: 14),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: SizedBox(height: 170,
        child: LineChart(LineChartData(
          gridData: const FlGridData(show: false), titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [LineChartBarData(
            spots: const [FlSpot(0, 2),FlSpot(1,3),FlSpot(2,2),FlSpot(3,4),FlSpot(4,3),FlSpot(5,5),FlSpot(6,4)],
            isCurved: true, barWidth: 3, dotData: const FlDotData(show: false),
          )],
        )),
      ))),
    ]));
  }
}

class StatCard extends StatelessWidget {
  const StatCard(this.title, this.value, this.icon, {super.key});
  final String title, value; final IconData icon;
  @override Widget build(BuildContext context) => Card(child: Padding(
    padding: const EdgeInsets.all(14),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: AppTheme.purple), const Spacer(),
      Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      Text(title),
    ]),
  ));
}

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});
  @override Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Task OS'), actions: [
        IconButton(onPressed: () => addTaskDialog(context, ref), icon: const Icon(Icons.add))
      ]),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        for (final status in const ['todo','doing','done'])
          Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(status == 'todo' ? 'To Do' : status == 'doing' ? 'Doing' : 'Done',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ...tasks.where((t) => t.status == status).map((t) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(t.title),
              subtitle: Text(t.project.isEmpty ? 'بدون مشروع' : t.project),
              leading: Checkbox(value: t.done, onChanged: (_) => ref.read(tasksProvider.notifier).toggle(t)),
              trailing: PopupMenuButton<String>(
                onSelected: (s) => ref.read(tasksProvider.notifier).move(t, s),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'todo', child: Text('To Do')),
                  PopupMenuItem(value: 'doing', child: Text('Doing')),
                  PopupMenuItem(value: 'done', child: Text('Done')),
                ],
              ),
            )),
          ]))),
          const SizedBox(height: 12),
      ]),
    );
  }
}

Future<void> addTaskDialog(BuildContext context, WidgetRef ref) async {
  final title = TextEditingController();
  final project = TextEditingController();
  await showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(
    title: const Text('مهمة جديدة'),
    content: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(controller: title, decoration: const InputDecoration(labelText: 'عنوان المهمة')),
      TextField(controller: project, decoration: const InputDecoration(labelText: 'المشروع')),
    ]),
    actions: [
      TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
      FilledButton(onPressed: () async {
        if (title.text.trim().isNotEmpty) {
          await ref.read(tasksProvider.notifier).add(title.text.trim(), project: project.text.trim());
        }
        if (dialogContext.mounted) Navigator.pop(dialogContext);
      }, child: const Text('حفظ')),
    ],
  ));
}

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});
  @override State<FinanceScreen> createState() => _FinanceState();
}
class _FinanceState extends State<FinanceScreen> {
  Future<void> addTransaction() async {
    final title = TextEditingController(), amount = TextEditingController();
    String type = 'expense';
    await showDialog<void>(context: context, builder: (dialogContext) => StatefulBuilder(
      builder: (context, setLocal) => AlertDialog(
        title: const Text('معاملة مالية'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: title, decoration: const InputDecoration(labelText: 'الوصف')),
          TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المبلغ')),
          DropdownButton<String>(value: type, isExpanded: true, items: const [
            DropdownMenuItem(value: 'expense', child: Text('مصروف')),
            DropdownMenuItem(value: 'income', child: Text('دخل')),
          ], onChanged: (v) => setLocal(() => type = v ?? 'expense')),
        ]),
        actions: [
          FilledButton(onPressed: () async {
            final value = double.tryParse(amount.text);
            if (title.text.trim().isNotEmpty && value != null && value > 0) {
              await Storage.box('transactions').put(const Uuid().v4(), {
                'title': title.text.trim(), 'amount': value, 'type': type,
                'date': DateTime.now().toIso8601String(),
              });
              if (dialogContext.mounted) Navigator.pop(dialogContext);
              setState(() {});
            }
          }, child: const Text('حفظ')),
        ],
      ),
    ));
  }
  @override Widget build(BuildContext context) {
    final values = Storage.box('transactions').values.whereType<Map>()
      .map((e) => Map<String,dynamic>.from(e)).toList();
    double income = 0, expense = 0;
    for (final m in values) {
      final a = (m['amount'] as num?)?.toDouble() ?? 0;
      if (m['type'] == 'income') {
        income += a;
      } else {
        expense += a;
      }
    }
    return Scaffold(appBar: AppBar(title: const Text('Finance OS'), actions: [
      IconButton(onPressed: addTransaction, icon: const Icon(Icons.add))
    ]), body: ListView(padding: const EdgeInsets.all(18), children: [
      Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
        const Text('الرصيد الحقيقي'),
        Text((income-expense).toStringAsFixed(2), style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(height: 180, child: PieChart(PieChartData(
          sections: [
            PieChartSectionData(value: income == 0 ? 0.01 : income, title: 'دخل'),
            PieChartSectionData(value: expense == 0 ? 0.01 : expense, title: 'مصروف'),
          ],
        ))),
      ]))),
      const SizedBox(height: 12),
      Card(child: Column(children: [
        const ListTile(title: Text('المعاملات')),
        ...values.reversed.take(30).map((m) => ListTile(
          title: Text('${m['title'] ?? ''}'),
          subtitle: Text(m['type'] == 'income' ? 'دخل' : 'مصروف'),
          trailing: Text('${m['amount']}'),
        )),
      ])),
    ]));
  }
}

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});
  @override State<HabitsScreen> createState() => _HabitsState();
}
class _HabitsState extends State<HabitsScreen> {
  Future<void> addHabit() async {
    final controller = TextEditingController();
    await showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(
      title: const Text('عادة جديدة'),
      content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'اسم العادة')),
      actions: [FilledButton(onPressed: () async {
        if (controller.text.trim().isNotEmpty) {
          await Storage.box('habits').put(const Uuid().v4(), {
            'name': controller.text.trim(), 'streak': 0,
            'createdAt': DateTime.now().toIso8601String(),
          });
        }
        if (dialogContext.mounted) Navigator.pop(dialogContext);
        setState(() {});
      }, child: const Text('حفظ'))],
    ));
  }
  @override Widget build(BuildContext context) {
    final habits = Storage.box('habits').values.whereType<Map>().map((e) => Map<String,dynamic>.from(e)).toList();
    return Scaffold(appBar: AppBar(title: const Text('Habit OS'), actions: [
      IconButton(onPressed: addHabit, icon: const Icon(Icons.add))
    ]), body: ListView(padding: const EdgeInsets.all(18), children: [
      Card(child: Column(children: [
        const ListTile(title: Text('عاداتك')),
        if (habits.isEmpty) const Padding(padding: EdgeInsets.all(16), child: Text('أضف أول عادة.')),
        ...habits.map((m) => ListTile(
          leading: const Icon(Icons.local_fire_department, color: Colors.orange),
          title: Text('${m['name']}'), trailing: Text('🔥 ${m['streak'] ?? 0}'),
        )),
      ])),
      const SizedBox(height: 12),
      Card(child: Column(children: [
        const ListTile(title: Text('متتبع الصلوات')),
        for (final p in const ['الفجر','الظهر','العصر','المغرب','العشاء'])
          PrayerTile(name: p),
      ])),
      const SizedBox(height: 12),
      Card(child: Column(children: [
        const ListTile(title: Text('الماء والنوم')),
        ListTile(title: const Text('الماء'), trailing: Text('${Storage.box('water').get('today', defaultValue: 0)} كوب')),
        ListTile(title: const Text('النوم'), trailing: Text('${Storage.box('sleep').get('last', defaultValue: 0)} ساعة')),
      ])),
    ]));
  }
}
class PrayerTile extends StatefulWidget {
  const PrayerTile({required this.name, super.key}); final String name;
  @override State<PrayerTile> createState() => _PrayerTileState();
}
class _PrayerTileState extends State<PrayerTile> {
  bool checked = false;
  @override Widget build(BuildContext context) => CheckboxListTile(
    value: checked, title: Text(widget.name),
    onChanged: (v) => setState(() => checked = v ?? false),
  );
}

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});
  @override State<VaultScreen> createState() => _VaultState();
}
class _VaultState extends State<VaultScreen> {
  bool unlocked = false;
  final auth = LocalAuthentication();
  @override void initState() { super.initState(); unlock(); }
  Future<void> unlock() async {
    try {
      final supported = await auth.isDeviceSupported();
      final ok = supported ? await auth.authenticate(
        localizedReason: 'افتح خزنة Nizam OS',
        options: const AuthenticationOptions(biometricOnly: false, stickyAuth: true),
      ) : false;
      if (mounted) setState(() => unlocked = ok);
    } catch (_) {
      if (mounted) setState(() => unlocked = false);
    }
  }
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Vault OS')),
    body: Center(child: unlocked
      ? const Text('الخزنة مفتوحة — يمكنك إضافة عناصر آمنة.')
      : Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.lock, size: 72), const SizedBox(height: 12),
          const Text('الخزنة مقفلة'), const SizedBox(height: 12),
          FilledButton(onPressed: unlock, child: const Text('فتح بالبصمة / قفل الجهاز')),
        ])),
  );
}

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Goals & Journal')),
    body: ListView(padding: const EdgeInsets.all(18), children: [
      const ListTile(title: Text('الأهداف'), subtitle: Text('Timeline')),
      ...Storage.box('goals').values.whereType<Map>().map((e) => ListTile(
        leading: const Icon(Icons.flag), title: Text('${e['title'] ?? ''}'),
      )),
      const SizedBox(height: 12),
      TableCalendar(
        focusedDay: DateTime.now(), firstDay: DateTime(2020), lastDay: DateTime(2100),
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: (d) => isSameDay(d, DateTime.now()),
        onDaySelected: (_, __) {},
      ),
    ]),
  );
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override State<SearchScreen> createState() => _SearchState();
}
class _SearchState extends State<SearchScreen> {
  final controller = TextEditingController();
  List<String> results = [];
  void search(String q) {
    final all = <String>[];
    for (final boxName in Storage.boxNames) {
      for (final value in Storage.box(boxName).values) {
        if (value is Map) {
          all.addAll(value.values.map((v) => '$v'));
        } else {
          all.add('$value');
        }
      }
    }
    setState(() => results = q.trim().isEmpty ? [] : all.where((x) => x.toLowerCase().contains(q.toLowerCase())).take(50).toList());
  }
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Global Search')),
    body: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
      TextField(controller: controller, onChanged: search, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'ابحث في بياناتك')),
      Expanded(child: ListView(children: results.map((r) => ListTile(title: Text(r))).toList())),
    ])),
  );
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: ListView(padding: const EdgeInsets.all(18), children: [
      Card(child: SwitchListTile(
        title: const Text('الوضع الداكن'), value: ref.watch(themeProvider),
        onChanged: (v) {
          Storage.box('settings').put('darkMode', v);
          ref.read(themeProvider.notifier).state = v;
        },
      )),
      Card(child: ListTile(
        leading: const Icon(Icons.lock), title: const Text('Vault OS'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VaultScreen())),
      )),
      Card(child: ListTile(
        leading: const Icon(Icons.flag), title: const Text('الأهداف والمفكرة'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalsScreen())),
      )),
      Card(child: ListTile(
        leading: const Icon(Icons.search), title: const Text('البحث الشامل'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
      )),
      Card(child: ListTile(
        leading: const Icon(Icons.data_object), title: const Text('نسخ احتياطي JSON'),
        subtitle: const Text('عرض حجم النسخة الاحتياطية المحلية'),
        onTap: () async {
          final data = await Storage.exportJson();
          if (!context.mounted) return;
          showDialog(context: context, builder: (_) => AlertDialog(
            title: const Text('Backup JSON'),
            content: Text('تم تجهيز نسخة بحجم ${utf8.encode(data).length} بايت.'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق'))],
          ));
        },
      )),
    ]),
  );
}
