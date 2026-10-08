import 'package:flutter/material.dart';

// Identitas Wajib
const String studentName = 'Amelia Elsa Syah Fitri Situmorang';
const String studentId = '2415051042';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer v2',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Course Explorer - Tahap 1'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const [
            Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: Text(
                '$studentId - $studentName',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            CourseCardLocalExample(courseTitle: 'Git & GitHub'),
            CourseCardLocalExample(courseTitle: 'Dart Fundamentals'),
            CourseCardLocalExample(courseTitle: 'State Management'),
          ],
        ),
      ),
    );
  }
}

class CourseCardLocalExample extends StatefulWidget {
  final String courseTitle;
  const CourseCardLocalExample({super.key, required this.courseTitle});

  @override
  State<CourseCardLocalExample> createState() => _CourseCardLocalExampleState();
}

class _CourseCardLocalExampleState extends State<CourseCardLocalExample> {
  bool isExpanded = false;
  bool isLocalFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.courseTitle),
            subtitle: Text('ID: $studentId'),
            trailing: IconButton(
              icon: Icon(
                isLocalFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                // Menggunakan setState untuk mengubah local state
                setState(() {
                  isLocalFavorite = !isLocalFavorite;
                });
              },
            ),
            onTap: () {
              // Local state untuk show/hide detail
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Detail informasi untuk ${widget.courseTitle} (Local State Active).'),
            ),
        ],
      ),
    );
  }
}