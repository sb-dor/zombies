import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:zombies/assets.dart';
import 'package:zombies/zombies_game.dart';

abstract class Land extends SpriteComponent {
  Land({super.position, super.sprite})
      : super(
          size: Vector2.all(64),
          anchor: Anchor.center,
        );
}

class GreenLand extends Land {
  GreenLand({
    super.position,
  }) : super(
          sprite: Sprite(
            Flame.images.fromCache(Assets.assets_town_tile_0000_png),
          ),
        );
}
