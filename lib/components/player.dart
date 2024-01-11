import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:zombies/assets.dart';
import 'package:zombies/utilities/utilities.dart';
import 'package:zombies/constants.dart';
import 'package:zombies/zombie_game.dart';

class Player extends PositionComponent
    with
        KeyboardHandler,
        HasGameReference<ZombieGame>,
        UnwalkableTerrainChecker,
        CollisionCallbacks {
  Player()
      : super(
          anchor: Anchor.center,
          children: [RectangleHitbox()],
          position: Vector2(worldTileSize * 9.6, worldTileSize * 2.5),
          priority: 1,
          size: Vector2.all(64),
        ) {
    halfSize = size / 2;
  }

  late Vector2 halfSize;
  late Vector2 maxPosition = game.world.size - halfSize;
  Vector2 movement = Vector2.zero();
  double speed = worldTileSize * 4;
  late SpriteAnimationComponent walkingAnimation;
  late SpriteComponent idleComponent;

  @override
  Future<void> onLoad() async {
    final idleSprite = Sprite(game.images.fromCache(
      Assets.assets_characters_Adventurer_Poses_adventurer_idle_png,
    ));
    idleComponent = SpriteComponent(
      sprite: idleSprite,
      size: Vector2.all(64.0),
    );

    final animation = SpriteAnimation.spriteList(
      [
        Sprite(
          game.images.fromCache(
            Assets.assets_characters_Adventurer_Poses_adventurer_walk1_png,
          ),
        ),
        Sprite(
          game.images.fromCache(
            Assets.assets_characters_Adventurer_Poses_adventurer_walk2_png,
          ),
        ),
      ],
      stepTime: 0.15,
    );
    walkingAnimation = SpriteAnimationComponent(
      animation: animation,
      size: Vector2.all(64.0),
    );
    add(idleComponent);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    cleanUpMovement(
      collidingComponent: other,
      intersectionPoints: intersectionPoints,
      predicate: isUnwalkableTerrain,
    );
    super.onCollision(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    lastPosition.setFrom(position);
    // Save this to use after we zero out movement for unwalkable terrain.
    final originalPosition = position.clone();

    Vector2 movementThisFrame = movement * speed * dt;

    // Fake update the position so our anchor calculations take into account
    // what movement we want to do this turn.
    position.add(movementThisFrame);

    // movementThisFrame = checkMovement(
    //   movementThisFrame: movementThisFrame,
    //   predicate: isUnwalkableTerrain,
    // );
    position = originalPosition..add(movementThisFrame);

    if (movementThisFrame.length2 == 0) {
      if (children.contains(walkingAnimation)) {
        remove(walkingAnimation);
      }
      if (!children.contains(idleComponent)) {
        add(idleComponent);
      }
    } else {
      if (!children.contains(walkingAnimation)) {
        add(walkingAnimation);
      }
      if (children.contains(idleComponent)) {
        remove(idleComponent);
      }
    }
    cachedMovementThisFrame
      ..setFrom(position)
      ..sub(lastPosition);
    checkOutOfBounds();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        game.world.isPaused = false;
        return false;
      }
      if (event.logicalKey == LogicalKeyboardKey.space) {
        game.world.isPausing = !game.world.isPausing;
        return false;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyW) {
        movement = Vector2(movement.x, -1);
      }
      if (event.logicalKey == LogicalKeyboardKey.keyS) {
        movement = Vector2(movement.x, 1);
      }
      if (event.logicalKey == LogicalKeyboardKey.keyA) {
        movement = Vector2(-1, movement.y);
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD) {
        movement = Vector2(1, movement.y);
      }
      return false;
    } else if (event is RawKeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyW) {
        movement.y = keysPressed.contains(LogicalKeyboardKey.keyS) ? 1 : 0;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyS) {
        movement.y = keysPressed.contains(LogicalKeyboardKey.keyW) ? -1 : 0;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyA) {
        movement.x = keysPressed.contains(LogicalKeyboardKey.keyD) ? 1 : 0;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD) {
        movement.x = keysPressed.contains(LogicalKeyboardKey.keyA) ? -1 : 0;
      }
      return false;
    }
    return true;
  }
}
