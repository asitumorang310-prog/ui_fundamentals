import 'package:flutter/material.dart';

const String studentId = '2415051042';
const String studentName = 'Amelia Elsa Syah Fitri Situmorang';

void main() {
  runApp(const MyApp());
}

// Collection Dart
final List<Map<String, dynamic>> topics = [
  {
    'title': 'Git & GitHub',
    'subtitle': 'Version control',
    'done': true,
    'icon': Icons.account_tree,
  },
  {
    'title': 'Dart Fundamentals',
    'subtitle': 'Language basics',
    'done': true,
    'icon': Icons.code,
  },
  {
    'title': 'Flutter UI Fundamentals',
    'subtitle': 'Widgets & layout',
    'done': false,
    'icon': Icons.widgets,
  },
  {
    'title': '$studentId - $studentName',
    'subtitle': 'Pemilik aplikasi',
    'done': false,
    'icon': Icons.person,
  },
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final int completed =
        topics.where((item) => item['done'] == true).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Identitas mahasiswa
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      studentName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(studentId),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Tahap 11: Ringkasan
            Row(
              children: [
                const Icon(Icons.menu_book),
                const SizedBox(width: 8),
                Text(
                  '$completed dari ${topics.length} topik selesai',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // List Tahap 11
            Expanded(
              child: ListView.builder(
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  final item = topics[index];
                  final bool isDone = item['done'] == true;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: Icon(
                        isDone
                            ? Icons.check_circle
                            : Icons.schedule,
                        color: isDone
                            ? Colors.green
                            : Colors.orange,
                      ),
                      title: Text(
                        item['title'] as String,
                      ),
                      subtitle: Text(
                        item['subtitle'] as String,
                      ),
                      trailing: Text(
                        isDone ? 'Selesai' : 'Belum',
                        style: TextStyle(
                          color: isDone
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}