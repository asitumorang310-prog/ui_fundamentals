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

  Future<Course> createCourse(Course course) {
  return apiService.createCourse(course);
  }
  Future<void> updateCourse(int id, Course course) {
  return apiService.updateCourse(id, course);
  }

}