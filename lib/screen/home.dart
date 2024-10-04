import 'package:flutter/material.dart';
import 'package:questionnaire/enum/questionnaire_type.dart';
import 'package:questionnaire/models/questionnaire.dart';
import 'package:questionnaire/widget/greeting.dart';
import 'package:questionnaire/screen/questionnaire.dart';
import 'package:questionnaire/service/questionnaire_service.dart';
import 'package:questionnaire/widget/app_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Questionnaire>? questionnaires;
  Future<bool>? loadAllQuestionnairesFuture;

  @override
  void initState() {
    super.initState();

    loadAllQuestionnairesFuture = loadAllQuestionnaires();
  }

  Future<bool> loadAllQuestionnaires() async {
    final questionnaireService = QuestionnaireService();
    questionnaires = [];
    for (QuestionnaireType questionnaireType in QuestionnaireType.values) {
      final questionnaire =
          await questionnaireService.getQuestionnaire(questionnaireType);

      questionnaires?.add(questionnaire);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: loadAllQuestionnairesFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const TypingText(),
                  const SizedBox(
                    height: 20,
                  ),
                  for (Questionnaire questionnaire in questionnaires!)
                    Button.accent(
                      buttonLabel: "Начать",
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => QuestionnaireScreen(
                            questionnaire: questionnaire,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            );
          } else if (snapshot.hasError ||
              (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data == false)) {
            return AlertDialog(
              title: const Text('Упссс что-то произошло не так!'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Начать заново'),
                  onPressed: () => setState(() {
                    loadAllQuestionnairesFuture = loadAllQuestionnaires();
                  }),
                )
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
