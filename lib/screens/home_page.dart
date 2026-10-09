import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'favorites_page.dart';

const String studentName = 'Amelia Elsa Syah Fitri Situmorang';
const String studentId = '2415051042';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseState>().loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseState = context.watch<CourseState>();
    final totalCourses = courseState.courses.length;
    final totalFavorites = courseState.favorites.length;

    final List<Widget> pages = [
      // Tab 0: Home / Dashboard Overview (Boleh pakai SingleChildScrollView)
      SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Text(
                '$studentId • $studentName',
                style: const TextStyle(
                  color: Color(0xFF0D3B66),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Courses', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 6),
                        Text(
                          '$totalCourses',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D3B66)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Favorites', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 6),
                        Text(
                          '$totalFavorites',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D3B66)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Ringkasan Mata Kuliah:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D3B66)),
            ),
            const SizedBox(height: 10),
            // Di tab Home, tidak perlu scroll mandiri karena dibungkus SingleChildScrollView
            _buildCourseListBody(courseState, isScrollable: false),
          ],
        ),
      ),

      // Tab 1: Full Courses List (Menggunakan Expanded agar bisa di-scroll dengan bebas)
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Seluruh Mata Kuliah',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D3B66)),
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildCourseListBody(courseState, isScrollable: true)),
          ],
        ),
      ),

      // Tab 2: Favorites Screen
      const FavoritesPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer v2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
    );
  }

  // Fungsi builder list dengan parameter pengatur scroll
  Widget _buildCourseListBody(CourseState courseState, {required bool isScrollable}) {
    if (courseState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (courseState.error != null) {
      return Center(child: Text('Terjadi error: ${courseState.error}'));
    }
    if (courseState.courses.isEmpty) {
      return const Center(child: Text('Belum ada data course.'));
    }

    return ListView.builder(
      shrinkWrap: !isScrollable,
      physics: isScrollable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
      itemCount: courseState.courses.length,
      itemBuilder: (context, index) {
        return CourseCard(course: courseState.courses[index]);
      },
    );
  }
}