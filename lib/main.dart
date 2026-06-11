import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'services/reminder_manager.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = StorageService();
  await storage.init();
  runApp(TodoDailyApp(storage: storage));
}

class TodoDailyApp extends StatefulWidget {
  final StorageService storage;
  TodoDailyApp({required this.storage});

  @override
  _TodoDailyAppState createState() => _TodoDailyAppState();
}

class _TodoDailyAppState extends State<TodoDailyApp> with WidgetsBindingObserver {
  late final ReminderManager _reminder;
  late BuildContext _currentContext;
  final _homeKey = GlobalKey<_HomePageRefreshState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _reminder = ReminderManager(
      storage: widget.storage,
      getContext: () => _currentContext,
      onDataChanged: () => _homeKey.currentState?.refresh(),
    );
    _reminder.start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _reminder.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _reminder.onAppResumed();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '每日待办',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: Builder(
        builder: (ctx) {
          _currentContext = ctx;
          return _HomePageRefresh(key: _homeKey, storage: widget.storage);
        },
      ),
    );
  }
}

class _HomePageRefresh extends StatefulWidget {
  final StorageService storage;
  _HomePageRefresh({Key? key, required this.storage}) : super(key: key);

  @override
  _HomePageRefreshState createState() => _HomePageRefreshState();
}

class _HomePageRefreshState extends State<_HomePageRefresh> {
  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) => HomePage(storage: widget.storage);
}
