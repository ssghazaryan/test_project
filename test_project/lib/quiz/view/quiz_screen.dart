import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_project/quiz/proivder/quiz_provider.dart';

class QuizGameScreen extends StatelessWidget {
  const QuizGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuizProvider()..initData(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Quiz Game'),
        ),
        body: Consumer<QuizProvider>(
          builder: (context, provider, child) {
            if (provider.data.state == QuizState.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.data.state == QuizState.startGame) {
              return Center(
                child: Column(
                  children: [
                    if (provider.data.score != 0)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Счет: ${provider.data.score} из ${provider.data.quiz!.items!.length}',
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              CupertinoButton(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  color: Colors.black,
                                  child: Text(
                                    'Сбросить',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    provider.clearScore();
                                  }),
                            ],
                          ),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Хотите начать игру?',
                            style: GoogleFonts.ubuntu(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          CupertinoButton(
                              color: Colors.green,
                              child: Text(
                                'Начать',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ubuntu(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                provider.startGame();
                              }),
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            if (provider.data.state == QuizState.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'К что то пошло не так',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntu(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CupertinoButton(
                        color: Colors.black,
                        child: Text(
                          'Перезагрузить',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ubuntu(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          provider.initData();
                        })
                  ],
                ),
              );
            }

            if (provider.data.state == QuizState.gameProgres) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        provider.question!.title!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    for (int i = 0; i < provider.question!.types!.length; i++)
                      Builder(builder: (context) {
                        final item = provider.question!.types![i];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CupertinoButton(
                              color: Colors.green,
                              child: Text(
                                item,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ubuntu(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                provider.checkQuestion(index: i);
                              }),
                        );
                      }),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              );
            }
            if (provider.data.state == QuizState.result) {
              return Container(
                width: double.infinity,
                color: provider.correctText == null
                    ? Colors.green
                    : Colors.red[900],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        provider.correctText != null
                            ? 'Не правильно, правиильный ответ: ${provider.correctText}'
                            : 'Правильно',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoButton(
                          color: Colors.black,
                          child: Text(
                            provider.usedQuestions.length == 21
                                ? 'Завершить'
                                : 'Дальше',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ubuntu(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            provider.nextQuestion();
                          }),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              );
            }

            if (provider.data.state == QuizState.score) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Счет: ${provider.data.score} из ${provider.usedQuestions.length}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 70, 58, 58),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoButton(
                          color: Colors.black,
                          child: Text(
                            provider.usedQuestions.length == 21
                                ? 'Завершить'
                                : 'Дальше',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ubuntu(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {}),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              );
            }

            return SizedBox();
          },
        ),
      ),
    );
  }
}
