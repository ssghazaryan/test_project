import 'package:test_project/quiz/model/quiz_model.dart';
import 'package:test_project/quiz/proivder/quiz_provider.dart';

class QuizData {
  int? record;
  int score = 0;
  QuizItems? quiz;
  QuizState state = QuizState.loading;
}
