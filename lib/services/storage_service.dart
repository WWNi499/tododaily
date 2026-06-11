import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo.dart';
import '../models/daily_record.dart';

class StorageService {
  static const String _todoBox = 'todos';
  static const String _recordBox = 'daily_records';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(DailyRecordAdapter());
    await Hive.openBox<Todo>(_todoBox);
    await Hive.openBox<DailyRecord>(_recordBox);
  }

  Box<Todo> get _todoBoxInstance => Hive.box<Todo>(_todoBox);
  Box<DailyRecord> get _recordBoxInstance => Hive.box<DailyRecord>(_recordBox);

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  List<Todo> getTodayTodos() {
    final key = _todayKey();
    return _todoBoxInstance.values
        .where((t) => _dateKey(t.date) == key)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> addTodo(String title) async {
    final now = DateTime.now();
    final todo = Todo(
      id: '${now.millisecondsSinceEpoch}',
      title: title,
      createdAt: now,
      date: DateTime(now.year, now.month, now.day),
    );
    await _todoBoxInstance.add(todo);
  }

  Future<void> toggleTodo(Todo todo) async {
    todo.isCompleted = !todo.isCompleted;
    todo.completedAt = todo.isCompleted ? DateTime.now() : null;
    await todo.save();
  }

  Future<void> deleteTodo(Todo todo) async {
    await todo.delete();
  }

  DailyRecord getTodayRecord() {
    final key = _todayKey();
    if (_recordBoxInstance.containsKey(key)) {
      return _recordBoxInstance.get(key)!;
    }
    final record = DailyRecord(dateKey: key);
    _recordBoxInstance.put(key, record);
    return record;
  }

  Future<void> updateRecord(DailyRecord record) async {
    await _recordBoxInstance.put(record.dateKey, record);
  }

  bool isTodayAllCompleted() {
    final todos = getTodayTodos();
    if (todos.isEmpty) return false;
    return todos.every((t) => t.isCompleted);
  }

  bool hasTodayTodos() => getTodayTodos().isNotEmpty;
}
