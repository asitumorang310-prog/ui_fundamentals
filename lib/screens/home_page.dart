import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'favorites_page.dart';

const String studentName = 'Amelia Elsa Syah Fitri Situmorang';
const String studentId = '2415051042';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseState>().loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseState = context.watch<CourseState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer v2 (Shared State)'),
        elevation: 0,
        actions: [
          // Tombol navigasi menuju halaman Favorites
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.pink),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    'Tahap 13: Shared Favorites antar Screen',
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Favorit: ${courseState.favorites.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoritesPage()),
                    );
                  },
                  icon: const Icon(Icons.list_alt, size: 16),
                  label: const Text('Lihat Favorit'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Daftar Seluruh Mata Kuliah:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (courseState.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (courseState.error != null) {
                    return Center(child: Text('Error: ${courseState.error}'));
                  }
                  if (courseState.courses.isEmpty) {
                    return const Center(child: Text('Tidak ada kursus.'));
                  }

                  final courses = courseState.courses;
                  return ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      return CourseCard(course: courses[index]);
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