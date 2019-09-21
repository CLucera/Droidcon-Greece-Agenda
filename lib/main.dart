import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_agenda/ColorScheme.dart';

import 'AgendaRoute.dart';
import 'SplashRoute.dart';
import 'data/ConferenceDay.dart';
import 'data/Session.dart';
import 'data/Speaker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: mainColorSwatch,
      ),
      home: SplashRoute(),
    );
  }
}

Future<List<ConferenceDay>> getDays(BuildContext context) async {
  String sessionsString =
      await DefaultAssetBundle.of(context).loadString("assets/sessions.json");
  String speakerString =
      await DefaultAssetBundle.of(context).loadString("assets/speakers.json");
  final parsedSessions = json.decode(sessionsString);
  final parsedSpeakers = json.decode(speakerString);

  final List<ConferenceDay> days = parsedSessions
      .map<ConferenceDay>((json) => ConferenceDay.fromJson(json))
      .toList();
  final List<Speaker> speakerList =
      parsedSpeakers.map<Speaker>((json) => Speaker.fromJson(json)).toList();
  final HashMap<String, Speaker> speakerMap = HashMap();
  speakerList.forEach((speaker) {
    speakerMap[speaker.id] = speaker;
  });

  //This is Panayotis Tzinis fault!!!
  final Speaker chet = Speaker.fromChet();
  final Speaker romain = Speaker.fromRomain();

  speakerMap[chet.id] = chet;
  speakerMap[romain.id] = romain;
  //End of fix for Panayotis sins

  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
    return AgendaRoute(days, speakerMap);
  }));

  return days;
}

bool isCurrentlyLive(Session session) {
  DateTime now = DateTime.now();
  return now.isAfter(session.startTime) && now.isBefore(session.endTime);
}

Duration timeUntilSession(Session session) {
  DateTime now = DateTime.now();
  return now.difference(session.startTime);
}
