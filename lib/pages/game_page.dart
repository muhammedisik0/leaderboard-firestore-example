import 'dart:async';

import 'package:flutter/material.dart';

import 'package:tap_right_color/models/color_model.dart';
import 'package:tap_right_color/models/user_model.dart';
import 'package:tap_right_color/services/firestore_db_service.dart';
import 'package:tap_right_color/widgets/circle.dart';

enum QuestionType { circle, icon }

class GamePage extends StatefulWidget {
  const GamePage({
    Key? key,
    required this.username,
  }) : super(key: key);

  final String username;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Timer timer;
  int duration = 10;
  int score = 0;

  List<ColorModel> listOfColorModels = [
    ColorModel(color: Colors.amber, colorName: 'yellow'),
    ColorModel(color: Colors.purple, colorName: 'purple'),
    ColorModel(color: Colors.blue, colorName: 'blue'),
  ];

  List<int> indexes = [0, 1, 2];

  List<Enum> questionTypes = [QuestionType.circle, QuestionType.icon];

  late Enum questionType;
  late ColorModel askedColor;

  late Color iconColor1;
  late Color iconColor2;
  late Color iconColor3;

  late Color circleColor1;
  late Color circleColor2;
  late Color circleColor3;

  Color borderColor = Colors.black;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      startTimer();
    });
    setQuestion();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(border: Border.all(width: 4)),
                alignment: Alignment.center,
                child: Text('$duration', style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(height: 20),
              duration > 0
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Tap the ${askedColor.colorName} ${questionType.toString().substring(13)}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    )
                  : const SizedBox(),
              Container(
                height: 140,
                decoration: BoxDecoration(border: Border.all(color: borderColor, width: 4)),
                alignment: Alignment.center,
                child: duration > 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Circle(
                            color: circleColor1,
                            iconColor: iconColor1,
                            onTap: () => onTapCircle(circleColor1, iconColor1),
                          ),
                          Circle(
                            color: circleColor2,
                            iconColor: iconColor2,
                            onTap: () => onTapCircle(circleColor2, iconColor2),
                          ),
                          Circle(
                            color: circleColor3,
                            iconColor: iconColor3,
                            onTap: () => onTapCircle(circleColor3, iconColor3),
                          )
                        ],
                      )
                    : const Text('TIME IS OVER', style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(height: 20),
              Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(border: Border.all(width: 4)),
                alignment: Alignment.center,
                child: Text('$score', style: const TextStyle(fontSize: 24)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> startTimer() async {
    if (duration < 1) {
      timer.cancel();
      borderColor = Colors.black;
      savePlayerToFirestore();
    } else {
      setState(() => duration--);
    }
  }

  void onTapCircle(Color circleColor, iconColor) {
    checkAnswer(circleColor, iconColor);
    setQuestion();
    setState(() {});
  }

  void checkAnswer(Color circleColor, iconColor) {
    final int tempScore = score;
    switch (questionType) {
      case QuestionType.circle:
        if (circleColor == askedColor.color) {
          score += 10;
        } else {
          score -= 10;
        }
        break;
      case QuestionType.icon:
        if (iconColor == askedColor.color) {
          score += 10;
        } else {
          score -= 10;
        }
        break;
    }

    if (score > tempScore) {
      borderColor = Colors.green;
    } else {
      borderColor = Colors.red;
    }
    Future.delayed(const Duration(milliseconds: 50), () {
      borderColor = Colors.black;
    });
  }

  void setQuestion() {
    listOfColorModels.shuffle();
    askedColor = listOfColorModels.first;

    questionTypes.shuffle();
    questionType = questionTypes.first;

    indexes.shuffle();
    iconColor1 = listOfColorModels[indexes[0]].color;
    iconColor2 = listOfColorModels[indexes[1]].color;
    iconColor3 = listOfColorModels[indexes[2]].color;

    indexes.shuffle();
    circleColor1 = listOfColorModels[indexes[0]].color;
    circleColor2 = listOfColorModels[indexes[1]].color;
    circleColor3 = listOfColorModels[indexes[2]].color;

    while (circleColor1 == iconColor1 || circleColor2 == iconColor2 || circleColor3 == iconColor3) {
      indexes.shuffle();
      circleColor1 = listOfColorModels[indexes[0]].color;
      circleColor2 = listOfColorModels[indexes[1]].color;
      circleColor3 = listOfColorModels[indexes[2]].color;
    }
  }

  Future<void> savePlayerToFirestore() async {
    final List docs = await FirestoreDbService().getDocs();
    final Player lowestScoredPlayer = Player.fromJson(docs.last.data());

    if (docs.length < 10) {
      await FirestoreDbService().setNewScore({
        'username': widget.username,
        'score': score,
      });
    } else if (score > lowestScoredPlayer.score) {
      await FirestoreDbService().deleteLowestScoredPlayer(lowestScoredPlayer.score);
      await FirestoreDbService().setNewScore({
        'username': widget.username,
        'score': score,
      });
    }
  }
}
