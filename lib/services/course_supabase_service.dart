// lib/services/course_supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course.dart';
import 'course_data_source.dart';

// Identitas Wajib
const String studentName = 'Amelia Elsa Syah Fitri Situmorang';
const String studentId = '2415051042';

class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    // Mengambil data dari tabel courses di Supabase dan mengurutkannya berdasarkan ID
    final data = await supabase
        .from('courses')
        .select()
        .order('id', ascending: true);

    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Sementara untuk method lain diberi UnimplementedError agar memenuhi kontrak CourseDataSource
  @override
  Future<Course> createCourse(Course course) => throw UnimplementedError();

  @override
  Future<void> updateCourse(int id, Course course) => throw UnimplementedError();

  @override
  Future<void> deleteCourse(int id) => throw UnimplementedError();
}