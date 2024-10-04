import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:questionnaire/enum/questionnaire_type.dart';
import 'package:questionnaire/models/questionnaire.dart';

class QuestionnaireService {
  String? _getQuestionnaireAssetPath(QuestionnaireType questionnaireType) {
    switch (questionnaireType) {
      case QuestionnaireType.careerguidance:
        return 'assets/careerguidance.json';
      default:
        return null;
    }
  }

  Future<Questionnaire> getQuestionnaire(
      QuestionnaireType questionnaireType) async {
    final assetPath = _getQuestionnaireAssetPath(questionnaireType);

    final jsonData = await rootBundle.loadString(assetPath ?? '');
    final jsonDataDecoded = jsonDecode(jsonData);
    return Questionnaire.fromJson(jsonDataDecoded);
  }
}
