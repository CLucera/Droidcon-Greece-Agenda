import 'Session.dart';

class Room {
  final String name;
  final List<Session> talks;

  Room(this.name, this.talks);

  factory Room.fromJson(Map<String, dynamic> room) {
    return Room(
        room["name"],
        room["sessions"].map<Session>((json) => Session.fromJson(json)).toList()
    );
  }
}