import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/course_provider.dart';
import 'models/course.dart'; 

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
      title: 'Course Explorer - Tahap 8',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const ModelExplorerScreen(),
    );
  }
}

class ModelExplorerScreen extends StatelessWidget {
  const ModelExplorerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca state reaktif dengan watch()
    final courseState = context.watch<CourseState>();

    // Simulasi data mentah JSON (Map<String, dynamic>) yang diubah menjadi Object Model Course
    final List<Map<String, dynamic>> rawJsonData = [
      {'code': 'IF101', 'title': 'Git & GitHub', 'credits': 3, 'status': 'done'},
      {'code': 'IF102', 'title': 'Dart Fundamentals', 'credits': 4, 'status': 'done'},
      {'code': 'IF103', 'title': 'State Management', 'credits': 3, 'status': 'active'},
      {'code': 'IF104', 'title': 'Mobile Architecture', 'credits': 4, 'status': 'upcoming'},
    ];

    // Konversi Map ke Object Model menggunakan Course.fromJson
    final List<Course> courses = rawJsonData.map((json) => Course.fromJson(json)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer v2 (Model JSON)'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Identitas Modern
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade800, Colors.teal.shade500],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tahap 8: Object Model & JSON Parsing',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$studentId • $studentName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Statistik Ringkasan
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.teal.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Model Course', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 6),
                          Text('${courses.length}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    color: Colors.pink.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Favorit Terpilih', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 6),
                          Text('${courseState.favorites.length}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Daftar Mata Kuliah Berbasis Model:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),

            // ListView menampilkan data dari Object Model Course
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final Course course = courses[index]; // Menggunakan tipe data object Course

                // Menentukan warna badge status
                Color statusColor = Colors.orange;
                if (course.status == 'done') statusColor = Colors.green;
                if (course.status == 'active') statusColor = Colors.blue;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      course.title, // Mengakses properti model secara langsung
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Kode: ${course.code} • SKS: ${course.credits}', style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: statusColor.withOpacity(0.5)),
                          ),
                          child: Text(
                            course.status.toUpperCase(),
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                          ),
                        ),
                      ],
                    ),
                    // Menggunakan Consumer untuk efisiensi rebuild tombol favorit
                    trailing: Consumer<CourseState>(
                      builder: (context, state, child) {
                        final isFav = state.isFavorite(course.code);
                        return IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: Colors.pink,
                          ),
                          onPressed: () {
                            context.read<CourseState>().toggleFavorite(course.code);
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