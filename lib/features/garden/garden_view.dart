import 'dart:async';

import 'package:bible_garden/app/providers.dart';
import 'package:bible_garden/features/garden/garden_state.dart';
import 'package:bible_garden/game/art/sprite_library.dart';
import 'package:bible_garden/game/garden_game.dart';
import 'package:bible_garden/game/garden_snapshot.dart';
import 'package:bible_garden/game/logic/garden_layout.dart';
import 'package:flame/game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// O jardim vivo de um livro. Pausa quando a aba não está visível e
/// respeita "reduzir movimento".
class GardenView extends ConsumerStatefulWidget {
  const new({
    required this.book,
    this.editing = false,
    this.onTileTap,
    this.semanticLabel,
    super.key,
  });

  final String book;
  final bool editing;
  final void Function(Tile tile)? onTileTap;
  final String? semanticLabel;

  @override
  ConsumerState<GardenView> createState() => _GardenViewState();
}

class _GardenViewState extends ConsumerState<GardenView> {
  GardenGame? _game;
  GardenSnapshot? _last;
  final SpriteLibrary _library = SpriteLibrary();

  void _ensureGame(GardenSnapshot s) {
    if (_game != null) return;
    _game = GardenGame(
      manifest: ref.read(spriteManifestProvider),
      library: _library,
      snapshot: s,
      onTileTap: (t) => widget.onTileTap?.call(t),
      pixelRatio: MediaQuery.devicePixelRatioOf(context) * 1.6,
    );
    _last = s;
  }

  @override
  void didUpdateWidget(GardenView old) {
    super.didUpdateWidget(old);
    if (old.book != widget.book) {
      _game = null;
      _last = null;
    }
    _game?.editing = widget.editing;
  }

  @override
  void dispose() {
    unawaited(_library.clear());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snap = ref.watch(gardenSnapshotProvider(widget.book));
    final s = snap.value;
    if (s == null) {
      return const AspectRatio(
        aspectRatio: 1,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    _ensureGame(s);
    final game = _game!;
    if (!identical(s, _last)) {
      final celebrate = grew(_last, s);
      _last = s;
      unawaited(game.updateSnapshot(s, celebrate: celebrate));
    }
    game
      ..editing = widget.editing
      ..reducedMotion = MediaQuery.disableAnimationsOf(context);
    final active = TickerMode.valuesOf(context).enabled;
    if (active && game.paused) {
      game.resumeEngine();
    } else if (!active && !game.paused) {
      game.pauseEngine();
    }
    return Semantics(
      label: widget.semanticLabel,
      image: true,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GameWidget(game: game),
        ),
      ),
    );
  }
}
