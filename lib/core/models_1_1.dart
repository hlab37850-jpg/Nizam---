
// Nizam OS - Complete Models
class Task {
  final String id;
  final String title;
  final String description;
  final String project;
  final String status; // todo, inProgress, done
  final bool done;
  final int pomodoroCount;
  final int priority; // 0 low, 1 med, 2 high
  final DateTime createdAt;
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.project = '',
    this.status = 'todo',
    this.done = false,
    this.pomodoroCount = 0,
    this.priority = 0,
    required this.createdAt,
    this.dueDate,
  });

  Task copyWith({
    String? title,
    String? description,
    String? project,
    String? status,
    bool? done,
    int? pomodoroCount,
    int? priority,
    DateTime? dueDate,
  }) => Task(
    id: id,
    title: title ?? this.title,
    description: description ?? this.description,
    project: project ?? this.project,
    status: status ?? this.status,
    done: done ?? this.done,
    pomodoroCount: pomodoroCount ?? this.pomodoroCount,
    priority: priority ?? this.priority,
    createdAt: createdAt,
    dueDate: dueDate ?? this.dueDate,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'project': project,
    'status': status,
    'done': done,
    'pomodoroCount': pomodoroCount,
    'priority': priority,
    'createdAt': createdAt.toIso8601String(),
    'dueDate': dueDate?.toIso8601String(),
  };

  factory Task.fromMap(Map m) => Task(
    id: m['id']?.toString() ?? '',
    title: m['title']?.toString() ?? '',
    description: m['description']?.toString() ?? '',
    project: m['project']?.toString() ?? '',
    status: m['status']?.toString() ?? 'todo',
    done: m['done'] == true,
    pomodoroCount: (m['pomodoroCount'] as num?)?.toInt() ?? 0,
    priority: (m['priority'] as num?)?.toInt() ?? 0,
    createdAt: DateTime.tryParse(m['createdAt']?.toString() ?? '') ?? DateTime.now(),
    dueDate: m['dueDate'] != null ? DateTime.tryParse(m['dueDate'].toString()) : null,
  );
}

class TransactionModel {
  final String id;
  final String walletId;
  final String title;
  final String type; // income, expense
  final String category;
  final double amount;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.walletId,
    required this.title,
    required this.type,
    this.category = 'عام',
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'walletId': walletId,
    'title': title,
    'type': type,
    'category': category,
    'amount': amount,
    'date': date.toIso8601String(),
  };

  factory TransactionModel.fromMap(Map m) => TransactionModel(
    id: m['id']?.toString() ?? '',
    walletId: m['walletId']?.toString() ?? 'main',
    title: m['title']?.toString() ?? '',
    type: m['type']?.toString() ?? 'expense',
    category: m['category']?.toString() ?? 'عام',
    amount: (m['amount'] as num?)?.toDouble() ?? 0,
    date: DateTime.tryParse(m['date']?.toString() ?? '') ?? DateTime.now(),
  );
}

class Habit {
  final String id;
  final String name;
  final int streak;
  final DateTime createdAt;
  final List<String> completedDates;
  final String icon;

  Habit({
    required this.id,
    required this.name,
    this.streak = 0,
    required this.createdAt,
    this.completedDates = const [],
    this.icon = 'activity',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'streak': streak,
    'createdAt': createdAt.toIso8601String(),
    'completedDates': completedDates,
    'icon': icon,
  };

  factory Habit.fromMap(Map m) => Habit(
    id: m['id']?.toString() ?? '',
    name: m['name']?.toString() ?? '',
    streak: (m['streak'] as num?)?.toInt() ?? 0,
    createdAt: DateTime.tryParse(m['createdAt']?.toString() ?? '') ?? DateTime.now(),
    completedDates: (m['completedDates'] as List?)?.map((e) => e.toString()).toList() ?? [],
    icon: m['icon']?.toString() ?? 'activity',
  );
}

class Wallet {
  final String id;
  final String name;
  final double balance;
  final String color;

