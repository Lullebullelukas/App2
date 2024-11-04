import 'package:vector_math/vector_math.dart';


import 'package:fsek_mobile/screens/moose_game/game_object.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/theme.service.dart';

import 'sprite.dart';

class Ground extends GameObject {
  Sprite groundSprite = Sprite(locator<ThemeService>().theme.brightness == Brightness.light ? 
                              "assets/img/moose_game/ground.png" :
                              "assets/img/moose_game/ground_d.png", 240, 48);
  static const int groundWidth = 10;

  Ground(double xPosition, double floorY) : super(Vector2(xPosition, floorY)) {
    sprite = groundSprite;
  }

  @override
  void update(double deltaTime) {
    
  }
}