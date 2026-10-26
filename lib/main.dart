import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/course_api_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'screens/home_page.dart';

const String apiBaseUrl = 'https://course-api-pearl.vercel.app';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<CourseApiService>(
          create: (_) => CourseApiService(apiBaseUrl),
        ),
        ProxyProvider<CourseApiService, CourseRepository>(
          update: (_, service, __) => CourseRepository(service),
        ),
        ChangeNotifierProxyProvider<CourseRepository, CourseState>(
          create: (context) => CourseState(context.read<CourseRepository>()),
          update: (_, repository, previousState) =>
              previousState ?? CourseState(repository),
        ),
      ],
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
      title: 'Course Explorer v2',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
      ),
      home: const HomePage(),
    );
  }
}