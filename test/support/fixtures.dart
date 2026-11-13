import 'dart:io';

import 'package:bible_garden/data/content/content.dart';
import 'package:bible_garden/data/db/db_open.dart';
import 'package:bible_garden/data/repositories/garden_repository.dart';

final GameContent testContent = GameContent.parse(
  File('assets/data/conteudo.json').readAsStringSync(),
);

/// Relógio controlável para os testes.
final class FakeClock {
  new(this.value);
  DateTime value;
  DateTime call() => value;
  void advance(Duration d) => value = value.add(d);
}

GardenRepository memoryRepo(FakeClock clock) =>
    GardenRepository(openMemoryDatabase(), testContent, clock: clock.call);
