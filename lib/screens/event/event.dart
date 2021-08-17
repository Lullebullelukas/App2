import 'package:flutter/material.dart';
import 'package:fsek_mobile/models/home/event.dart';
import 'package:fsek_mobile/models/home/eventsignup.dart';
import 'package:fsek_mobile/models/home/eventuser.dart';
import 'package:fsek_mobile/models/home/group.dart';
import 'package:fsek_mobile/models/user/user.dart';
import 'package:intl/intl.dart';
import 'package:fsek_mobile/services/event.service.dart';
import 'package:fsek_mobile/services/user.service.dart';
import 'package:fsek_mobile/services/service_locator.dart';
import 'package:fsek_mobile/services/abstract.service.dart';

class EventPage extends StatefulWidget {
  int event_id;
  EventPage({Key? key, required this.event_id}) : super(key: key);
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Event? event;
  String? user_type;
  Group? group;
  String? answer;
  String? custom_group;
  List<String>? food_preferences;
  String? food_custom;
  bool displayGroupInput = true;
  void initState() {
    locator<EventService>()
        .getEvent(widget.event_id)
        .then((value) => setState(() {
              this.event = value;
            }));
    locator<UserService>().getUser().then((value) => setState(() {
          this.food_preferences = value.food_preferences;
          this.food_custom = value.food_custom;
        }));
    super.initState();
  }

  void update() {
    locator<EventService>()
        .getEvent(widget.event_id)
        .then((value) => setState(() {
              this.event = value;
              this.user_type = null;
              this.group = null;
              this.answer = null;
            }));
  }

  void sendSignup() async {
    EventUser eventUser = EventUser(answer, group?.id, custom_group, user_type);
    /* just to be sure */
    if (group?.id != null) {
      custom_group = null;
    }
    int eventId = event?.id ?? -1;
    Map json = await AbstractService.post(
        "/events/" + eventId.toString() + "/event_users",
        mapBody: eventUser.toJson());
    print(json);
    if (!json.containsKey('errors')) {}
    update();
  }

  void removeSignup() async {
    int userId = event?.event_user?.id ?? -1;
    int eventId = event?.id ?? -1;
    Map json = await AbstractService.delete(
      "/events/" + eventId.toString() + "/event_users/" + userId.toString(),
    );

    print(json);
    if (!json.containsKey('errors')) {}
    update();
  }

