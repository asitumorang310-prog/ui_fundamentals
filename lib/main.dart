import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );

  return jsonDecode(jsonString) as Map<String, dynamic>;
}

void main() {
  runApp(const MyApp());
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

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  // Reusable Widget 1: Profile
  Widget buildProfileCard(Map<String, dynamic> student) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(
                'assets/images/amel.jpeg',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    student['nim'] as String,
                  ),
                  Text(
                    'Semester ${student['semester'] ?? 5}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Widget 2: Summary Card
  Widget buildSummaryCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 30),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Dashboard'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat data: ${snapshot.error}',
              ),
            );
          }

          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;

          final totalCredits = courses.fold<int>(
            0,
            (sum, course) => sum + (course['credits'] as int),
          );

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildProfileCard(student),
                const SizedBox(height: 8),
                Row(
                  children: [
                    buildSummaryCard(
                      Icons.menu_book,
                      'Jumlah Mata Kuliah',
                      '${courses.length}',
                    ),
                    const SizedBox(width: 8),
                    buildSummaryCard(
                      Icons.school,
                      'Total SKS',
                      '$totalCredits',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index] as Map<String, dynamic>;
                      final status = course['status'] as String;
                      final bool isDone = status == 'done';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Icon(
                            isDone
                                ? Icons.check_circle
                                : status == 'active'
                                    ? Icons.play_circle
                                    : Icons.schedule,
                            color: isDone
                                ? Colors.green
                                : status == 'active'
                                    ? Colors.blue
                                    : Colors.orange,
                          ),
                          title: Text(course['title'] as String),
                          subtitle: Text(
                            '${course['code']} • ${course['credits']} SKS',
                          ),
                          trailing: Text(
                            isDone
                                ? 'Selesai'
                                : status == 'active'
                                    ? 'Aktif'
                                    : 'Belum',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDone
                                  ? Colors.green
                                  : status == 'active'
                                      ? Colors.blue
                                      : Colors.orange,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
// TAHAP 9: Returning Data & Update State Favorite
// ============================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> studentFuture;
  
  // Set untuk menyimpan judul course yang difavoritkan
  final Set<String> favoriteCourses = {};

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer - Home'),
        elevation: 2,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Identitas Mahasiswa
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.deepPurple,
                          child: Icon(Icons.person, color: Colors.white, size: 30),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student['name'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('NIM: ${student['nim']}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Daftar Mata Kuliah:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // ListView Course
                Expanded(
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index] as Map<String, dynamic>;
                      final courseTitle = course['title'] as String;
                      final status = course['status'] as String;
                      final bool isDone = status == 'done';
                      
                      // Cek apakah course ini sudah ada di daftar favorite
                      final bool isFavorite = favoriteCourses.contains(courseTitle);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Icon(
                            isDone
                                ? Icons.check_circle
                                : status == 'active'
                                    ? Icons.play_circle
                                    : Icons.schedule,
                            color: isDone
                                ? Colors.green
                                : status == 'active'
                                    ? Colors.blue
                                    : Colors.orange,
                          ),
                          title: Text(courseTitle),
                          subtitle: Text('${course['code']} • ${course['credits']} SKS'),
                          // Trailing berubah menjadi ikon love merah jika sudah difavoritkan
                          trailing: Icon(
                            isFavorite ? Icons.favorite : Icons.arrow_forward_ios,
                            color: isFavorite ? Colors.red : Colors.grey,
                            size: isFavorite ? 24 : 16,
                          ),
                          onTap: () async {
                            final result = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailPage(
                                  course: course,
                                  student: student,
                                ),
                              ),
                            );

                            // Jika mendapat nilai true dari pop, ubah state lokal agar UI memperbarui ikon
                            if (result == true && context.mounted) {
                              setState(() {
                                favoriteCourses.add(courseTitle);
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Mata kuliah "$courseTitle" ditandai sebagai Favorit!'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;
  final Map<String, dynamic> student;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String;
    final bool isDone = status == 'done';

    return Scaffold(
      appBar: AppBar(
        title: Text(course['title'] as String),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detail Mata Kuliah',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const Divider(height: 24),
                Text(
                  'Judul: ${course['title']}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Kode Mata Kuliah: ${course['code']}'),
                const SizedBox(height: 8),
                Text('Jumlah SKS: ${course['credits']} SKS'),
                const SizedBox(height: 8),
                Text('Status: ${isDone ? "Selesai" : status == "active" ? "Aktif" : "Belum"}'),
                const Divider(height: 32),
                const Text(
                  'Informasi Mahasiswa:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('Nama: ${student['name']}'),
                Text('NIM: ${student['nim']}'),
                const SizedBox(height: 24),

                // Tombol Pilih / Favorite untuk mengirim data kembali ke screen sebelumnya
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(Icons.favorite, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    label: const Text('Pilih / Jadikan Favorit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}