import 'package:flutter/material.dart';

enum MorningDialogResult { added, ignored, noTodo }

class MorningDialog extends StatefulWidget {
  final void Function(String title)? onAdd;
  MorningDialog({this.onAdd});

  @override
  _MorningDialogState createState() => _MorningDialogState();
}

class _MorningDialogState extends State<MorningDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.wb_sunny, color: Colors.orange, size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '早安！今日待办',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                '添加今天要完成的事情，晚上 8 点我会来检阅 ✨',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '例如：写文档、运动 30 分钟...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.edit_note),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? '请输入内容' : null,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, MorningDialogResult.noTodo),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('今日无待办'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          widget.onAdd?.call(_controller.text.trim());
                          Navigator.pop(context, MorningDialogResult.added);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('添加', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context, MorningDialogResult.ignored),
                child: Text('稍后提醒', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
