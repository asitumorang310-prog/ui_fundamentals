import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/course_provider.dart';
import 'models/course.dart';
import 'services/course_service.dart';
import 'repositories/course_repository.dart';
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
      title: 'Course Explorer - Tahap 10',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const RepositoryTestScreen(),
    );
  }
}

class RepositoryTestScreen extends StatefulWidget {
  const RepositoryTestScreen({super.key});

  @override
  State<RepositoryTestScreen> createState() => _RepositoryTestScreenState();
}

class _RepositoryTestScreenState extends State<RepositoryTestScreen> {
  // Inisialisasi Service dan Repository
  late final CourseRepository _courseRepository;
  late Future<List<Course>> _futureCourses;

  @override
  void initState() {
    super.initState();
    final courseService = CourseService();
    _courseRepository = CourseRepository(courseService);
    
    // Mengambil data melalui Repository Pattern
    _futureCourses = _courseRepository.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    final courseState = context.watch<CourseState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer v2 (Repository Pattern)'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Identitas
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
                    'Tahap 10: Repository Pattern & Abstraksi Data',
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
            
            Text(
              'Total Favorit Dipilih: ${courseState.favorites.length}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            const Text(
              'Daftar Kursus Dimuat Melalui CourseRepository:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: FutureBuilder<List<Course>>(
                future: _futureCourses,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Gagal memuat data: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada data course.'));
                  }

                  final courses = snapshot.data!;

                  return ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      
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
                            course.title,
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