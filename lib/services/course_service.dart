import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/course.dart';

const String studentName = 'Amelia Elsa Syah Fitri Situmorang';
const String studentId = '2415051042';

class CourseService {
  // Method untuk memuat data course dari file JSON asset
  Future<List<Course>> loadCourses() async {
    // Membaca file string dari assets
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );
    
    // Mendecode JSON string menjadi Map
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    
    // Mengambil list dari key 'courses' dan memetakannya ke objek Course.fromJson
    final list = data['courses'] as List<dynamic>;
    return list
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}