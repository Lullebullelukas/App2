import 'package:flutter/material.dart';
import 'package:fsek_mobile/models/nollning/nolleguide/person.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PeoplePage extends StatefulWidget {
  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  List<Person> people = [];
  Person? _selectedPerson;
  int? _selectedPersonIndex;
  _PeoplePageState() {
    _loadPeople().then(
      (value) => setState(
        () {
          this.people = value;
          this._selectedPerson = people[0];
          this._selectedPersonIndex = 0;
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
        if (p != null) {
          _selectedPersonIndex = people.indexOf(p);
        } else {
          _selectedPersonIndex = 0;
        }
      },
    );
  }

  Widget _createPersonCard(Person p) {
    String imageBasePath = "assets/img/";
    Border? border;
    double borderWidth = 5;
    double width = 60;
    double height = 60;
    double margin = 10;
    if (_selectedPerson == p) {
      border = Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: borderWidth);
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
      return InkWell(
        onDoubleTap: () => setState(() {
          _selectedPersonIndex = _selectedPersonIndex! + 1;
          if (_selectedPersonIndex! >= people.length) {
            _selectedPersonIndex = 0;
          }
          _selectedPerson = people[_selectedPersonIndex!];
        }),
        child: _MainPersonCard(person: _selectedPerson!),
      );
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
    Widget position = Container();
    if (person.position != null) {
      position = Text(person.position![locale]!,
          style: TextStyle(fontSize: 18, color: Colors.white));
    }
    return Container(
      margin: EdgeInsets.all(20),
      child: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
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
                  position,
                ],
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
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
