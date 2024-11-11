import 'dart:math';
import 'dart:ui';
import 'package:vector_math/vector_math.dart';

import 'package:fsek_mobile/screens/moose_game/game_object.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/theme.service.dart';
import 'package:fsek_mobile/screens/moose_game/obstacle_def.dart';

import 'sprite.dart';

List<ObstacleDef> obstacles = [
  ObstacleDef(Sprite(locator<ThemeService>().theme.brightness == Brightness.light ? 
    "assets/img/moose_game/kiosk.png" :
    "assets/img/moose_game/kiosk_d.png", 24, 24), 1.0),
  ObstacleDef(Sprite(locator<ThemeService>().theme.brightness == Brightness.light ? 
    "assets/img/moose_game/v_nails.png" :
    "assets/img/moose_game/v_nails_d.png", 24, 24), 1.0),
  ObstacleDef(Sprite(locator<ThemeService>().theme.brightness == Brightness.light ? 
    "assets/img/moose_game/f_rubik_2.png" :
    "assets/img/moose_game/f_rubik_2_d.png", 24, 24), 1.0),
  ObstacleDef(Sprite(locator<ThemeService>().theme.brightness == Brightness.light ? 
    "assets/img/moose_game/bike_l.png" :
    "assets/img/moose_game/bike_l_d.png", 24, 24), 0.4, 1.0, 2.0,
  ),
  ObstacleDef(Sprite(locator<ThemeService>().theme.brightness == Brightness.light ? 
    "assets/img/moose_game/bike_r.png" :
    "assets/img/moose_game/bike_r_d.png", 24, 24), 0.2, -1.0, -2.0,
  ),
  ObstacleDef(Sprite(locator<ThemeService>().theme.brightness == Brightness.light ? 
    "assets/img/moose_game/scooter_l.png" :
    "assets/img/moose_game/scooter_l_d.png", 24, 24), 0.4, 1.0, 2.0,
  ),
  ObstacleDef(Sprite(locator<ThemeService>().theme.brightness == Brightness.light ? 
    "assets/img/moose_game/scooter_r.png" :
    "assets/img/moose_game/scooter_r_d.png", 24, 24), 0.2, -1.0, -2.0,
  ),
];

Brightness savedBrightness = locator<ThemeService>().theme.brightness;

class Obstacle extends GameObject {
  double movementSpeed = 0.0;

  double get speed {
    return movementSpeed;
  }

  Obstacle(double xPosition, double floorY)
      : super(Vector2(xPosition, floorY)) {
    randomize();
  }

  void reloadSprites() {
    obstacles = [
      ObstacleDef(Sprite(locator<ThemeService>().theme.brightness == Brightness.light ? 
        "assets/img/moose_game/kiosk.png" :
        "assets/img/moose_game/kiosk_d.png", 24, 24), 1.0),
      ObstacleDef(Sprite(locator<ThemeService>().theme.brightness == Brightness.light ? 
        "assets/img/moose_game/v_nails.png" :
        "assets/img/moose_game/v_nails_d.png", 24, 24), 1.0),
      ObstacleDef(Sprite(locator<ThemeService>().theme.brightness == Brightness.light ? 
        "assets/img/moose_game/f_rubik_2.png" :
        "assets/img/moose_game/f_rubik_2_d.png", 24, 24), 1.0),
      ObstacleDef(Sprite(locator<ThemeService>().theme.brightness == Brightness.light ? 
        "assets/img/moose_game/bike_l.png" :
        "assets/img/moose_game/bike_l_d.png", 24, 24), 0.4, 1.0, 2.0,
      ),
      ObstacleDef(Sprite(locator<ThemeService>().theme.brightness == Brightness.light ? 
        "assets/img/moose_game/bike_r.png" :
        "assets/img/moose_game/bike_r_d.png", 24, 24), 0.2, -1.0, -2.0,
      ),
      ObstacleDef(Sprite(locator<ThemeService>().theme.brightness == Brightness.light ? 
        "assets/img/moose_game/scooter_l.png" :
        "assets/img/moose_game/scooter_l_d.png", 24, 24), 0.4, 1.0, 2.0,
      ),
      ObstacleDef(Sprite(locator<ThemeService>().theme.brightness == Brightness.light ? 
        "assets/img/moose_game/scooter_r.png" :
        "assets/img/moose_game/scooter_r_d.png", 24, 24), 0.2, -1.0, -2.0,
      ),
    ];
  }

  void randomize() {
    if (locator<ThemeService>().theme.brightness != savedBrightness) {
      savedBrightness = locator<ThemeService>().theme.brightness;
      reloadSprites();
    }

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
