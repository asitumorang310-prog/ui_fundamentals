import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_keys.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://zrzvmvbcavaivqismdto.supabase.co',
    anonKey: 'sb_publishable_-S1U4PTGwXueX3hqoIl1Ng_NmSzzejY',
  );

  runApp(const KosFinderApp());
}

class KosFinderApp extends StatelessWidget {
  const KosFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KosFinder',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messengerKey,
      // Gunakan FutureBuilder untuk menunggu pemulihan sesi Supabase
      home: FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 100)),
        builder: (context, snapshot) {
          // Selagi menunggu sekejap, tampilkan indikator loading agar tidak putih polos
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // Setelah siap, cek apakah user sudah login
          return AuthService.instance.isLoggedIn
              ? const HomePage()
              : const LoginPage();
        },
      ),
    );
  }
}