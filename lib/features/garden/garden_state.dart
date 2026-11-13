import 'dart:async';

import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/core/growth.dart';
import 'package:bible_garden/data/content/content.dart';
import 'package:bible_garden/data/repositories/garden_repository.dart';
import 'package:bible_garden/data/sprites/sprite_manifest.dart';
import 'package:bible_garden/features/shop/purchase_providers.dart';
import 'package:bible_garden/game/garden_snapshot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show StreamProviderFamily;

/// Animais que só aparecem à noite.
const Set<String> nocturnalAnimals = {
  'coruja-torres',
  'coruja-buraqueira',
  'vaga-lume',
};

String? sheetCode(SpriteManifest m, String group, String id) {
  for (final s in m.sheets) {
    if (s.group == group && s.id == id) return s.code;
  }
  return null;
}

/// Monta o retrato do jardim de um livro a partir do banco.
Future<GardenSnapshot> buildSnapshot({
  required GardenRepository repo,
  required GameContent content,
  required SpriteManifest manifest,
  required String book,
  required int chapters,
  bool raining = false,
  String? previewPack,
}) async {
  final owned = await repo.ownedItems();
  final garden = content.livro(book);
  final species = await repo.setting('especie.$book') ?? garden?.arvore;
  final read = await repo.readChapters(book);
  final completions = await repo.completions(book, chapters);
  final beings = <BeingSpec>[];
  for (final a in await repo.animalsFor(book)) {
    final code = sheetCode(manifest, 'Animais', a.animalId);
    if (code == null) continue;
    beings.add(
      BeingSpec(
        code: code,
        id: '${a.garden}:${a.animalId}',
        age: await repo.animalAge(a.animalId, a.garden),
        nocturnal: nocturnalAnimals.contains(a.animalId),
      ),
    );
  }
  final ch = garden == null ? null : content.personagem(garden.personagem);
  if (ch != null && (await repo.boughtCharacters()).contains(ch.id)) {
    final code = sheetCode(manifest, 'Personagens bíblicos', ch.id);
    if (code != null) beings.add(BeingSpec(code: code, id: ch.id));
  }
  return GardenSnapshot(
    book: book,
    plantCode: sheetCode(manifest, 'Plantas', species ?? 'oliveira') ?? 'PL001',
    growth: growthFor(read.length, chapters),
    variant: variantFor(completions),
    beings: beings,
    placements: [
      for (final p in await repo.placements(book))
        PlacedItem(id: p.id, itemId: p.itemId, tile: (x: p.x, y: p.y)),
    ],
    raining: raining,
    ebenezerStones: await repo.ebenezerCount(),
    packs: {
      for (final i in owned)
        if (i.startsWith('pacote:')) i.substring(7),
      ?previewPack,
    },
  );
}

/// Chuva da volta acolhedora (ligada ao abrir o app depois de 3+ dias).
final class WelcomeRain extends Notifier<bool> {
  @override
  bool build() => false;

  void start() => state = true;
  void stop() => state = false;
}

final NotifierProvider<WelcomeRain, bool> welcomeRainProvider =
    NotifierProvider<WelcomeRain, bool>(WelcomeRain.new);

/// Snapshot do jardim, refeito sempre que o banco muda.
final StreamProviderFamily<GardenSnapshot, String> gardenSnapshotProvider =
    StreamProvider.family<GardenSnapshot, String>((ref, book) {
      final repo = ref.watch(gardenRepositoryProvider);
      final content = ref.watch(contentProvider);
      final manifest = ref.watch(spriteManifestProvider);
      final chapters =
          ref.watch(bibleIndexProvider).livro(book)?.capitulos ?? 1;
      final raining = ref.watch(welcomeRainProvider);
      final preview = ref.watch(packPreviewProvider);
      Future<GardenSnapshot> build() => buildSnapshot(
        repo: repo,
        content: content,
        manifest: manifest,
        book: book,
        chapters: chapters,
        raining: raining,
        previewPack: preview,
      );
      final out = StreamController<GardenSnapshot>();
      var pending = false;
      Future<void> emit() async {
        if (pending) return;
        pending = true;
        await Future<void>.delayed(Duration.zero);
        pending = false;
        if (!out.isClosed) out.add(await build());
      }

      unawaited(emit());
      final sub = repo.changes.listen((_) => unawaited(emit()));
      ref.onDispose(() {
        unawaited(sub.cancel());
        unawaited(out.close());
      });
      return out.stream;
    });

/// Ainda tem estágio para crescer (usado para animar a celebração).
bool grew(GardenSnapshot? before, GardenSnapshot after) =>
    before != null && after.stage.index > before.stage.index;
