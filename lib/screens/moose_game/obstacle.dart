import 'package:vector_math/vector_math.dart';


import 'package:fsek_mobile/screens/moose_game/game_object.dart';

import 'sprite.dart';

List<Sprite> possibleSprites = [
  Sprite("assets/img/moose_game/kiosk.png", 24, 24),
  Sprite("assets/img/moose_game/f_rubik_2.png", 24, 24),
  Sprite("assets/img/moose_game/v_nails.png", 24, 24),
  Sprite("assets/img/moose_game/bike.png", 24, 24),
  Sprite("assets/img/moose_game/scooter.png", 24, 24),
];

class Obstacle extends GameObject {
  Obstacle(double xPosition, double floorY)
      : super(Vector2(xPosition, floorY)) {
    sprite = possibleSprites[4]; //Random().nextInt(possibleSprites.length)
  }

  @override
  void update(double deltaTime) {}
}
