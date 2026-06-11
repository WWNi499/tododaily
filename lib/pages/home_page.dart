import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/storage_service.dart';

class HomePage extends StatefulWidget {
  final StorageService storage;
  HomePage({required this.storage});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _inputController = TextEditingController();
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() {
    setState(() => _todos = widget.storage.getTodayTodos());
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  String _todayStr() {
    final now = DateTime.now();
    return '${now.year}年${now.month}月${now.day}日';
  }

  @override
  Widget build(BuildContext context) {
    final completed = _todos.where((t) => t.isCompleted).length;
    final total = _todos.length;
    final progress = total == 0 ? 0.0 : completed / total;

    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '📅  $_todayStr()',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 4),
              Text('今日待办', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 10)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('完成进度', style: TextStyle(fontSize: 16)),
                        Text(
                          '$completed / $total',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.orange[100],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        hintText: '添加一个新任务...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      onSubmitted: (_) => _addTodo(),
                    ),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _addTodo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 28),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: _todos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_rounded, size: 80, color: Colors.orange[200]),
                            SizedBox(height: 12),
                            Text('还没有任务，添加一个开始吧！', style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _todos.length,
                        separatorBuilder: (_, __) => SizedBox(height: 8),
                        itemBuilder: (_, i) {
                          final todo = _todos[i];
                          return Dismissible(
                            key: Key(todo.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red[400],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) async {
                              await widget.storage.deleteTodo(todo);
                              _loadTodos();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: todo.isCompleted,
                                    activeColor: Colors.green,
                                    onChanged: (_) async {
                                      await widget.storage.toggleTodo(todo);
                                      _loadTodos();
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      todo.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                                        color: todo.isCompleted ? Colors.grey : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addTodo() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    await widget.storage.addTodo(text);
    _inputController.clear();
    _loadTodos();
  }
}
