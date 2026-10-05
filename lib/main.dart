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
      home: const ResponsiveTestPage(),
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

// ============================================================
// TAHAP 3: LayoutCheerful & Breakpoint (Compact, Medium, Expanded)
// ============================================================

class CompactLayout extends StatelessWidget {
  final Map<String, dynamic> student;
  const CompactLayout({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.phone_android, size: 50, color: Colors.blue),
          const SizedBox(height: 12),
          const Text('Kategori Layout: COMPACT (< 600 px)',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 8),
          Text('${student['nim']} - ${student['name']}',
              style: const TextStyle(fontSize: 16)),
          const Text('(Visual: Tampilan vertikal satu kolom untuk Smartphone)'),
        ],
      ),
    );
  }
}

class MediumLayout extends StatelessWidget {
  final Map<String, dynamic> student;
  const MediumLayout({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.orange.shade50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.tablet_mac, size: 50, color: Colors.orange),
          const SizedBox(height: 12),
          const Text('Kategori Layout: MEDIUM (600 - 839 px)',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
          const SizedBox(height: 8),
          Text('${student['nim']} - ${student['name']}',
              style: const TextStyle(fontSize: 16)),
          const Text('(Visual: Tampilan semi-lebar untuk Tablet Portrait)'),
        ],
      ),
    );
  }
}

class ExpandedLayout extends StatelessWidget {
  final Map<String, dynamic> student;
  const ExpandedLayout({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green.shade50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.desktop_windows, size: 50, color: Colors.green),
          const SizedBox(height: 12),
          const Text('Kategori Layout: EXPANDED (>= 840 px)',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 8),
          Text('${student['nim']} - ${student['name']}',
              style: const TextStyle(fontSize: 16)),
          const Text('(Visual: Tampilan penuh / multi-kolom untuk Tablet Landscape atau Desktop)'),
        ],
      ),
    );
  }
}

class ResponsiveTestPage extends StatelessWidget {
  const ResponsiveTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 3 - LayoutBuilder & Breakpoint'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: loadStudentData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;

          // Menggunakan LayoutBuilder untuk membaca constraints parent
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return CompactLayout(student: student);
              } else if (constraints.maxWidth < 840) {
                return MediumLayout(student: student);
              } else {
                return ExpandedLayout(student: student);
              }
            },
          );
        },
      ),
    );
  }
}