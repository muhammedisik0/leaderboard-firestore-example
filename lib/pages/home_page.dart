import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tap_right_color/pages/game_page.dart';
import 'package:tap_right_color/pages/highest_scores_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = GetStorage();
  final TextEditingController usernameController = TextEditingController();
  late String username;

  @override
  void initState() {
    super.initState();
    username = storage.read('username') ?? 'player99';
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Column(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.amber,
                      minRadius: 30,
                      child: Icon(Icons.person),
                    ),
                    const SizedBox(height: 5),
                    Text(username),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: saveUsername,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                  child: const Text('OK'),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => GamePage(username: username))),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    primary: Colors.indigoAccent,
                  ),
                  child: const Text('START'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => const HighestScoresPage())),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    primary: Colors.teal,
                  ),
                  child: const Text('HIGHEST SCORES'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveUsername() async {
    if (usernameController.text.isEmpty) return;
    setState(() => username = usernameController.text.trim());
    storage.write('username', username);
    usernameController.clear();
    FocusScope.of(context).unfocus();
  }
}
