class Task {
  final String id, title, project, status;
  final bool done;
  final DateTime createdAt;
  Task({required this.id, required this.title, this.project='', this.status='todo', this.done=false, required this.createdAt});
  Map<String,dynamic> toMap()=>{'id':id,'title':title,'project':project,'status':status,'done':done,'createdAt':createdAt.toIso8601String()};
  factory Task.fromMap(Map m)=>Task(id:m['id'],title:m['title'],project:m['project']??'',status:m['status']??'todo',done:m['done']??false,createdAt:DateTime.tryParse(m['createdAt']??'')??DateTime.now());
}
class TransactionModel {
  final String id, walletId, title, type; final double amount; final DateTime date;
  TransactionModel({required this.id,required this.walletId,required this.title,required this.type,required this.amount,required this.date});
  Map<String,dynamic> toMap()=>{'id':id,'walletId':walletId,'title':title,'type':type,'amount':amount,'date':date.toIso8601String()};
}
