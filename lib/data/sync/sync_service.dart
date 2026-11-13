import 'package:bible_garden/data/db/app_database.dart';
import 'package:bible_garden/data/purchases/purchase_service.dart';
import 'package:bible_garden/data/purchases/store_gateway.dart';
import 'package:bible_garden/data/sync/sync_payload.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Sincronização opcional entre aparelhos.
abstract interface class SyncService {
  bool get available;
  Future<void> push();
}

/// Sem servidor configurado: nada sai do aparelho.
final class NoSync implements SyncService {
  const new();

  @override
  bool get available => false;

  @override
  Future<void> push() async {}
}

/// Envia leitura, superfície do jardim e economia para o Supabase. O RLS do
/// servidor garante que cada pessoa só grava o que é dela.
final class SupabaseSync implements SyncService {
  new(this.db, this.client);

  final AppDatabase db;
  final SupabaseClient client;

  @override
  bool get available => client.auth.currentUser != null;

  @override
  Future<void> push() async {
    final user = client.auth.currentUser;
    if (user == null) return;
    final p = await buildSyncPayload(db);
    List<Map<String, Object?>> own(List<Map<String, Object?>> rows) => [
      for (final r in rows) {...r, 'user_id': user.id},
    ];
    await client.from('chapter_reads').upsert(own(p.chapterReads));
    await client.from('garden_surface').upsert(own(p.gardenSurface));
    await client.from('owned_items').upsert(own(p.ownedItems));
    await client
        .from('orvalho_ledger')
        .upsert(
          own(p.ledger),
          onConflict: 'user_id,device_entry_id',
          ignoreDuplicates: true,
        );
  }
}

/// Valida o recibo na Edge Function `validate-receipt` antes de entregar.
final class SupabaseReceiptVerifier implements ReceiptVerifier {
  const new(this.client);

  final SupabaseClient client;

  @override
  Future<bool> verify(StorePurchaseUpdate p) async {
    if (client.auth.currentUser == null) return false;
    final r = await client.functions.invoke(
      'validate-receipt',
      body: {
        'platform': p.source,
        'productId': p.productId,
        'transactionId': p.transactionId,
        'verificationData': p.verificationData,
      },
    );
    final data = r.data;
    return data is Map && data['valid'] == true;
  }
}
