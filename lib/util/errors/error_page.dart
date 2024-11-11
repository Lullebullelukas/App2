import 'package:flutter/material.dart';
import 'package:fsek_mobile/services/navigation.service.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/util/authentication/authentication_bloc.dart';
import 'package:fsek_mobile/util/authentication/authentication_event.dart';

class ErrorPage extends StatefulWidget {
  ErrorPage({Key? key, this.text, this.authenticationBloc}) : super(key: key);

  final String? text;
  final AuthenticationBloc? authenticationBloc;

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error",
                    style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(
                  height: 6,
                ),
                Text(widget.text!),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  child:
                      Text("Try again", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                  style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    locator<NavigationService>().pop();
                    widget.authenticationBloc!.add(AppStarted());
                  },
                )
              ],
            ))
      ],
    ));
  }
}
