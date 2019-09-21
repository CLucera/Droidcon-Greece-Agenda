import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ColorScheme.dart';
import 'data/Room.dart';
import 'data/Session.dart';
import 'data/Speaker.dart';

class DetailRoute extends StatelessWidget {
  final Room room;
  final Session session;
  final List<Speaker> speakers;
  final DateFormat timeFormatter = DateFormat.jm();

  DetailRoute(this.room, this.session, this.speakers, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(room.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              _openMap(room);
            },
          )
        ],
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            Text(
              session.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title,
            ),
            Container(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              speakers.map((speaker) => SpeakerWidget(speaker)).toList(),
            ),
            Container(height: 20),
            GestureDetector(
              onTap: () => _openMap(room),
              child: Text(
                "${room.name}\n${timeFormatter.format(session.startTime)} - ${timeFormatter.format(session.endTime)}",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .title
                    .apply(color: mainColorDark),
              ),
            ),
            Container(height: 20),
            Text(
              session.description,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  _openMap(Room room) async {
    String url = "";
    if (room.name.toLowerCase().contains("h2b")) {
      url =
      "https://www.google.com/maps/search/?api=1&query=H2B+Hub%2C+Heraklion";
    } else {
      url =
      "https://www.google.com/maps/search/?api=1&query=Ibis+Style%2C+Heraklion";
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class SpeakerWidget extends StatelessWidget {
  final Speaker speaker;

  const SpeakerWidget(this.speaker, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return BioWidget(speaker);
              });
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Hero(
                tag: speaker.id,
                child: Container(
                    margin: EdgeInsets.all(8),
                    height: 80,
                    width: 80,
                    decoration: (speaker.profilePicture != null)
                        ? BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image:
                            new NetworkImage(speaker.profilePicture)))
                        : null),
              ),
              Text(
                speaker.fullName,
                style: Theme.of(context).textTheme.subtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BioWidget extends StatelessWidget {
  final Speaker speaker;

  const BioWidget(this.speaker, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Card(
          child: Stack(children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(8),
                      height: 80,
                      width: 80,
                      decoration: (speaker.profilePicture != null)
                          ? BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image:
                              new NetworkImage(speaker.profilePicture)))
                          : null),
                  Text(
                    speaker.fullName,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .apply(color: mainColorDark),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      speaker.tagLine,
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                  ),
                  Text(
                    speaker.bio,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]),
        ),
      ),
    );
  }
}
