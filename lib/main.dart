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
          // Loading
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat data: ${snapshot.error}',
              ),
            );
          }

          final data = snapshot.data!;

          final student =
              data['student'] as Map<String, dynamic>;

          final courses =
              data['courses'] as List<dynamic>;

          final totalCredits = courses.fold<int>(
            0,
            (sum, course) =>
                sum + (course['credits'] as int),
          );

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile / Identity
                buildProfileCard(student),

                const SizedBox(height: 8),

                // Summary Row
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

                // List Courses
                Expanded(
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course =
                          courses[index]
                              as Map<String, dynamic>;

                      final status =
                          course['status'] as String;

                      final bool isDone =
                          status == 'done';

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                        ),
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
                          title: Text(
                            course['title'] as String,
                          ),
                          subtitle: Text(
                            '${course['code']} • '
                            '${course['credits']} SKS',
                          ),
                          trailing: Text(
                            isDone
                                ? 'Selesaii'
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
// TAHAP 1: Mengamati Masalah Layout yang Tidak Responsif
// ============================================================

class ResponsiveTestPage extends StatelessWidget {
  const ResponsiveTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 1 - Responsive Layout'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: loadStudentData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
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
          final student =
              data['student'] as Map<String, dynamic>;

          // Mengganti Center dengan Padding agar posisi container berada di atas rata kiri
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                border: Border.all(color: Colors.deepPurple, width: 2),
              ),
              child: Text(
                '${student['nim']} - ${student['name']}',
                textAlign: TextAlign.left,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}