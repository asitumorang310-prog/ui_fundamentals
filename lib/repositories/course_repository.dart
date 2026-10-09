import '../models/course.dart';
import '../services/course_service.dart';

// Identitas Wajib
const String studentName = 'Amelia Elsa Syah Fitri Situmorang';
const String studentId = '2415051042';

class CourseRepository {
  final CourseService service;

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }
}