class Speaker {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String bio;
  final String tagLine;
  final String profilePicture;

  Speaker(this.id, this.firstName, this.lastName, this.fullName, this.bio, this.tagLine, this.profilePicture);

  factory Speaker.fromJson(Map<String, dynamic> speaker) {
    return Speaker(
        speaker["id"],
        speaker["firstName"],
        speaker["lastName"],
        speaker["fullName"],
        speaker["bio"],
        speaker["tagLine"],
        speaker["profilePicture"]
    );
  }

  factory Speaker.fromChet() {
    return Speaker(
        "IM-CHET",
        "Chet",
        "Haase",
        "Chet Haase",
        "I work with external developers to help them create great Android applications, and to understandwhat they need from Android in order to do that.",
        "Android Chief Advocate",
        "https://droidcon.gr/wp-content/uploads/2019/08/chet_headshot_orig.jpg"
    );
  }

  factory Speaker.fromRomain() {
    return Speaker(
        "IM-ROMAIN",
        "Romain",
        "Guy",
        "Romain Guy",
        "Romain manages the Android Toolkit lead at Google. His team is responsible for the Jetpack libraries — including Jetpack Compose a new upcoming UI Toolkit for Android —, the Android UI Toolkit, text, graphics and various other things aimed to help developers build high-quality applications more easily.",
        "Android Toolkit Lead",
        "https://droidcon.gr/wp-content/uploads/2019/09/romain_guy-150x150.jpeg"
    );
  }
}