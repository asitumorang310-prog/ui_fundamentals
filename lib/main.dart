import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/course_data_source.dart';
import 'services/course_supabase_service.dart'; 
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'screens/home_page.dart';

const String supabaseUrl = 'https://zrzvmvbcavaivqismdto.supabase.co';
const String supabaseAnonKey = 'sb_publishable_-S1U4PTGwXueX3hqoIl1Ng_NmSzzejY';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  final CourseDataSource dataSource = CourseSupabaseService();
  final repository = CourseRepository(dataSource);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseState(repository)..loadCourses(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer Supabase',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
      ),
      home: const HomePage(),
    );
  }
}