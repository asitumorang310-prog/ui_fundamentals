import 'package:flutter/material.dart';

// Identitas Wajib
const String studentName = 'Amelia Elsa Syah Fitri Situmorang';
const String studentId = '2415051042';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Tahap 4',
      home: ValueNotifierScreen(),
    );
  }
}

class ValueNotifierScreen extends StatefulWidget {
  const ValueNotifierScreen({super.key});

  @override
  State<ValueNotifierScreen> createState() => _ValueNotifierScreenState();
}

class _ValueNotifierScreenState extends State<ValueNotifierScreen> {
  // 1. Membuat ValueNotifier untuk nilai integer sederhana (jumlah favorite)
  final ValueNotifier<int> _favoriteCounter = ValueNotifier<int>(0);

  @override
  void dispose() {
    _favoriteCounter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 4: ValueNotifier & Builder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            
            // 2. Menampilkan nilai dengan ValueListenableBuilder tanpa setState parent
            ValueListenableBuilder<int>(
              valueListenable: _favoriteCounter,
              builder: (context, value, child) {
                return Card(
                  color: Colors.amber.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Jumlah Kursus Favorit (ValueNotifier):'),
                        Text(
                          '$value',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            
            // 3. Button untuk mengubah value secara langsung
            ElevatedButton.icon(
              onPressed: () {
                _favoriteCounter.value += 1; // Mengubah nilai notifier
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Favorit'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
              onPressed: () {
                if (_favoriteCounter.value > 0) {
                  _favoriteCounter.value -= 1;
                }
              },
              icon: const Icon(Icons.remove),
              label: const Text('Kurangi Favorit'),
            ),
          ],
        ),
      ),
    );
  }
}