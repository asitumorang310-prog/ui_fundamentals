import '../models/course.dart';
import '../services/course_api_service.dart'; 

// Identitas Wajib
const String studentName = 'Amelia Elsa Syah Fitri Situmorang';
const String studentId = '2415051042';

class CourseRepository {
  final CourseApiService apiService; 

  CourseRepository(this.apiService);

  Future<List<Course>> getCourses() {
    return apiService.getCourses(); 
  }
}