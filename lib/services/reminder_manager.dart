import 'dart:async';
import 'package:flutter/material.dart';
import '../models/daily_record.dart';
import '../models/todo.dart';
import '../services/storage_service.dart';
import '../dialogs/morning_dialog.dart';
import '../dialogs/evening_dialog.dart';

class ReminderManager {
  final StorageService storage;
  final BuildContext Function() getContext;
  final VoidCallback? onDataChanged;
  Timer? _checkTimer;
  bool _isShowingDialog = false;

  ReminderManager({
    required this.storage,
    required this.getContext,
    this.onDataChanged,
  });

  void start() {
    _checkTimer = Timer.periodic(const Duration(minutes: 1), (_) => _checkAndShow());
    Future.delayed(const Duration(seconds: 3), _checkAndShow);
  }

  void stop() => _checkTimer?.cancel();

  void onAppResumed() => Future.delayed(const Duration(seconds: 1), _checkAndShow);

  Future<void> _checkAndShow() async {
    if (_isShowingDialog) return;
    final now = DateTime.now();
    final record = storage.getTodayRecord();

    if (_shouldShowMorning(now, record)) {
      await _showMorningDialog(record);
    } else if (_shouldShowEvening(now, record)) {
      await _showEveningDialog(record);
    }
  }

  bool _shouldShowMorning(DateTime now, DailyRecord record) {
    if (record.morningDismissed || record.noTodoToday || storage.hasTodayTodos()) return false;
    if (now.hour < 8 || now.hour >= 20) return false;
    if (record.ignoreCount >= 2) return false;
    if (record.lastIgnoreTime != null) {
      final diff = now.difference(record.lastIgnoreTime!);
      if (diff.inMinutes < 30) return false;
    }
    return true;
  }

  bool _shouldShowEvening(DateTime now, DailyRecord record) {
    if (record.eveningReviewed || !storage.hasTodayTodos() || record.eveningReminderCount >= 3) return false;
    if (now.hour < 20) return false;
    if (record.eveningReminderCount == 0 && now.hour >= 20) return true;
    if (record.eveningReminderCount == 1 && now.hour >= 22) return true;
    if (record.eveningReminderCount == 2 && now.hour >= 23) return true;
    return false;
  }

  Future<void> _showMorningDialog(DailyRecord record) async {
    _isShowingDialog = true;
    final ctx = getContext();
    final result = await showDialog<MorningDialogResult>(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => MorningDialog(
        onAdd: (title) async {
          await storage.addTodo(title);
          onDataChanged?.call();
        },
      ),
    );

    if (result == MorningDialogResult.ignored) {
      record.ignoreCount += 1;
      record.lastIgnoreTime = DateTime.now();
      await storage.updateRecord(record);
    } else if (result == MorningDialogResult.noTodo) {
      record.noTodoToday = true;
      record.morningDismissed = true;
      await storage.updateRecord(record);
    } else if (result == MorningDialogResult.added) {
      record.morningDismissed = true;
      await storage.updateRecord(record);
    }
    _isShowingDialog = false;
  }

  Future<void> _showEveningDialog(DailyRecord record) async {
    _isShowingDialog = true;
    final ctx = getContext();
    final todos = storage.getTodayTodos();
    final isAllDone = todos.every((t) => t.isCompleted);

    await showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => EveningDialog(
        isAllCompleted: isAllDone,
        todos: todos,
        onToggle: (Todo todo) async {
          await storage.toggleTodo(todo);
          onDataChanged?.call();
        },
      ),
    );

    record.eveningReminderCount += 1;
    final currentTodos = storage.getTodayTodos();
    if (currentTodos.isNotEmpty && currentTodos.every((t) => t.isCompleted)) {
      record.eveningReviewed = true;
    }
    await storage.updateRecord(record);
    _isShowingDialog = false;
  }
}
