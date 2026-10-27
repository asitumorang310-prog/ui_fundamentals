import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

const String studentName = 'Amelia Elsa Syah Fitri Situmorang';
const String studentId = '2415051042';

class CourseState extends ChangeNotifier {
  final CourseRepository repository;

  CourseState(this.repository);

  // State async variables
  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

Future<bool> addCourse(Course course) async {
  _isSaving = true;
  try {
    await repository.createCourse(course);
    await loadCourses(); // Refresh list setelah berhasil
    _isSaving = false;
    notifyListeners();
    return true;
  } catch (e) {
    _isSaving = false;
    notifyListeners();
    return false;
  }
}
  // Collection untuk favorites lintas screen
  final Set<String> favorites = {};

  // Method untuk memuat courses dengan manajemen async state
  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners(); // Beritahu UI bahwa proses loading dimulai

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString(); // Tangkap pesan error jika gagal
    } finally {
      isLoading = false;
      notifyListeners(); 
    }
  }

  // Method untuk toggle status favorite
  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    notifyListeners();
  }

  bool isFavorite(String id) {
    return favorites.contains(id);
  }

  Future<bool> editCourse(int id, Course course) async {
  try {
    await repository.updateCourse(id, course);
    await loadCourses(); // Refresh list setelah berhasil
    notifyListeners();
    return true;
  } catch (e) {
    notifyListeners();
    return false;
  }
  }
}