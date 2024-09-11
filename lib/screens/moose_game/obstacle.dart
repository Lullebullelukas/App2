import 'dart:math';
import 'package:vector_math/vector_math.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'dart:ui';

import 'package:fsek_mobile/screens/moose_game/game_object.dart';

import 'sprite.dart';

List<Sprite> possibleSprites = [
  Sprite("assets/img/moose_game/kiosk.png", 24, 24),
  Sprite("assets/img/moose_game/f_rubik.png", 24, 24),
  Sprite("assets/img/moose_game/v_nails.png", 24, 24),
];

class Obstacle extends GameObject {

  Obstacle(double xPosition, double floorY) : super(Vector2(xPosition, floorY)) {
    sprite = possibleSprites[Random().nextInt(possibleSprites.length)];
  }

  @override
  void update(double deltaTime) {
    
  }
}