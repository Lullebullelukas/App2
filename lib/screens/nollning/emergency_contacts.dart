import 'package:flutter/material.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/theme.service.dart';
import 'package:linkable/linkable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

//TODO: fixa länkar i texten.

class EmergencyContactsPage extends StatefulWidget {
  @override
  _EmergencyContactsPageState createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  void initState() {
    super.initState();
  }

  TextStyle headerStyle = TextStyle(
    fontSize: 26.0,
    color: Colors.black,
  );
  TextStyle bodyStyle = TextStyle(
    fontSize: 26.0,
    color: Colors.black,
  );
  TextStyle linkStyle = TextStyle(
    color: Colors.blue,
  );
//lägg  in translations för allt nedan!
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.emergencyContacts),
      ),
      body: ListView(
        children: <Widget>[
          _EmergencyText(
            headerPhoneNumber: t.emergencyNumOne,
            headerText: t.emergencyTitleOne,
            bodyText: t.emergencyContentOne,
          ),
          _EmergencyText(
            headerPhoneNumber: t.emergencyNumTwo,
            headerText: t.emergencyTitleTwo,
            bodyText: t.emergencyContentTwo,
          ),
          _EmergencyText(
            headerPhoneNumber: t.emergencyNumThree,
            headerText: t.emergencyTitleThree,
            bodyText: t.emergencyContentThree,
          ),
          _EmergencyText(
            headerPhoneNumber: t.emergencyNumFour,
            headerText: t.emergencyTitleFour,
            bodyText: t.emergencyContentFour,
          ),
          _EmergencyText(
            headerPhoneNumber: t.emergencyNumFive,
            headerText: t.emergencyTitleFive,
            bodyText: t.emergencyContentFive,
          ),
          _EmergencyText(
            headerPhoneNumber: t.emergencyNumSix,
            headerText: t.emergencyTitleSix,
            bodyText: t.emergencyContentSix,
          ),
          _EmergencyText(
            headerPhoneNumber: t.emergencyNumSeven,
            headerText: t.emergencyTitleSeven,
            bodyText: t.emergencyContentSeven,
          ),
          _EmergencyText(
            // Dummy number because this title is different
            headerPhoneNumber: "",
            headerText: t.emergencyTitleEight,
            bodyText: t.emergencyContentEight,
          )
        ],
      ),
    );
  }
}

class _EmergencyText extends StatelessWidget {
  final String headerText;
  final String headerPhoneNumber;
  final String bodyText;

  _EmergencyText(
      {required this.headerPhoneNumber,
      required this.headerText,
      required this.bodyText});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _HeaderText(headerPhoneNumber, headerText),
          _BodyText(bodyText),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String phoneNumber;
  final String text;
  final TextStyle headerNumStyle = TextStyle(
    fontSize: 25.0,
    color: Colors.blue,
  );
  final TextStyle headerStyle = TextStyle(
    fontSize: 25.0,
    color: locator<ThemeService>().theme.textTheme.titleLarge!.color,
  );
  final Color? color = locator<ThemeService>().theme.colorScheme.surfaceVariant;

  Future<void> _launchPhoneNumber(String phoneNumber) async {
    // phoneNumber can safely contain "-", "+" and " "
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  _HeaderText(this.phoneNumber, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () {
            _launchPhoneNumber(phoneNumber);
          },
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: phoneNumber, style: headerNumStyle),
                TextSpan(text: text, style: headerStyle),
              ],
            ),
          ),
        ),
      ),
      color: color,
    );
  }
}

class _BodyText extends StatelessWidget {
  final String text;
  final TextStyle bodyStyle = TextStyle(
    fontSize: 15.0,
    color: Colors.black, // Unused, see below
  );

  _BodyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Linkable(
          text: text,
          style: bodyStyle,
          // linkColor: Colors.blue, // No need to change for now 
          textColor: Theme.of(context).textTheme.bodyMedium!.color, // Actual used color
        ),
      ),
    );
  }
}