  Wallet({required this.id, required this.name, this.balance = 0, this.color = 'purple'});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'balance': balance, 'color': color};

  factory Wallet.fromMap(Map m) => Wallet(
    id: m['id']?.toString() ?? '',
    name: m['name']?.toString() ?? '',
    balance: (m['balance'] as num?)?.toDouble() ?? 0,
    color: m['color']?.toString() ?? 'purple',
  );
}

class Budget {
  final String id;
  final String name;
  final double limit;
  final double spent;
  final String period;

  Budget({required this.id, required this.name, required this.limit, this.spent = 0, this.period = 'monthly'});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'limit': limit, 'spent': spent, 'period': period};

  factory Budget.fromMap(Map m) => Budget(
    id: m['id']?.toString() ?? '',
    name: m['name']?.toString() ?? '',
    limit: (m['limit'] as num?)?.toDouble() ?? 0,
    spent: (m['spent'] as num?)?.toDouble() ?? 0,
    period: m['period']?.toString() ?? 'monthly',
  );
}

class Debt {
  final String id;
  final String name;
  final double amount;
  final String type; // owe, owed
  final DateTime date;
  final bool paid;

  Debt({required this.id, required this.name, required this.amount, this.type = 'owe', required this.date, this.paid = false});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'amount': amount, 'type': type, 'date': date.toIso8601String(), 'paid': paid};

  factory Debt.fromMap(Map m) => Debt(
    id: m['id']?.toString() ?? '',
    name: m['name']?.toString() ?? '',
    amount: (m['amount'] as num?)?.toDouble() ?? 0,
    type: m['type']?.toString() ?? 'owe',
    date: DateTime.tryParse(m['date']?.toString() ?? '') ?? DateTime.now(),
    paid: m['paid'] == true,
  );
}

class VaultItem {
  final String id;
  final String title;
  final String secret;
  final DateTime createdAt;

  VaultItem({required this.id, required this.title, required this.secret, required this.createdAt});

  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'secret': secret, 'createdAt': createdAt.toIso8601String()};

  factory VaultItem.fromMap(Map m) => VaultItem(
    id: m['id']?.toString() ?? DateTime.now().microsecondsSinceEpoch.toString(),
    title: m['title']?.toString() ?? '',
    secret: m['secret']?.toString() ?? '',
    createdAt: DateTime.tryParse(m['createdAt']?.toString() ?? '') ?? DateTime.now(),
  );
}

class Goal {
  final String id;
  final String title;
  final double progress; // 0..1
  final DateTime createdAt;
  final DateTime? targetDate;

  Goal({required this.id, required this.title, this.progress = 0, required this.createdAt, this.targetDate});

  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'progress': progress, 'createdAt': createdAt.toIso8601String(), 'targetDate': targetDate?.toIso8601String()};

  factory Goal.fromMap(Map m) => Goal(
    id: m['id']?.toString() ?? '',
    title: m['title']?.toString() ?? '',
    progress: (m['progress'] as num?)?.toDouble() ?? 0,
    createdAt: DateTime.tryParse(m['createdAt']?.toString() ?? '') ?? DateTime.now(),
    targetDate: m['targetDate'] != null ? DateTime.tryParse(m['targetDate'].toString()) : null,
  );
}

class JournalEntry {
  final String id;
  final String content;
  final DateTime date;
  final String mood;

  JournalEntry({required this.id, required this.content, required this.date, this.mood = 'neutral'});

  Map<String, dynamic> toMap() => {'id': id, 'content': content, 'date': date.toIso8601String(), 'mood': mood};

  factory JournalEntry.fromMap(Map m) => JournalEntry(
    id: m['id']?.toString() ?? '',
    content: m['content']?.toString() ?? '',
    date: DateTime.tryParse(m['date']?.toString() ?? '') ?? DateTime.now(),
    mood: m['mood']?.toString() ?? 'neutral',
  );
}
