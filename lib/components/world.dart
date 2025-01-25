import 'dart:async';
import 'package:flame/components.dart';
import 'package:zombies/assets.dart';
import 'package:zombies/zombies_game.dart';

import 'components.dart';

class ZombieWorld extends World with HasGameRef<ZombieGame> {
  ZombieWorld({super.children});

  final List<Land> lands = [];
  late final Player _player;

  Player get player => _player;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    // final greenLandImage = gameRef.images.fromCache(
    //   Assets.assets_town_tile_0000_png,
    // );
    add(
      GreenLand(
        position: Vector2.all(0),
        // sprite: Sprite(greenLandImage),
      ),
    );

    final playerImage = gameRef.images.fromCache(
      Assets.assets_characters_Adventurer_Poses_adventurer_action1_png,
    );

    _player = Player(
      position: Vector2.all(0),
      sprite: Sprite(
        playerImage,
      ),
    );

    add(_player);

    gameRef.cameraComponent.follow(_player);
  }
}
