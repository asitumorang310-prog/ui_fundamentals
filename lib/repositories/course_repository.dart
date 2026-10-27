import '../models/course.dart';
import '../services/course_data_source.dart';

const String studentName = 'Amelia Elsa Syah Fitri Situmorang';
const String studentId = '2415051042';

class CourseRepository {
  CourseRepository(this.dataSource);

  final CourseDataSource dataSource;

  Future<List<Course>> getCourses() => dataSource.getCourses();

  Future<Course> createCourse(Course course) => dataSource.createCourse(course);

  Future<void> updateCourse(int id, Course course) => dataSource.updateCourse(id, course);

  Future<void> deleteCourse(int id) => dataSource.deleteCourse(id);
}