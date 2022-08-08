import 'package:flutter/material.dart';
import 'package:fsek_mobile/models/nollning/nolleguide/person.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PeoplePage extends StatefulWidget {
  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  List<Person> people = [];
  Person? _selectedPerson;
  _PeoplePageState() {
    _loadPeople().then(
      (value) => setState(
        () {
          this.people = value;
          this._selectedPerson = people[0];
        },
      ),
    );
  }

  Future<List<Person>> _loadPeople() async {
    final String raw =
        await rootBundle.loadString('assets/data/guide/people.json');
    Map<String, dynamic> jsonRaw = await json.decode(raw);
    List<Person> out = (jsonRaw['people'] as List)
        .map((data) => Person.fromJson(data))
        .toList();
    return out;
  }

  void setSelectedPerson(Person? p) {
    setState(
      () {
        _selectedPerson = p;
      },
    );
  }

  Widget _createPersonCard(Person p) {
    String imageBasePath = "assets/img/";
    String locale = Localizations.localeOf(context).toString();
    Border? border = null;
    double borderWidth = 5;
    double width = 60;
    double height = 60;
    double margin = 10;
    if (_selectedPerson == p) {
      border = Border.all(color: Colors.orange[600]!, width: borderWidth);
      width += borderWidth;
      height += borderWidth;
      margin -= borderWidth;
    }
    return Container(
      child: InkWell(
        onTap: () => setSelectedPerson(p),
        child: Container(
          margin: EdgeInsets.all(margin),
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: border,
            image: DecorationImage(
              image: AssetImage(
                  imageBasePath + (p.image ?? "underConstruction.png")),
              fit: BoxFit.fill,
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _createMainPersonCard() {
    if (_selectedPerson == null) {
      return Container();
    } else {
      return _MainPersonCard(person: _selectedPerson!);
    }
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.nolleguideWeAtFsek),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...people.map(
                    (Person p) => _createPersonCard(p),
                  ),
                ],
              ),
            ),
            Expanded(child: _createMainPersonCard()),
          ],
        ),
      ),
    );
  }
}

class _MainPersonCard extends StatelessWidget {
  const _MainPersonCard({Key? key, required this.person}) : super(key: key);
  final Person person;

  @override
  build(BuildContext context) {
    String locale = Localizations.localeOf(context).toString();
    String imageBasePath = "assets/img/";
    return Container(
      margin: EdgeInsets.all(20),
      child: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.name![locale]!,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(person.position![locale]!,
                      style: TextStyle(fontSize: 18, color: Colors.white))
                ],
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                    imageBasePath + (person.image ?? "underConstruction.png")),
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          SizedBox(height: 10),
          Text(person.text![locale]!),
        ],
      ),
    );
  }
}