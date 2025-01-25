import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:zombies/components/components.dart';

import 'assets.dart';

class ZombieGame extends FlameGame with HasKeyboardHandlerComponents {
  //
  ZombieGame() : _world = ZombieWorld() {
    _cameraComponent = CameraComponent(world: _world);
    images.prefix = '';
  }

  late final CameraComponent _cameraComponent;
  final ZombieWorld _world;

  CameraComponent get cameraComponent => _cameraComponent;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    await images.loadAll([
      Assets.assets_characters_Adventurer_Poses_adventurer_action1_png,
      Assets.assets_town_tile_0000_png,
    ]);

    _cameraComponent.viewfinder.anchor = Anchor.center;

    add(_world);
    add(_cameraComponent);
  }
}
