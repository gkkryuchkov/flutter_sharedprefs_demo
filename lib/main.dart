import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final String title = 'SharedPreferences Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  String _savedName = '';

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  // Загрузка сохранённого имени
  void _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('name') ?? '';
    });
  }

  // Сохранение введённого имени
  void _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    _loadName();
    _nameController.clear();
  }

  // Удаление сохранённого имени
  void _deleteName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    _loadName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                _savedName.isEmpty
                    ? 'Имя не сохранено'
                    : 'Сохранённое имя: $_savedName',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Введите имя'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saveName,
                child: const Text('Сохранить имя'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _deleteName,
                child: const Text('Удалить имя'),
              ),
            ],
          ),
        ));
  }
}
