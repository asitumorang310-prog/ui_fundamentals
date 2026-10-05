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
      home: const MainNavigationPage(),
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

// TAHAP 13: Form Input dan Validasi
// ============================================================

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
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

        // Kita tambah halaman Feedback Form sebagai tab ke-3 atau ke-4
        final List<Widget> pages = [
          HomeTab(student: student, courses: courses),
          CoursesTab(courses: courses, student: student),
          FeedbackFormTab(student: student),
          ProfileTab(student: student),
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
                      icon: Icon(Icons.feedback_outlined),
                      selectedIcon: Icon(Icons.feedback),
                      label: 'Feedback',
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
                        icon: Icon(Icons.feedback_outlined),
                        selectedIcon: Icon(Icons.feedback),
                        label: Text('Feedback'),
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

// 1. Home Tab
class HomeTab extends StatelessWidget {
  final Map<String, dynamic> student;
  final List<dynamic> courses;

  const HomeTab({super.key, required this.student, required this.courses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer - Home'),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 24),
            const Text(
              'Selamat Datang di Learning Dashboard!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Total mata kuliah yang tersedia saat ini adalah ${courses.length} mata kuliah.',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. Courses Tab
class CoursesTab extends StatefulWidget {
  final List<dynamic> courses;
  final Map<String, dynamic> student;

  const CoursesTab({super.key, required this.courses, required this.student});

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  final Set<String> favoriteCourses = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Mata Kuliah'),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: widget.courses.length,
          itemBuilder: (context, index) {
            final course = widget.courses[index] as Map<String, dynamic>;
            final courseTitle = course['title'] as String;
            final status = course['status'] as String;
            final bool isDone = status == 'done';
            final bool isFavorite = favoriteCourses.contains(courseTitle);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
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
                trailing: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isFavorite) {
                        favoriteCourses.remove(courseTitle);
                      } else {
                        favoriteCourses.add(courseTitle);
                      }
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// TAHAP 13 TAB: Feedback Form dengan GlobalKey & Validator

class FeedbackFormTab extends StatefulWidget {
  final Map<String, dynamic> student;

  const FeedbackFormTab({super.key, required this.student});

  @override
  State<FeedbackFormTab> createState() => _FeedbackFormTabState();
}

class _FeedbackFormTabState extends State<FeedbackFormTab> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late final TextEditingController _nimController;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Mengisi nilai default dari data student
    _nameController = TextEditingController(text: widget.student['name'] ?? '');
    _nimController = TextEditingController(text: widget.student['nim'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Feedback & Umpan Balik'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kirim Umpan Balik Aplikasi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 16),
                  
                  // Field Nama (Default terisi)
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Field NIM (Default terisi)
                  TextFormField(
                    controller: _nimController,
                    decoration: const InputDecoration(
                      labelText: 'NIM',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'NIM wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Field Komentar (Validasi minimal 5 karakter)
                  TextFormField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Komentar / Saran',
                      hintText: 'Tuliskan komentar minimal 5 karakter...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.comment),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 5) {
                        return 'Komentar wajib diisi minimal 5 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Tombol Submit
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.send),
                      label: const Text('Kirim Feedback', style: TextStyle(fontSize: 16)),
                      onPressed: () {
                        // Validasi form sebelum memproses data
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Feedback berhasil dikirim. Terima kasih!'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          _commentController.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 4. Profile Tab
class ProfileTab extends StatelessWidget {
  final Map<String, dynamic> student;

  const ProfileTab({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        elevation: 2,
      ),
      body: Center(
        child: Padding(
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
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    student['name'] as String,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'NIM: ${student['nim']}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Semester: ${student['semester'] ?? 5}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}