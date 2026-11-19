import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Background message: ${message.messageId}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Notification permission: ${settings.authorizationStatus.name}');
    return settings.authorizationStatus;
  }

  Future<String?> getToken() async {
    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');
    return token;
  }

  /// Token dapat berubah, sehingga perubahan perlu didengarkan.
  void listenTokenRefresh(void Function(String token) onRefresh) {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token diperbarui');
      onRefresh(newToken);
    });
  }

  Future<void> saveTokenToSupabase(String token) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    await Supabase.instance.client.from('device_tokens').upsert({
      'token': token,
      'user_id': user.id,
      'platform': defaultTargetPlatform.name,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<void> init() async {
    final status = await requestPermission();
    if (status == AuthorizationStatus.denied) return;

    final token = await getToken();
    if (token != null) {
      await saveTokenToSupabase(token);
    }

    listenTokenRefresh((newToken) async {
      await saveTokenToSupabase(newToken);
    });
  }
}