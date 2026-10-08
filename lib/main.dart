import 'package:flutter/material.dart';

const String studentName = 'Amelia Elsa Syah Fitri Situmorang';
const String studentId = '2415051042';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Tahap 3',
      home: CourseExplorerParent(),
    );
  }
}

// Parent Widget sebagai Single Source of Truth
class CourseExplorerParent extends StatefulWidget {
  const CourseExplorerParent({super.key});

  @override
  State<CourseExplorerParent> createState() => _CourseExplorerParentState();
}

class _CourseExplorerParentState extends State<CourseExplorerParent> {
  // Single Source of Truth untuk data mata kuliah dan status favoritnya
  final List<Map<String, dynamic>> _courses = [
    {'code': 'IF101', 'title': 'Git & GitHub', 'isFavorite': false},
    {'code': 'IF102', 'title': 'Dart Fundamentals', 'isFavorite': true},
    {'code': 'IF103', 'title': 'State Management', 'isFavorite': false},
  ];

  // Aksi perubahan state diletakkan di parent
  void _toggleFavorite(int index) {
    setState(() {
      _courses[index]['isFavorite'] = !_courses[index]['isFavorite'];
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalFavorites = _courses.where((c) => c['isFavorite'] == true).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 3: Lifting State Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            // Widget Anak 1: Menampilkan ringkasan yang selalu sinkron dengan parent
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Favorit Aktif:'),
                    Text(
                      '$totalFavorites dari ${_courses.length} Kursus',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Daftar Kursus (Lifting State Up):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            // Widget Anak 2: List course
            Expanded(
              child: ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final course = _courses[index];
                  return CourseCard(
                    title: course['title'],
                    code: course['code'],
                    isFavorite: course['isFavorite'],
                    onFavoriteChanged: () {
                      // Mengirim aksi kembali ke parent melalui callback
                      _toggleFavorite(index);
                    },
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

// Widget Anak (Child) yang bersifat stateless, menerima data & callback
class CourseCard extends StatelessWidget {
  final String title;
  final String code;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  const CourseCard({
    super.key,
    required this.title,
    required this.code,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text('Kode: $code'),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: onFavoriteChanged, // Memanggil callback ke parent
        ),
      ),
    );
  }
}