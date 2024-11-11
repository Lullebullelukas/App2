import 'package:vector_math/vector_math.dart';
import 'package:flutter/material.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/theme.service.dart';
import 'package:fsek_mobile/screens/moose_game/game_object.dart';

import 'sprite.dart';

class Sandwich extends GameObject {
  Sandwich(double xPosition, double floorY)
      : super(Vector2(xPosition, floorY)) {
    sprite = Sprite(locator<ThemeService>().theme.brightness == Brightness.light ?
      "assets/img/moose_game/hilbert_sandwich.png" :
      "assets/img/moose_game/hilbert_sandwich_d.png", 24, 24);
  }

  @override
  void update(double deltaTime) {}
}
