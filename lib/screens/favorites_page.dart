import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courseState = context.watch<CourseState>();
    
    // Menyaring course yang ID-nya ada di dalam Set favorites
    final favoriteCourses = courseState.courses
        .where((course) => courseState.isFavorite(course.code))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kursus Favorit'),
      ),
      // PERBAIKAN DI SINI: Tambahkan tanda tanya (?) sebelum Center
      body: favoriteCourses.isEmpty
          ? const Center(
              child: Text(
                'Belum ada kursus favorit.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteCourses.length,
              itemBuilder: (context, index) {
                return CourseCard(course: favoriteCourses[index]);
              },
            ),
    );
  }
}