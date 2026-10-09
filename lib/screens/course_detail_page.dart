import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final courseState = context.watch<CourseState>();
    final isFav = courseState.isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Kode Kursus: ${course.code}', style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            Text('Jumlah SKS: ${course.credits}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Status: ${course.status.toUpperCase()}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFav ? Colors.pink.shade50 : Colors.indigo.shade50,
                  foregroundColor: isFav ? Colors.pink : Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  // Menggunakan read untuk mengubah state tanpa listen di dalam aksi
                  context.read<CourseState>().toggleFavorite(course.code);
                },
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                label: Text(isFav ? 'Hapus dari Favorit' : 'Tambah ke Favorit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}