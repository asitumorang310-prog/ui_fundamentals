import 'package:flutter/material.dart';
import 'providers/course_provider.dart'; 

const String studentName = 'Amelia Elsa Syah Fitri Situmorang';
const String studentId = '2415051042';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Uji Tahap 5',
      home: TestChangeNotifierScreen(),
    );
  }
}

class TestChangeNotifierScreen extends StatefulWidget {
  const TestChangeNotifierScreen({super.key});

  @override
  State<TestChangeNotifierScreen> createState() => _TestChangeNotifierScreenState();
}

class _TestChangeNotifierScreenState extends State<TestChangeNotifierScreen> {
  final CourseState _courseState = CourseState();

  @override
  void dispose() {
    _courseState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 5: ChangeNotifier & notifyListeners'),
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
            AnimatedBuilder(
              animation: _courseState,
              builder: (context, child) {
                return Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Favorit: ${_courseState.favorites.length}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text('Daftar ID Favorit: ${_courseState.favorites.toList()}'),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text('Uji Tombol Toggle Favorite:'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _courseState.toggleFavorite('IF101');
              },
              child: const Text('Toggle Course: IF101 (Git & GitHub)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _courseState.toggleFavorite('IF102');
              },
              child: const Text('Toggle Course: IF102 (Dart Fundamentals)'),
            ),
          ],
        ),
      ),
    );
  }
}