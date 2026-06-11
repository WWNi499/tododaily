import 'package:flutter/material.dart';
import '../models/todo.dart';

class EveningDialog extends StatelessWidget {
  final bool isAllCompleted;
  final List<Todo> todos;
  final void Function(Todo)? onToggle;

  EveningDialog({
    required this.isAllCompleted,
    required this.todos,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  isAllCompleted ? Icons.check_circle : Icons.pending_actions,
                  color: isAllCompleted ? Colors.green : Colors.blueAccent,
                  size: 32,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isAllCompleted ? '今日完美达成 🎉' : '今日检阅时间',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              isAllCompleted
                  ? '今天的任务都完成啦，好好休息 🌙'
                  : '还有任务没完成，加油冲刺 💪',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            SizedBox(height: 16),
            Container(
              constraints: BoxConstraints(maxHeight: 300),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: todos.length,
                separatorBuilder: (_, __) => Divider(height: 1),
                itemBuilder: (_, i) {
                  final t = todos[i];
                  return ListTile(
                    leading: Checkbox(
                      value: t.isCompleted,
                      onChanged: (_) => onToggle?.call(t),
                      activeColor: Colors.green,
                    ),
                    title: Text(
                      t.title,
                      style: TextStyle(
                        decoration: t.isCompleted ? TextDecoration.lineThrough : null,
                        color: t.isCompleted ? Colors.grey : Colors.black87,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                backgroundColor: isAllCompleted ? Colors.green : Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('知道了', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
