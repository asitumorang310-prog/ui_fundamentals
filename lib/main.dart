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
      title: 'Course Explorer - Tahap 2',
      home: ParentScreen(),
    );
  }
}

// Parent Widget yang memiliki state utama (State Ownership)
class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  // Shared state sederhana di Parent
  final Set<String> _favorites = {};

  void _toggleFavorite(String courseCode) {
    setState(() {
      if (_favorites.contains(courseCode)) {
        _favorites.remove(courseCode);
      } else {
        _favorites.add(courseCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 2: Masalah setState & Prop Drilling'),
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
            // Child 1: Menampilkan ringkasan jumlah favorit (harus dilempar lewat constructor)
            CourseSummary(favoriteCount: _favorites.length),
            const SizedBox(height: 16),
            const Text(
              'Daftar Mata Kuliah:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            // Child 2: List course yang menerima data dan callback
            Expanded(
              child: CourseList(
                favorites: _favorites,
                onToggleFavorite: _toggleFavorite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Child 1: CourseSummary
class CourseSummary extends StatelessWidget {
  final int favoriteCount;
  const CourseSummary({super.key, required this.favoriteCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Kursus Favorit:'),
            Text(
              '$favoriteCount',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// Child 2: CourseList
class CourseList extends StatelessWidget {
  final Set<String> favorites;
  final Function(String) onToggleFavorite;

  const CourseList({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> courses = [
      {'code': 'IF101', 'title': 'Git & GitHub'},
      {'code': 'IF102', 'title': 'Dart Fundamentals'},
      {'code': 'IF103', 'title': 'State Management'},
    ];

    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        final code = course['code']!;
        final title = course['title']!;
        final isFav = favorites.contains(code);

        return Card(
          child: ListTile(
            title: Text(title),
            subtitle: Text('Kode: $code'),
            trailing: IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () => onToggleFavorite(code), // Prop drilling callback naik ke parent
            ),
          ),
        );
      },
    );
  }
}