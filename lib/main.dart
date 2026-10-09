import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/course_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'models/course.dart';

const String studentName = 'Amelia Elsa Syah Fitri Situmorang';
const String studentId = '2415051042';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<CourseService>(create: (_) => CourseService()),
        ProxyProvider<CourseService, CourseRepository>(
          update: (_, service, __) => CourseRepository(service),
        ),
        ChangeNotifierProxyProvider<CourseRepository, CourseState>(
          create: (context) => CourseState(context.read<CourseRepository>()),
          update: (_, repository, previousState) =>
              previousState ?? CourseState(repository),
        ),
      ],
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
      title: 'Course Explorer - Tahap 11',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepOrange,
      ),
      home: const AsyncStateScreen(),
    );
  }
}

class AsyncStateScreen extends StatefulWidget {
  const AsyncStateScreen({super.key});

  @override
  State<AsyncStateScreen> createState() => _AsyncStateScreenState();
}

class _AsyncStateScreenState extends State<AsyncStateScreen> {
  @override
  void initState() {
    super.initState();
    // Memuat data course otomatis ketika screen pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseState>().loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Membaca state reaktif dari CourseState
    final courseState = context.watch<CourseState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer v2 (Async State)'),
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
                  colors: [Colors.deepOrange.shade800, Colors.deepOrange.shade500],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tahap 11: Async State (Loading, Success, Error)',
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
              'Daftar Kursus (Managed by Provider):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),

            // Mengelola Tampilan UI Berdasarkan Status Async (Loading, Error, atau Success)
            Expanded(
              child: Builder(
                builder: (context) {
                  // 1. Kondisi Loading
                  if (courseState.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // 2. Kondisi Error
                  if (courseState.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 8),
                          Text('Terjadi Kesalahan: ${courseState.error}'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => courseState.loadCourses(),
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  // 3. Kondisi Kosong
                  if (courseState.courses.isEmpty) {
                    return const Center(child: Text('Tidak ada kursus tersedia.'));
                  }

                  // 4. Kondisi Success (Data Berhasil Dimuat)
                  final courses = courseState.courses;
                  return ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final Course course = courses[index];
                      
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