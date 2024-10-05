import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/models/answer.dart';
import 'package:questionnaire/models/interpretation.dart';
import 'package:questionnaire/models/question.dart';
import 'package:questionnaire/models/questionnaire.dart';
import 'package:questionnaire/screen/result.dart';
import 'package:questionnaire/widget/app_button.dart';

class QuestionnaireScreen extends StatefulWidget {
  final Questionnaire questionnaire;

  const QuestionnaireScreen({super.key, required this.questionnaire});

  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  List<Question> get questions => widget.questionnaire.questions;
  late int questionIndex;
  Question get currentQuestion => questions[questionIndex];
  int get numberOfQuestions => questions.length;
  late List<int?> chosenAnswers;
  bool get userHasAnsweredCurrentQuestion =>
      chosenAnswers[questionIndex] != null;
  String get instructions => widget.questionnaire.instructions;
  bool questionActive = true;

  String getResultInterpretation() {
    // calculate user's total score
    int result = 0;
    for (int index = 0; index < numberOfQuestions; index++) {
      Question question = questions[index];
      int answerIndex = chosenAnswers[index]!;
      Answer answer = question.answers[answerIndex];
      int score = answer.score;

      result += score;
    }

    // determine interpretation for result
    List<Interpretation> interpretations = widget.questionnaire.interpretations;
    for (Interpretation interpretation in interpretations) {
      if (result >= interpretation.score) {
        return interpretation.text;
      }
    }

    // if something went wrong, return the worst interpretation
    return interpretations.last.text;
  }

  void questionNotActive() {
    questionActive = userHasAnsweredCurrentQuestion ? true : false;
  }

  @override
  void initState() {
    super.initState();
    questionIndex = 0;
    chosenAnswers = List.generate(questions.length, (index) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.questionnaire.name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Text(
                  instructions,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: DotsIndicator(
                          dotsCount: numberOfQuestions,
                          position: questionIndex,
                          decorator: DotsDecorator(
                            size: const Size.square(15),
                            activeSize: const Size(18, 18),
                            activeColor: Theme.of(context).primaryColor,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 8.0),
                        child: Text(
                          currentQuestion.text,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      questionActive == false
                          ? const Padding(
                              padding: EdgeInsets.only(left: 30.0, right: 8.0),
                              child: Text(
                                'Выберите один из вариантов',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.red),
                                textAlign: TextAlign.left,
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        height: 12,
                      ),
                      Column(
                        children: currentQuestion.answers
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = entry.key;
                          String answerText = entry.value.text;

                          return ListTile(
                            title: Text(answerText),
                            leading: Radio<int>(
                              value: index,
                              groupValue: chosenAnswers[questionIndex],
                              onChanged: (int? value) {
                                setState(() {
                                  chosenAnswers[questionIndex] = value!;
                                });
                              },
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Visibility(
                              visible: questionIndex != 0,
                              child: Button.accent(
                                buttonLabel: 'Назад',
                                onPressed: onBackButtonPressed,
                              ),
                            ),
                            Button.primary(
                              buttonLabel: 'Далее',
                              onPressed: () => userHasAnsweredCurrentQuestion
                                  ? onNextButtonPressed()
                                  : setState(() {
                                      questionNotActive();
                                    }),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onNextButtonPressed() {
    if (questionIndex < numberOfQuestions - 1) {
      setState(() {
        questionIndex++;
        questionActive = true;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            questionnaireName: widget.questionnaire.name,
            interpretation: getResultInterpretation(),
          ),
        ),
      );
    }
  }

  void onBackButtonPressed() {
    if (questionIndex > 0) {
      setState(() {
        questionIndex--;
        questionActive = true;
      });
    }
  }
}
