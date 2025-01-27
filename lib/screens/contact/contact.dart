import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fsek_mobile/models/contact/contact.dart';
import 'package:fsek_mobile/services/contact.service.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/user.service.dart';
import 'package:fsek_mobile/environments/environment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactPage extends StatefulWidget {
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact>? contacts = [];
  Contact? currentContact;
  String localMessage = "";
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    locator<ContactService>().getContacts().then((value) {
      setState(() {
        contacts = value;
        currentContact = contacts![0];
        contacts!.sort(
            (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    BoxDecoration box = BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.onPrimary)); //default box decoration, could add image for flair

    if (contacts!.isEmpty) {
      return Scaffold(
          appBar: AppBar(
              title: Text(t.contactContact,
                  style: Theme.of(context).textTheme.headlineSmall)),
          body: Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary)));
    }

    //We only want to attempt to fetch a network image if it it's url is not null. Hence map accessing weirdness with nullcheck
    if (currentContact!.avatar!["avatar"]!["thumb"]["url"] != null) {
      box = BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "${Environment.API_URL}${currentContact!.avatar!["avatar"]!["thumb"]["url"].toString()}"),
          ),
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: Theme.of(context).colorScheme.onPrimary));
    }
    return Scaffold(
        appBar: AppBar(
            title: Text(t.contactContact,
                style: Theme.of(context).textTheme.headlineSmall)),
        //Bilder och skit kommer senare
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight),
                  child: Stack(children: <Widget>[
                    Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Container(decoration: box),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(currentContact!.name!,
                              style: Theme.of(context).textTheme.titleMedium)),
                    ),
                  ]),
                ),
              ),
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
                    child: Text(t.contactPerson,
                        style: Theme.of(context).textTheme.titleSmall),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton(
                    autofocus: false,
                    value: currentContact!,
                    isExpanded: true,
                    onChanged: (Contact? contact) {
                      setState(() {
                        currentContact = contact;
                      });
                    },
                    items: contacts!.map((contact) {
                      return DropdownMenuItem(
                          child: Text(contact.name!), value: contact);
                    }).toList()),
              ),
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 24, 8, 4),
                    child: Text(t.contactDescription,
                        style: Theme.of(context).textTheme.titleSmall),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(8, 6, 8, 0),
                  child: Html(
                      data: currentContact!
                          .text!) //Make into html when that dependency is merged
                  ),
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 24, 8, 4),
                    child: Text(t.contactInfo,
                        style: Theme.of(context).textTheme.titleSmall),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 6, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: "Email: ",
                          style: Theme.of(context).textTheme.bodyMedium),
                      TextSpan(
                          text: currentContact!.email!,
                          style: Theme.of(context).textTheme.bodyMedium)
                    ])),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: t.contactHeldBy,
                          style: Theme.of(context).textTheme.bodyMedium),
                      TextSpan(
                          text: _getPostUserNames(),
                          style: Theme.of(context).textTheme.bodyMedium)
                    ]))
                  ],
                ),
              ),
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 24, 8, 4),
                    child: Text(t.contactMessage,
                        style: Theme.of(context).textTheme.titleSmall),
                  )),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: TextField(
                    autofocus: false,
                    controller: controller,
                    maxLines: 4,
                    decoration:
                        InputDecoration(hintText: t.contactWriteMessage),
                    onChanged: (input) => localMessage = input,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 30,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant),
              ),
              Container(
                  width: double.infinity,
                  height: 50,
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight),
                    child: InkWell(
                        child: Center(
                            child: Text(
                          t.contactSend,
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary
                          ),
                        )),
                        onTap: () => _sendMessage(localMessage)),
                  )),
              Container(
                width: double.infinity,
                height: 30,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant),
              ),
            ],
          ),
        ));
  }

  String _getPostUserNames() {
    List<String> names = currentContact!.users!.map((user) => user).toList();
    return names.length != 0 ? names.join(", ") : "V.A. Kant";
  }

  void _sendMessage(String messageBody) {
    if (messageBody == "") {
      _emptyPopup();
      return;
    }
    locator<UserService>().getUser().then((user) async {
      try {
        Map<String, dynamic> message = Map();
        message["name"] = user.firstname! + " " + user.lastname!;
        message["email"] = user.email!;
        message["message"] = messageBody;
        //Message has to be wrapped to be accepted by api
        await locator<ContactService>()
            .sendMessage({"contact_message": message}, currentContact!.id!);
        controller.clear();
        _successPopup();
        setState(() {
          localMessage = "";
        });
      } catch (error) {
        _failPopup();
      }
    });
  }

  void _successPopup() {
    var t = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    showDialog(
        context: context, builder: _popUp("Yay!!", t.contactHasBeenSent));
  }

  void _failPopup() {
    var t = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    showDialog(
        context: context, builder: _popUp("Oh no!", t.contactHasNotBeenSent));
  }

  void _emptyPopup() {
    var t = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    showDialog(context: context, builder: _popUp("Hmmm", t.contactEmpty));
  }

  Widget Function(BuildContext) _popUp(String title, String text) {
    return (BuildContext contact) => SimpleDialog(
          title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text(text, style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  icon: Icon(Icons.check, color: Theme.of(context).colorScheme.onBackground),
                  onPressed: () => Navigator.pop(context)),
            )
          ],
        );
  }
}
