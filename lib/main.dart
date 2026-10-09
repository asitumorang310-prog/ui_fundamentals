import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/course_provider.dart';

const String studentName = 'Amelia Elsa Syah Fitri Situmorang';
const String studentId = '2415051042';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Tahap 7',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const WatchReadConsumerScreen(),
    );
  }
}

class WatchReadConsumerScreen extends StatelessWidget {
  const WatchReadConsumerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Menggunakan context.watch() untuk membaca state secara global di level screen
    final courseState = context.watch<CourseState>();

    final List<Map<String, String>> courses = [
      {'code': 'IF101', 'title': 'Git & GitHub', 'desc': 'Version control and collaboration'},
      {'code': 'IF102', 'title': 'Dart Fundamentals', 'desc': 'Core language features and syntax'},
      {'code': 'IF103', 'title': 'State Management', 'desc': 'Architecture and app scalability'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer v2 (Tahap 7)'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Identitas & Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade800, Colors.indigo.shade500],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard Akademik',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$studentId\n$studentName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Statistik Card menggunakan watch()
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    color: Colors.indigo.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Kursus', style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 8),
                          Text(
                            '${courses.length}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    elevation: 2,
                    color: Colors.pink.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Favorit (watch)', style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 8),
                          Text(
                            '${courseState.favorites.length}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Daftar Mata Kuliah (Consumer & read):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            // List Kursus Interaktif
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                final code = course['code']!;
                final title = course['title']!;
                final desc = course['desc']!;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(desc, style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('Kode: $code', style: const TextStyle(fontSize: 11, color: Colors.indigo)),
                      ],
                    ),
                    // 3. Menggunakan Consumer untuk membatasi area rebuild hanya pada tombol ikon
                    trailing: Consumer<CourseState>(
                      builder: (context, state, child) {
                        final isFav = state.isFavorite(code);
                        return IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: isFav ? Colors.pink.shade50 : Colors.grey.shade100,
                          ),
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: Colors.pink,
                          ),
                          onPressed: () {
                            // 2. Menggunakan context.read() pada tombol aksi tanpa listen
                            context.read<CourseState>().toggleFavorite(code);
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}