  Widget userTypeDropDown() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Prioritering:"),
          DropdownButton<String?>(
            isExpanded: true,
            value: user_type,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            onChanged: (String? newValue) {
              setState(() {
                user_type = newValue;
              });
            },
            items: [
              ...?event!.user_types?.map(((List<String> ut) {
                return DropdownMenuItem<String?>(
                  value: ut[1],
                  child: Text(ut[0]),
                );
              })),
              DropdownMenuItem<String?>(
                value: null,
                child: Text("Övrigt"),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget groupDropdown() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Välj grupp:"),
          DropdownButton<Group?>(
            isExpanded: true,
            value: group,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            onChanged: (Group? newValue) {
              setState(() {
                group = newValue;
                if (newValue == null) {
                  displayGroupInput = true;
                } else {
                  displayGroupInput = false;
                }
              });
            },
            items: [
              ...?event!.groups?.map(((Group? g) {
                return DropdownMenuItem<Group?>(
                  value: g,
                  child: Text(g!.name!),
                );
              })),
              DropdownMenuItem<Group?>(
                value: null,
                child: Text("Annan"),
              )
            ],
          ),
          Visibility(
            visible: displayGroupInput,
            child: TextField(
                onChanged: (String? newValue) {
                  setState(() {
                    custom_group = newValue;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Skriv eget gruppnamn",
                )),
          ),
        ],
      ),
    );
  }

  Widget questionInput() {
    if (event?.question == "") {
      return Container();
    }
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(event?.event_signup?.question ?? ""),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              onChanged: (String? newValue) {
                setState(() {
                  answer = newValue;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: event?.event_signup?.question,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget signupInfoWidget() {
    Widget signup;
    /* If no event or no event signup recieved */
    if (event == null || event?.event_signup == null) {
      return Container();
    }

    if (event!.can_signup!) {
      if (event!.event_signup!.open!)
        signup = signupWidget();
      else {
        if (event!.event_signup!.closed!) {
          if (event!.event_user == null) {
            signup = Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Colors.red[300],
                ),
                Text(
                  "Du var inte anmäld",
                  style: TextStyle(
                    color: Colors.red[300],
                  ),
                ),
              ],
            );
          } else {
            String groupName = "";
            if (event!.event_user!.group_id != null) {
              for (int i = 0; i < event!.groups!.length; i++) {
                if (event!.groups![i].id == event!.event_user!.group_id) {
                  groupName = event!.groups![i].name!;
                  break;
                }
              }
            } else {
              groupName = event!.event_user!.group_custom ?? "";
            }
            String userType = event!.event_user!.user_type ?? "Övrigt";
            if (event!.event_user?.reserve ?? false) {
              signup = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Grupp: " + groupName),
                  Text("Prioritet: " + userType),
                  Text((event!.event_signup!.question ?? "") +
                      " " +
                      (event!.event_user!.answer ?? "")),
                  Row(
                    children: [
                      Icon(
                        Icons.cancel,
                        color: Colors.red[300],
                      ),
                      Text(
                        "Du har inte fått plats!",
                        style: TextStyle(
                          color: Colors.red[300],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              signup = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Grupp: " + groupName),
                  Text("Prioritet: " + userType),
                  Text((event!.event_signup!.question ?? "") +
                      " " +
                      (event!.event_user!.answer ?? "")),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green[300],
                      ),
                      Text(
                        "Du har fått plats!",
                        style: TextStyle(
                          color: Colors.green[300],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          }
        } else {
          signup = SizedBox.shrink();
        }
      }
    } else {
      signup = Text("hej");
    }

    return Container(
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Anmälan",
              style: TextStyle(fontSize: 25, color: Colors.orange[600]),
            ),
            const Divider(),
            Row(
              children: [
                Icon(
                  Icons.person,
                ),
                Text(
                  "  Antal anmälda: " + event!.event_user_count!.toString(),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.people,
                ),
                Text(
                  "  Antal platser: " + event!.event_signup!.slots!.toString(),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.event_available_rounded,
                ),
                Text(
                  "  Anmälan öppnar: " +
                      DateFormat("Md").format(event!.event_signup!.opens!) +
                      " " +
                      DateFormat("jm").format(event!.event_signup!.opens!),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.event_busy_rounded,
                ),
                Text(
                  "  Anmälan stänger: " +
                      DateFormat("Md").format(event!.event_signup!.closes!) +
                      " " +
                      DateFormat("jm").format(event!.event_signup!.opens!),
                ),
              ],
            ),
            const Divider(),
            signup,
          ],
        ),
      ),
    );
  }

  Widget signupWidget() {
    if (event == null) {
      if (event?.can_signup ?? false) return Container();
    }

    if (event?.event_user == null) {
      return Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              groupDropdown(),
              userTypeDropDown(),
              questionInput(),
              Row(
                children: [
                  Text("  Matpreffar: "),
                  ...?food_preferences
                      ?.map((food_preferences) => Text(food_preferences + " ")),
                  Text(food_custom ?? ""),
                ],
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: InkWell(
                  onTap: () => sendSignup(),
                  child: Card(
                    color: Colors.orange[400],
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Skicka anmälan",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ));
    } else {
      String groupName = "";
      if (event!.event_user!.group_id != null) {
        for (int i = 0; i < event!.groups!.length; i++) {
          if (event!.groups![i].id == event!.event_user!.group_id) {
            groupName = event!.groups![i].name!;
            break;
          }
        }
      } else {
        groupName = event!.event_user!.group_custom ?? "";
      }
      String userType = event!.event_user!.user_type ?? "Övrigt";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Grupp: " + groupName),
          Text("Prioritet: " + userType),
          Text((event!.event_signup!.question ?? "") +
              " " +
              (event!.event_user!.answer ?? "")),
          Row(
            children: [
              Text("Matpreffar: "),
              ...?food_preferences
                  ?.map((food_preferences) => Text(food_preferences + " ")),
              Text(food_custom ?? ""),
            ],
          ),
          const Divider(),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 50,
              width: 200,
              child: InkWell(
                onTap: () => removeSignup(),
                child: Card(
                  color: Colors.red[400],
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Avanmäl",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (event == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Evenemang'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evenemang'),
      ),
      body: Container(
        width: double.infinity,
        child: Card(
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  event?.title ?? "ingen titel",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.orange[600],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const Divider(),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                  ),
                  Text(
                    /* better error checking */
                    "  " +
                        DateFormat("kk:mm")
                            .format(event?.starts_at ?? DateTime.now()) +
                        " - " +
                        DateFormat("kk:mm")
                            .format(event?.ends_at ?? DateTime.now()) +
                        ", " +
                        DateFormat("MMMMd")
                            .format(event?.starts_at ?? DateTime.now()),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.room,
                  ),
                  Text(
                    "  " + (event?.location ?? "intigheten"),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              const Divider(),
              Container(
                margin: EdgeInsets.all(10),
                /* should be parsed html */
                child: Text(event?.description ?? "ingen beskrivning"),
              ),
              const Divider(),
              Row(children: [
                Text("  Klädkod: "),
                ...?event?.dress_code?.map((dressCode) => Text(dressCode + " "))
              ]),
              Visibility(
                  visible: event!.cash ?? false,
                  child: Text(
                      "  Pris: " + (event?.price?.toString() ?? "") + " kr")),
              const Divider(),
              Visibility(
                visible: event!.cash ?? false,
                child: Row(
                  children: [
                    Icon(Icons.attach_money_rounded),
                    Text("  Kostar pengar")
                  ],
                ),
              ),
              Visibility(
                visible: event!.food ?? false,
                child: Row(
                  children: [
                    Icon(
                      Icons.restaurant_rounded,
                    ),
                    Text("  Mat serveras")
                  ],
                ),
              ),
              Visibility(
                visible: event!.drink ?? false,
                child: Row(
                  children: [
                    Icon(
                      Icons.wine_bar_rounded,
                    ),
                    Text("  Alkohol serveras")
                  ],
                ),
              ),
              Visibility(
                visible: event!.can_signup ?? false,
                child: Row(
                  children: [
                    Icon(
                      Icons.event_rounded,
                    ),
                    Text("  Kräver anmälan")
                  ],
                ),
              ),
              const Divider(),
              signupInfoWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
