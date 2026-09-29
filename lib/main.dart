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

// Function untuk membuat kartu statistik
Widget buildStatCard(
  String value,
  String label,
  IconData icon,
) {
  return Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(label),
          ],
        ),
      ),
    ),
  );
}

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Dashboard'),
      ),
      body: Column(
        children: [
          // Bagian atas
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Card informasi mahasiswa
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Foto
                          const CircleAvatar(
                            radius: 46,
                            backgroundImage: AssetImage(
                              'assets/images/amel.jpeg',
                            ),
                          ),

                          const SizedBox(height: 12),

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

                          const SizedBox(height: 8),

                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.widgets),
                              SizedBox(width: 8),
                              Text('Belajar Widget Flutter'),
                            ],
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Saya tertarik mempelajari pengembangan aplikasi mobile menggunakan Flutter.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Statistik reusable
                  Row(
                    children: [
                      buildStatCard(
                        '8',
                        'Widget',
                        Icons.widgets,
                      ),
                      buildStatCard(
                        '4',
                        'Layout',
                        Icons.view_quilt,
                      ),
                      buildStatCard(
                        '1',
                        'State',
                        Icons.sync,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Tahap 10: Collection + ListView.builder
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Judul daftar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.menu_book),
                      const SizedBox(width: 8),
                      Text(
                        'Daftar Topik Pembelajaran',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),

                // ListView.builder
                Expanded(
                  child: ListView.builder(
                    itemCount: topics.length,
                    itemBuilder: (context, index) {
                      final item = topics[index];

                      final IconData icon =
                          item['icon'] ?? Icons.school;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(icon),
                          ),
                          title: Text(
                            item['title'] as String,
                          ),
                          subtitle: Text(
                            item['subtitle'] as String,
                          ),
                          trailing: Icon(
                            item['done'] == true
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}