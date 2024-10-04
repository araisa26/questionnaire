import 'package:flutter/material.dart';
import 'package:questionnaire/widget/app_button.dart';

class ResultScreen extends StatelessWidget {
  final String questionnaireName;
  final String interpretation;

  const ResultScreen(
      {super.key,
      required this.questionnaireName,
      required this.interpretation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(questionnaireName),
      ),
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth * 0.75,
                height: constraints.maxHeight * 0.5,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 40.0, bottom: 20),
                        child: Text(
                          'Твой резуьтат:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          interpretation,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Button.primary(
                          buttonLabel: 'Главный экран',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                    //
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
