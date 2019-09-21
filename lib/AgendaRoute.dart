import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'ColorScheme.dart';
import 'DetailRoute.dart';
import 'data/ConferenceDay.dart';
import 'data/Room.dart';
import 'data/Session.dart';
import 'data/Speaker.dart';
import 'main.dart';

class AgendaRoute extends StatelessWidget {
  final List<ConferenceDay> days;
  final HashMap<String, Speaker> speakers;
  final DateFormat dayFormatter = DateFormat.yMMMEd();

  AgendaRoute(this.days, this.speakers, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Tab> tabs = days.map((day) {
      return Tab(text: dayFormatter.format(day.date));
    }).toList();

    final List<DayWidget> daysWidgets = days.map((day) {
      return DayWidget(day, speakers);
    }).toList();

    return DefaultTabController(
      length: days.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: mainColorSwatch,
            tabs: tabs,
          ),
          title: Text('Droidcon Greece Agenda'),
        ),
        body: TabBarView(
          children: daysWidgets,
        ),
      ),
    );
  }
}

class DayTabView extends StatelessWidget {
  final ConferenceDay day;
  final HashMap<String, Speaker> speakers;

  const DayTabView(
    this.day,
    this.speakers, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DayWidget(day, speakers);
  }
}

class DayWidget extends StatefulWidget {
  final ConferenceDay day;
  final HashMap<String, Speaker> speakers;

  const DayWidget(this.day, this.speakers, {Key key}) : super(key: key);

  @override
  _DayWidgetState createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  Room selectedRoom;

  @override
  void initState() {
    super.initState();
    if (widget.day.rooms.length > 1 &&
        widget.day.rooms[1].name.toLowerCase().contains("avengers")) {
      widget.day.rooms = widget.day.rooms.reversed.toList();
    }
    setState(() {
      selectedRoom = widget.day.rooms[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Room> rooms = widget.day.rooms;
    final List<Widget> tabs = [];
    for (int i = 0; i < rooms.length; i++) {
      Room room = widget.day.rooms[i];
      tabs.add(Expanded(
          child: GestureDetector(
        onTap: () {
          setState(() {
            selectedRoom = room;
          });
        },
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16),
            color: selectedRoom == room ? mainColorDark : mainColorLight,
            child: Text(room.name,
                style: Theme.of(context).textTheme.subhead.apply(
                      fontSizeDelta: -4,
                      color:
                          selectedRoom == room ? mainColorLight : mainColorDark,
                    ))),
      )));
    }

    return Column(
      children: <Widget>[
        Row(
          children: tabs,
        ),
        Expanded(child: RoomWidget(selectedRoom, widget.speakers))
      ],
    );
  }
}

class RoomWidget extends StatelessWidget {
  final Room room;
  final HashMap<String, Speaker> speakers;
  final DateFormat timeFormatter = DateFormat.jm();

  RoomWidget(this.room, this.speakers, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.separated(
          itemCount: room.talks.length,
          separatorBuilder: (context, index) {
            return Container(
              height: 2,
              color: neutralBg,
            );
          },
          itemBuilder: (context, index) {
            bool closingKeynote = false;
            Session talk = room.talks[index];
            //Panayotis check
            if (talk.title.toLowerCase() == "chet haase") {
              talk = Session.fromKeynote();
              closingKeynote = true;
            }
            Speaker mainSpeaker =
                talk.speakers.length > 0 ? speakers[talk.speakers[0].id] : null;
            return talk.isService
                ? Container(
                    color: neutralBg,
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                              "${timeFormatter.format(talk.startTime)} - ${timeFormatter.format(talk.endTime)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .subhead
                                  .apply(fontWeightDelta: 3)),
                          Text(talk.title,
                              style: Theme.of(context).textTheme.subhead)
                        ],
                      ),
                    ),
                  )
                : Container(
                    color: isCurrentlyLive(talk)
                        ? mainColorLight
                        : closingKeynote ? starredColor : backgroundGeneral,
                    child: ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return DetailRoute(
                                room,
                                talk,
                                talk.speakers
                                    .map<Speaker>(
                                        (speaker) => speakers[speaker.id])
                                    .toList());
                          }));
                        },
                        isThreeLine: true,
                        contentPadding: EdgeInsets.all(4),
                        title: Text(
                          "${timeFormatter.format(talk.startTime)} - ${timeFormatter.format(talk.endTime)}",
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .apply(fontWeightDelta: 3, color: mainColorDark),
                        ),
                        subtitle: Text(talk.title),
                        leading: mainSpeaker != null
                            ? Hero(
                                tag: mainSpeaker.id,
                                child: Container(
                                    margin: EdgeInsets.only(left: 8),
                                    height: 60,
                                    width: 60,
                                    decoration:
                                        mainSpeaker.profilePicture != null
                                            ? BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: new NetworkImage(
                                                        mainSpeaker
                                                            .profilePicture)))
                                            : null))
                            : Container(
                                margin: EdgeInsets.only(left: 8),
                                height: 60,
                                width: 60)),
                  );
          }),
    );
  }
}
