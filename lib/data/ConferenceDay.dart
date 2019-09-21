import 'Room.dart';

class ConferenceDay {
  final DateTime date;
  List<Room> rooms;

  ConferenceDay(this.date, this.rooms);

  factory ConferenceDay.fromJson(Map<String, dynamic> days) {
    return ConferenceDay(
        DateTime.parse(days["date"]),
        days["rooms"].map<Room>((json) => Room.fromJson(json)).toList()
    );
  }

}