import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'kos_service.dart';

Future<void> securityTest(String kosIdMilikUserA) async {
  final kos = KosService();

  final updated = await kos.update(kosIdMilikUserA, {'name': 'DIUBAH USER B'});
  debugPrint(updated
      ? '[FAIL] User B berhasil mengubah data User A'
      : '[PASS] UPDATE ditolak oleh RLS');

  final deleted = await kos.delete(kosIdMilikUserA);
  debugPrint(deleted
      ? '[FAIL] User B berhasil menghapus data User A'
      : '[PASS] DELETE ditolak oleh RLS');

  try {
    await Supabase.instance.client.from('kos').insert({
      'owner_id': 'UUID_USER_A',
      'name': 'Kos palsu',
    });
    debugPrint('[FAIL] INSERT atas nama user lain berhasil');
  } on PostgrestException catch (e) {
    debugPrint('[PASS] INSERT ditolak: ${e.code} - ${e.message}');
  }
}