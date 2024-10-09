import 'dart:math';
import 'dart:ui';
import 'package:vector_math/vector_math.dart';

import 'package:fsek_mobile/screens/moose_game/game_object.dart';
import 'package:fsek_mobile/screens/moose_game/obstacle_def.dart';

import 'sprite.dart';

List<ObstacleDef> obstacles = [
  ObstacleDef(Sprite("assets/img/moose_game/kiosk.png", 24, 24), 1.0),
  ObstacleDef(Sprite("assets/img/moose_game/v_nails.png", 24, 24), 1.0),
  ObstacleDef(Sprite("assets/img/moose_game/f_rubik_2.png", 24, 24), 1.0),
  ObstacleDef(
    Sprite("assets/img/moose_game/bike_l.png", 24, 24),
    0.4,
    1.0,
    2.0,
  ),
  ObstacleDef(
    Sprite("assets/img/moose_game/bike_r.png", 24, 24),
    0.2,
    -1.0,
    -2.0,
  ),
  ObstacleDef(
    Sprite("assets/img/moose_game/scooter_l.png", 24, 24),
    0.4,
    1.0,
    2.0,
  ),
  ObstacleDef(
    Sprite("assets/img/moose_game/scooter_r.png", 24, 24),
    0.2,
    -1.0,
    -2.0,
  ),
];

class Obstacle extends GameObject {
  double movementSpeed = 0.0;

  double get speed {
    return movementSpeed;
  }

  Obstacle(double xPosition, double floorY)
      : super(Vector2(xPosition, floorY)) {
    randomize();
  }

  void randomize() {
    double totalWeight = 0.0;
    List<double> thresholds = [];
    for (int i = 0; i < obstacles.length; i++) {
      totalWeight += obstacles[i].spawnWeight;
      thresholds.add(totalWeight);
    }
    //print(thresholds);
    double choice = totalWeight * Random().nextDouble();
    //print(choice);
    ObstacleDef def = obstacles[0];
    for (int i = 0; i < obstacles.length; i++) {
      if (choice < thresholds[i]) {
        def = obstacles[i];
        break;
      }
    }
    sprite = def.sprite;
    movementSpeed =
        lerpDouble(def.minSpeed, def.maxSpeed, Random().nextDouble())!;
  }

  @override
  void update(double deltaTime) {}
}
