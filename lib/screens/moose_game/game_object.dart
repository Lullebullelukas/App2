import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart';

import 'sprite.dart';

abstract class GameObject {
  late Vector2 position;
  late Sprite sprite;

  GameObject(this.position);

  Widget render(Size pixelSize, double worldScale) {
    return Image.asset(
      sprite.imagePath,
      scale: 1 / worldScale,
      width: pixelSize.width,
      height: pixelSize.height,
      filterQuality: FilterQuality.none,
    );
  }

  void update(double deltaTime);
}
