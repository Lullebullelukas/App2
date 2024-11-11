import 'package:flutter/material.dart';
import 'april_fools.dart';

class AppBackground extends StatefulWidget {
  AppBackground({Key? key, required this.backgroundColors}) : super(key: key);

  final List<Color> backgroundColors;

  static List<List<double>> backgroundPoints = [
    [1 / 2, 1 / 3, 6 / 7, 0, 2 / 3],
  ];

  _AppBackgroundState createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground> {
  @override
  void initState() {
    TopWaveClipper.tweens = AppBackground.backgroundPoints[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).colorScheme.background,
      ),
      ClipPath(
        clipper: TopWaveClipper(),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          )
          //   gradient: LinearGradient(
          //       colors: widget.backgroundColors, begin: Alignment.centerLeft, end: Alignment.centerRight),
          // ),
          ,
          height: MediaQuery.of(context).size.height / 2,
        ),
      ),
    ]);
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  const TopWaveClipper({Listenable? reclip}) : super(reclip: reclip);

  static List<double> tweens = [];
  @override
  Path getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();
    path.moveTo(size.width, size.height * tweens[0]);

    var firstControlPoint = new Offset(size.width * tweens[1], size.height * tweens[2]);
    var firstEndPoint = new Offset(tweens[3], size.height * tweens[4]);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    ///move from bottom right to top
    path.lineTo(0, 0.0);
    path.lineTo(size.width, 0.0);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
