import 'sprite.dart';

class ObstacleDef {
  late Sprite sprite;
  late double spawnWeight;
  late double minSpeed;
  late double maxSpeed;

  ObstacleDef(sprite, [spawnWeight = 1.0, minSpeed = 0.0, maxSpeed = 0.0]) {
    this.sprite = sprite;
    this.spawnWeight = spawnWeight;
    this.minSpeed = minSpeed;
    this.maxSpeed = maxSpeed;
  }
}
