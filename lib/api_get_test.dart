
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String apiUrl = 'https://course-api-pearl.vercel.app/courses';

Future<List<dynamic>> fetchCourses() async {
  final response = await http.get(Uri.parse(apiUrl));

  debugPrint('HTTP Status: ${response.statusCode}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;

    debugPrint('Jumlah course: ${data.length}');

    return data;
  }

  throw Exception('HTTP ${response.statusCode}');
}

Future<void> testFetchCourses() async {
  try {
    final courses = await fetchCourses();
    debugPrint(
      'GET berhasil: ${courses.length} course ditemukan.',
    );
  } catch (e) {
    debugPrint('GET gagal: $e');
  }
}
