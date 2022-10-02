import 'package:flutter/material.dart';
import 'package:tap_right_color/models/user_model.dart';
import 'package:tap_right_color/services/firestore_db_service.dart';

class HighestScoresPage extends StatefulWidget {
  const HighestScoresPage({Key? key}) : super(key: key);

  @override
  State<HighestScoresPage> createState() => _HighestScoresPageState();
}

class _HighestScoresPageState extends State<HighestScoresPage> {
  List<Player> listOfPlayers = [];

  @override
  void initState() {
    super.initState();
    getPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
        child: Column(
          children: [
            const Text(
              'Highest Scores',
              style: TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 20),
            ListView.separated(
              itemCount: listOfPlayers.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: ((context, index) {
                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Text(
                            '#${index + 1}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 10),
                          CircleAvatar(
                            backgroundColor: avatarBgColor(index),
                            minRadius: 20,
                            child: const Icon(Icons.person),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            listOfPlayers[index].username,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${listOfPlayers[index].score}',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ],
                );
              }),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getPlayers() async {
    final List docs = await FirestoreDbService().getDocs();
    for (var element in docs) {
      listOfPlayers.add(Player.fromJson(element.data()));
    }
    setState(() {});
  }

  Color avatarBgColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xffffd700);
      case 1:
        return const Color(0xffc0c0c0);
      case 2:
        return const Color(0xffcd7f32);
      default:
        return Colors.deepPurple;
    }
  }
}
