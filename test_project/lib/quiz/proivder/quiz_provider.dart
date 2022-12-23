import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/quiz/data/quiz_data.dart';
import 'package:test_project/quiz/model/quiz_model.dart';

enum QuizState {
  loading,
  startGame,
  error,
  gameProgres,
  result,
  score,
}

class QuizProvider extends ChangeNotifier {
  QuizData data = QuizData();
  QuizItem? question;
  int questionIndex = 0;
  List<int> usedQuestions = [];
  String? correctText;

  Future<void> initData() async {
    data.state = QuizState.loading;
    notiy();

    final prefs = await SharedPreferences.getInstance();

    data.score = prefs.getInt('score') ?? 0;

    var json = await rootBundle.loadString("assets/questions.json");
    final jsonResult = jsonDecode(json);

    try {
      data.quiz = QuizItems.fromJson(jsonResult);
    } catch (e) {
      data.state = QuizState.error;
    }

    if (data.state != QuizState.error) data.state = QuizState.startGame;

    notiy();
  }

  notiy() {
    notifyListeners();
  }

  Future clearScore() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('score');
    data.score = 0;
    notiy();
  }

  void startGame() {
    correctText = null;
    usedQuestions = [];
    data.state = QuizState.gameProgres;

    Random random = Random();

    questionIndex = random.nextInt(21) + 1;

    question = data.quiz!.items![questionIndex];
    usedQuestions.add(questionIndex);
    notiy();
  }

  void checkQuestion({int? index}) {
    data.state = QuizState.result;

    if (question!.index != index) {
      correctText = question!.types![question!.index!];
    } else {
      data.score++;
    }

    notiy();
  }

  void nextQuestion() async {
    if (usedQuestions.length == 21) {
      data.state = QuizState.startGame;
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt('score', data.score);
    } else {
      correctText = null;
      data.state = QuizState.gameProgres;

      questionIndex = getNextRandom();

      question = data.quiz!.items![questionIndex];
      usedQuestions.add(questionIndex);
    }
    notiy();
  }

  int getNextRandom() {
    Random random = Random();
    int rand = random.nextInt(21) + 1;

    if (usedQuestions.contains(rand)) rand = getNextRandom();

    return rand;
  }
}


