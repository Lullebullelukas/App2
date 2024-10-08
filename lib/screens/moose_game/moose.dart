import 'dart:ui';

import 'package:fsek_mobile/screens/moose_game/game_object.dart';
import 'package:fsek_mobile/screens/moose_game/sprite.dart';
import 'package:vector_math/vector_math.dart';

enum MooseState { running, jumping, ducking, falling }

class Moose extends GameObject {
  Sprite mooseRun1 =
      Sprite("assets/img/moose_game/hilbert_pixel_run_1.png", 24, 24);
  Sprite mooseRun2 =
      Sprite("assets/img/moose_game/hilbert_pixel_run_2.png", 24, 24);
  Sprite mooseRun3 =
      Sprite("assets/img/moose_game/hilbert_pixel_run_3.png", 24, 24);
  Sprite mooseRun4 =
      Sprite("assets/img/moose_game/hilbert_pixel_run_4.png", 24, 24);
  Sprite mooseJump =
      Sprite("assets/img/moose_game/hilbert_pixel_jump.png", 24, 24);
  Sprite mooseFall =
      Sprite("assets/img/moose_game/hilbert_pixel_fall.png", 24, 24);
  Sprite mooseDuck =
      Sprite("assets/img/moose_game/hilbert_pixel_duck.png", 24, 24);

  double yVelocity = 0;
  final double jumpForce = 20;
  final double gravity = 38;
  final double lowGrav = 10;
  double yGrav = 0;
  double coyoteJump = 0;
  MooseState state = MooseState.running;
  int runFrame = 0;
  double runTimer = 0;
  late double floorY;
  late double gameSpeed;

  Moose(double xPosition, this.floorY) : super(Vector2(xPosition, floorY)) {
    sprite = mooseRun1;
    yGrav = lowGrav;
  }

  @override
  void update(double deltaTime) {
    position.y += yVelocity * deltaTime;
    if (position.y - floorY <= 0) {
      position.y = floorY;
      yVelocity = 0;
      yGrav = lowGrav;
      state = MooseState.running;

      // This code is for animating the moose's movement. It's not pretty, but it works
      runTimer += 2.7 * gameSpeed * deltaTime;
      if (runTimer >= 1.0) {
        runTimer -= 1.0;
        runFrame = (runFrame + 1) % 4;

        switch (runFrame) {
          case 0:
            sprite = mooseRun1;
            break;
          case 1:
            sprite = mooseRun2;
            break;
          case 2:
            sprite = mooseRun3;
            break;
          case 3:
            sprite = mooseRun4;
            break;
        }
      }
    } else {
      if (state == MooseState.jumping) {
        // Gravity depends on velocity; at the peak of the jump, gravity is lowered to create a more floaty, controlled jump.
        yGrav = lerpDouble(
            gravity, lowGrav, 1.0 / (1.0 + 0.5 * yVelocity * yVelocity))!;
      }
      yVelocity -= yGrav * deltaTime;
      // Switch to falling animation when the moose has enough downwards velocity
      if (yVelocity <= -3) {
        sprite = mooseFall;
      }
    }
    // Coyote time allows player to jump even if they tap up to 0.1 seconds before landing.
    // This is not a mid air jump, the actual jump begins the moment the player hits the ground and the jump() method is called
    coyoteJump -= deltaTime;
    if (coyoteJump > 0.0) {
      jump();
      return;
    }
  }

  // This is the function triggered when the player taps their screen.
  void triggerJump() {
    if (yVelocity <= 0) {
      coyoteJump = 0.1;
    }
  }

  // This function triggers when the player hits (or is at) the ground at most 0.1 seconds after pressing the jump button
  void jump() {
    if (state != MooseState.jumping && state != MooseState.falling) {
      state = MooseState.jumping;
      yVelocity = 10;
      sprite = mooseJump;
    }
  }

  // When the player untaps their screen, the moose should have a lower and less floaty jump
  void triggerFall() {
    if (state == MooseState.jumping) {
      state = MooseState.falling;
      yGrav = gravity;
      if (yVelocity >= 0) {
        yVelocity *= 0.65;
      }
    }
  }

  void reset() {
    yVelocity = 0;
    state = MooseState.running;
    position.y = floorY;
  }
}
