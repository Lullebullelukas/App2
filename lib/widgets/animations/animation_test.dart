import 'package:flutter/material.dart';
import 'package:fsek_mobile/widgets/animations/fade_animation.dart';
import 'package:fsek_mobile/widgets/animations/rotation_animation.dart';
import 'package:fsek_mobile/widgets/animations/scale_animation.dart';
import 'package:fsek_mobile/widgets/animations/size_animation.dart';
import 'package:fsek_mobile/widgets/animations/slide_animation.dart';

class AnimationPage extends StatelessWidget {
  final List<Widget> routes = [SlideAnimation(), FadeAnimation(), ScaleAnimation(), SizeAnimation(), RotationAnimation()];
  final List<String> animationTypeList = ["slide", "fade", "scale", "size", "rotation"];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Page Tranaction")),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => routes[index]));
                },
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  child: Text("${index + 1}"),
                ),
                title: Text(animationTypeList[index].toString()),
              ),
            ),
          );
        },
        itemCount: animationTypeList.length,
      ),
    );
  }
}
