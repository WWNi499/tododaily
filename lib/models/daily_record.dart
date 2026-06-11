import 'package:hive/hive.dart';

part 'daily_record.g.dart';

@HiveType(typeId: 1)
class DailyRecord extends HiveObject {
  @HiveField(0)
  String dateKey;

  @HiveField(1)
  int ignoreCount;

  @HiveField(2)
  DateTime? lastIgnoreTime;

  @HiveField(3)
  bool morningDismissed;

  @HiveField(4)
  bool eveningReviewed;

  @HiveField(5)
  bool noTodoToday;

  @HiveField(6)
  int eveningReminderCount;

  DailyRecord({
    required this.dateKey,
    this.ignoreCount = 0,
    this.lastIgnoreTime,
    this.morningDismissed = false,
    this.eveningReviewed = false,
    this.noTodoToday = false,
    this.eveningReminderCount = 0,
  });
}
