import 'package:flutter/material.dart';
import 'package:fsek_mobile/april_fools.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({Key? key, required this.title, required this.disc})
      : super(key: key);

  final String title;
  final String disc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                  "DENNA SIDAN ÄR INTE TILLGÄNGLIG ÄN MEN SPINDELMÄNNEN "
                  "HÅLLER PÅ ATT KNAPPRA PÅ FÖR FULLT!\n\n $disc",
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary))),
          Image.asset("assets/img/underConstruction.png"),
        ],
      ),
    );
  }
}
