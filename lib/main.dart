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
      home: const ResponsiveShell(),
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


class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int currentIndex = 0;
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: studentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Gagal memuat data: ${snapshot.error}')),
          );
        }

        final data = snapshot.data!;
        final student = data['student'] as Map<String, dynamic>;
        final courses = data['courses'] as List<dynamic>;

        final List<Widget> pages = [
          HomePage(student: student, courses: courses),
          CoursesPage(courses: courses, student: student),
          DebuggingErrorPage(student: student),
          ProfilePage(student: student),
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 840) {
              return Scaffold(
                body: pages[currentIndex],
                bottomNavigationBar: NavigationBar(
                  selectedIndex: currentIndex,
                  onDestinationSelected: (index) {
                    setState(() => currentIndex = index);
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.school_outlined),
                      selectedIcon: Icon(Icons.school),
                      label: 'Courses',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.bug_report_outlined),
                      selectedIcon: Icon(Icons.bug_report),
                      label: 'Debug',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                ),
              );
            }

            return Scaffold(
              body: Row(
                children: [
                  NavigationRail(
                    selectedIndex: currentIndex,
                    onDestinationSelected: (index) {
                      setState(() => currentIndex = index);
                    },
                    labelType: NavigationRailLabelType.all,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.school_outlined),
                        selectedIcon: Icon(Icons.school),
                        label: Text('Courses'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.bug_report_outlined),
                        selectedIcon: Icon(Icons.bug_report),
                        label: Text('Debug'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_outline),
                        selectedIcon: Icon(Icons.person),
                        label: Text('Profile'),
                      ),
                    ],
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: pages[currentIndex]),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ============================================================
// TAHAP 16: DEBUGGING & ERROR HANDLING PAGE
// ============================================================
class DebuggingErrorPage extends StatefulWidget {
  final Map<String, dynamic> student;

  const DebuggingErrorPage({super.key, required this.student});

  @override
  State<DebuggingErrorPage> createState() => _DebuggingErrorPageState();
}

class _DebuggingErrorPageState extends State<DebuggingErrorPage> {
  final TextEditingController _inputController = TextEditingController();
  String _statusMessage = 'Masukkan teks atau data, lalu uji coba penanganan error.';
  bool _isError = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _testProcess() {
    setState(() {
      try {
        final text = _inputController.text.trim();
        if (text.isEmpty) {
          throw Exception('Input kosong! Data gagal diproses.');
        }
        if (text.toLowerCase() == 'error') {
          throw Exception('Simulasi Server Error: Gagal terhubung ke database.');
        }

        _isError = false;
        _statusMessage = 'Sukses! Data "$text" berhasil diproses dengan aman.';
      } catch (e) {
        _isError = true;
        _statusMessage = e.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.student['name'] ?? '';
    final nim = widget.student['nim'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 16: Debugging & Error Handling', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$nim - $name',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              'Simulasi Penanganan Kesalahan (Error Handling & Input):',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                labelText: 'Ketik sesuatu (ketik "error" atau kosongkan untuk tes exception)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  if (_isError)
                    const Icon(Icons.error_outline, color: Colors.red, size: 40)
                  else
                    const Icon(Icons.check_circle_outline, color: Colors.green, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    _statusMessage,
                    style: TextStyle(
                      color: _isError ? Colors.red.shade700 : Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Uji Proses & Tangkap Error (Try-Catch)'),
                onPressed: _testProcess,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 1. HOME PAGE
// ============================================================
class HomePage extends StatelessWidget {
  final Map<String, dynamic> student;
  final List<dynamic> courses;

  const HomePage({super.key, required this.student, required this.courses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Mahasiswa: ${student['name']} (${student['nim']})'),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index] as Map<String, dynamic>;
                  return Card(
                    child: ListTile(
                      title: Text(course['title']),
                      subtitle: Text(course['code']),
                    ),
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

// ============================================================
// 2. COURSES PAGE
// ============================================================
class CoursesPage extends StatelessWidget {
  final List<dynamic> courses;
  final Map<String, dynamic> student;

  const CoursesPage({super.key, required this.courses, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Mata Kuliah', style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) => ListTile(title: Text(courses[index]['title'])),
      ),
    );
  }
}

// ============================================================
// 3. PROFILE PAGE
// ============================================================
class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> student;

  const ProfilePage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa', style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue),
      body: Center(
        child: Text('${student['name']} - ${student['nim']}'),
      ),
    );
  }
}