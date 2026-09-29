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
      home: const DashboardPage(),
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
          if (snapshot.connectionState == ConnectionState.waiting) {
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

          // Data
          final data = snapshot.data!;

          final student =
              data['student'] as Map<String, dynamic>;

          final courses =
              data['courses'] as List<dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Identitas mahasiswa dari JSON
                Card(
                  child: ListTile(
                    title: Text(
                      student['name'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      student['nim'] as String,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Daftar courses dari JSON
                Expanded(
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course =
                          courses[index] as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              course['code']
                                  .toString()
                                  .substring(3),
                            ),
                          ),
                          title: Text(
                            course['title'] as String,
                          ),
                          subtitle: Text(
                            course['code'] as String,
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