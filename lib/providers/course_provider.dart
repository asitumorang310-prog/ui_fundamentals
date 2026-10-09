import 'package:flutter/foundation.dart';

const String studentName = 'Amelia Elsa Syah Fitri Situmorang';
const String studentId = '2415051042';

class CourseState extends ChangeNotifier {
  final Set<String> favorites = {};

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
}