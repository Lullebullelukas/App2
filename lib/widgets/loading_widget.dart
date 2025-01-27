import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            key: Key("loading_widget"),
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          CircleAvatar(
            radius: 36.0,
            backgroundImage: (Theme.of(context).brightness == Brightness.dark
                ? AssetImage("assets/img/f_logo_white.png")
                : AssetImage("assets/img/f_logo.png")),
            backgroundColor: Colors.transparent,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Loading...",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(
                width: 16,
              ),
              CircularProgressIndicator(color: Theme.of(context).primaryColor)
            ],
          )
        ]));
  }
}
