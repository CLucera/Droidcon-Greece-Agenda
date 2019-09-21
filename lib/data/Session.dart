import 'Speaker.dart';

class Session {
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final bool isService;
  final bool isPlenum;
  final List<SessionSpeaker> speakers;

  Session(this.title, this.description, this.startTime, this.endTime, this.isService, this.isPlenum, this.speakers);

  factory Session.fromJson(Map<String, dynamic> session) {
    return Session(
        session["title"],
        session["description"],
        DateTime.parse(session["startsAt"]),
        DateTime.parse(session["endsAt"]),
        session["isServiceSession"],
        session["isPlenumSession"],
        session["speakers"].map<SessionSpeaker>((json) => SessionSpeaker.fromJson(json)).toList()
    );
  }

  factory Session.fromKeynote() {
    Speaker chet = Speaker.fromChet();
    Speaker romain = Speaker.fromRomain();
    return Session(
        "Keynote",
        "Expect the unexpected...",
        DateTime(2019, 9, 27, 19, 0),
        DateTime(2019, 9, 27, 20, 0),
        false,
        true,
        [
          SessionSpeaker(chet.id, chet.fullName),
          SessionSpeaker(romain.id, romain.fullName)
        ]
    );
  }
}

class SessionSpeaker {
  final String id;
  final String name;

  SessionSpeaker(this.id, this.name);

  factory SessionSpeaker.fromJson(Map<String, dynamic> session) {
    return SessionSpeaker(
        session["id"],
        session["name"]
    );
  }

}