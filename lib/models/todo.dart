import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime? completedAt;

  @HiveField(5)
  DateTime date;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
    required this.date,
  });
}
