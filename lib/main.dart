import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/course_provider.dart';

// Identitas Wajib
const String studentName = 'Amelia Elsa Syah Fitri Situmorang';
const String studentId = '2415051042';

void main() {
  runApp(
    // Memasang ChangeNotifierProvider di root widget tree
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
      title: 'Course Explorer v2 - Tahap 6',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProviderSetupScreen(),
    );
  }
}

class ProviderSetupScreen extends StatelessWidget {
  const ProviderSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengakses state menggunakan context.watch untuk mendengarkan perubahan
    final courseState = context.watch<CourseState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 6: Provider Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Favorit via Provider: ${courseState.favorites.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text('Daftar ID: ${courseState.favorites.toList()}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Mengakses method tanpa listen (menggunakan read) saat aksi tombol
                context.read<CourseState>().toggleFavorite('IF103');
              },
              child: const Text('Toggle State IF103 via Provider'),
            ),
          ],
        ),
      ),
    );
  }
}