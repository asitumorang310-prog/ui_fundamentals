import 'package:flutter/material.dart';

const String studentId = '2415051042';
const String studentName = 'Amelia Elsa Syah Fitri Situmorang';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 46,
              backgroundImage: AssetImage(
                'assets/images/amel.jpeg',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              studentName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(studentId),
            const SizedBox(height: 8),
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.widgets),
                SizedBox(width: 8),
                Text('Belajar Widget Flutter'),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Saya tertarik mempelajari pengembangan aplikasi mobile menggunakan Flutter.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}