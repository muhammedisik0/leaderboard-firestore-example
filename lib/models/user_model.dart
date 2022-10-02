class Player {
  Player({
    required this.username,
    required this.score,
  });

  late final String username;
  late final int score;

  Player.fromJson(Map json) {
    username = json['username'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['username'] = username;
    data['score'] = score;
    return data;
  }
}
