import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DinosaurPage extends StatefulWidget {
  @override
  _DinosaurPageState createState() => _DinosaurPageState();
}

class _DinosaurPageState extends State<DinosaurPage> {
  double obstaclePosition = 0;
  double jumpDist = 80;
  bool canJump = true;
  double jumpTimeMS = 150;
  double mooseYPos = 0;
  double topDist = 300;
  bool teleportPosition = false;
  bool jump = false;
  String spriteLink = "";
  Offset? verticalDragStart;
  final String idleLink = "assets/img/moose_game/hilbert_scaled_idle.png";
  final String duckingLink = "assets/img/moose_game/hilbert_scaled_ducking.png";
  final Color googleDinosaurColor = Color.fromRGBO(83, 83, 83, 1.0);

  int score = 0;

@override
void initState() {
  super.initState();
  Future.delayed(Duration(milliseconds: 1), () => setState(() => obstaclePosition = 350));
  spriteLink = idleLink;
  mooseYPos = jumpDist;
}

  @override
  Widget build(BuildContext context) {

    var t = AppLocalizations.of(context)!;

    Timer timer = Timer(Duration(milliseconds: 100), () => setState(() {
      score += 1;
    }));

    return Scaffold(
      appBar: AppBar(
        title: Text("Dinosaurrrr"),
      ),
      body: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Text(
              '$score',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'VT323'
              ),
            ),
          ),
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragEnd: (details) {
                setState(() {
                  if (details.velocity.pixelsPerSecond.dy > 0) {
                    spriteLink = duckingLink;
                    Future.delayed(Duration(milliseconds: 300), () => spriteLink = idleLink);
                  }
                  else if (canJump) {
                    mooseYPos = 0;
                    canJump = false;
                  }
                });
              },
          ),
          AnimatedPositioned(
            top: mooseYPos,
            duration: Duration(milliseconds: 250),
            curve: Curves.linear,
            onEnd: () {
              setState(() {
                if (mooseYPos == jumpDist) {
                  canJump = true;
                }
                else {
                  mooseYPos = jumpDist;
                }
              });
            },
            child: Image.asset(
                spriteLink,
                height: 60,
                width: 60,
                color: googleDinosaurColor,
              ),
          ),
          AnimatedPositioned(
            top: jumpDist,
            right: obstaclePosition,
            duration: Duration(milliseconds: teleportPosition ? 1 : 1000),
            curve: Curves.linear,
            onEnd: () {
              setState(() {
                if (mooseYPos == jumpDist) {
                  score = 0;
                }
                
                obstaclePosition = 0;
                teleportPosition = true;
                
              });
              Future.delayed(Duration(milliseconds: 1), () {
                setState(() {
                obstaclePosition = 350;
                  teleportPosition = false;
                });
                });
              },
            child: Image.asset(
              "assets/img/moose_game/kiosk.png",
              height: 60,
              width: 60,
              color: googleDinosaurColor
            ),
          ),
        ],
      ),
    );
  }
}
